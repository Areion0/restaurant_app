import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:restaurant_app/auth/auth_controller.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/models/product.dart';
import 'package:restaurant_app/models/product_gallery.dart';

import '../models/customer_order.dart';
import '../models/gallery_type.dart';

class FirestoreController {
  static Future<QuerySnapshot<Map<String, dynamic>>> getCollection(String collection) {
    var db = FirebaseFirestore.instance;

    return db.collection(collection).get();
  }

  /// Converts a Firestore document snapshot to a Dart object
  static T fromFirestore<T>(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    T Function(Map<String, dynamic> data, String id) fromJson,
  ) {
    if (snapshot.exists) {
      return fromJson(snapshot.data()!, snapshot.id);
    } else {
      throw Exception("Document does not exist");
    }
  }

  /// Converts a Dart object to a Firestore document snapshot
  static Map<String, dynamic> toFirestore<T>(
    T value,
    Map<String, dynamic> Function(T value) toJson,
  ) =>
      toJson(value);

  static Future<List<T>> getCollectionPaginated<T>(
    String collection, {
    int pageSize = 15,
    Map<String, dynamic> filters = const {},
    String orderBy = "date",
    bool descending = true,
    DocumentSnapshot? startAfter,
    Function(DocumentSnapshot?)? onLastDocumentInPage,
    bool group = false,

    /// The function to convert the Firestore document snapshot to a Dart object
    required T Function(Map<String, dynamic> data, String id) fromJson,

    /// The function to convert the Dart object to a Firestore document snapshot
    required Map<String, dynamic> Function(T value) toJson,
  }) async {
    var db = FirebaseFirestore.instance;

    List<T> list = [];

    late Query<T> query;

    if (group) {
      query = db.collectionGroup(collection).withConverter(
            fromFirestore: (snapshot, options) => fromFirestore(snapshot, fromJson),
            toFirestore: (value, options) => toFirestore(value, toJson),
          );
    } else {
      query = db.collection(collection).withConverter(
            fromFirestore: (snapshot, options) => fromFirestore(snapshot, fromJson),
            toFirestore: (value, options) => toFirestore(value, toJson),
          );
    }

    query = query.orderBy(orderBy, descending: descending).limit(pageSize);

    if (filters.isNotEmpty) {
      filters.forEach((key, value) {
        query = query.where(key, isEqualTo: value);
      });
    }

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    var collectionSnapshot = await query.get();
    onLastDocumentInPage?.call(collectionSnapshot.docs.isNotEmpty ? collectionSnapshot.docs.last : null);
    for (var doc in collectionSnapshot.docs) {
      list.add(doc.data());
    }
    return list;
  }

  static Future<Map<String, dynamic>> getDocument(String collection, String id) async {
    var db = FirebaseFirestore.instance;

    Map<String, dynamic> data = {};

    await db.collection(collection).doc(id).get().then((doc) {
      data = doc.data() ?? {};
    });

    return data;
  }

  static Future<List<Map<String, dynamic>>> getDocumentsWhereIn(
    String collection,
    Object field,
    List<String> ids,
  ) async {
    var db = FirebaseFirestore.instance;

    List<Map<String, dynamic>> data = [];

    await db
        .collection(collection)
        .where(field, whereIn: ids)
        .get()
        .then((query) => data = query.docs.map((e) => e.data()).toList());

    return data;
  }

  static Future<void> addDocument({
    String? docName,
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    var db = FirebaseFirestore.instance;

    await db.collection(collection).doc(docName).set(data).catchError((e) {
      throw Exception("Failed to add document: $e");
    });
  }

  static Future<void> updateField({
    required String collection,
    required String id,
    required String field,
    required dynamic value,
  }) async {
    var db = FirebaseFirestore.instance;

    await db.collection(collection).doc(id).update({field: value}).catchError((e) {
      throw Exception("Failed to update field: $e");
    });
  }

  static Future<void> addNewUser(User user) async {
    Logger logger = Logger();
    try {
      Map<String, dynamic> userData = user.toMap();
      userData["role"] = "customer";

      logger.i("Adding user to Firestore...");
      await addDocument(docName: user.uid, collection: "users", data: userData);
    } on Exception catch (e) {
      logger.e("Failed to add user: $e");
    }
  }

  static Future<void> saveFCMToken(String token) async {
    Logger logger = Logger();
    try {
      logger.i("Saving FCM token to Firestore...");
      await updateField(
        collection: "users",
        id: FirebaseAuth.instance.currentUser!.uid,
        field: "fcmToken",
        value: token,
      );
      logger.i("FCM token saved successfully");
    } on Exception catch (e) {
      logger.e("Failed to save FCM token: $e");
    }
  }

  static Future<List<ProductGallery>> getProductGalleries(BuildContext context) async {
    Logger().i("Fetching product galleries...");
    var db = FirebaseFirestore.instance;

    QuerySnapshot<Map<String, dynamic>> galleryQuery = await db.collection("galleries").get();

    List<String> productIDs = List<String>.from(galleryQuery.docs
        .map((e) => e.data()["products"])
        .toList()
        .expand(
          (element) => element,
        )
        .toList());

    QuerySnapshot<Map<String, dynamic>> productQuery = await db
        .collection("products")
        .where(
          FieldPath.documentId,
          whereIn: productIDs,
        )
        .get();

    List<ProductGallery> productGalleries;
    if (context.mounted) {
      productGalleries = [await prepareFavoritesGallery(context)];
    } else {
      productGalleries = [];
    }
    productGalleries.addAll(prepareProductGalleries(galleryQuery, productQuery));

    return productGalleries;
  }

  static List<ProductGallery> prepareProductGalleries(
    QuerySnapshot<Map<String, dynamic>> galleryQuery,
    QuerySnapshot<Map<String, dynamic>> productQuery,
  ) {
    List<ProductGallery> productGalleries = [];
    for (var gallery in galleryQuery.docs) {
      List<Product> products = [];
      for (var product in productQuery.docs) {
        if ((gallery.data()["products"] as List).contains(product.id)) {
          products.add(Product.fromMap(product.data()));
        }
      }
      productGalleries.add(ProductGallery(
        type: GalleryType.fromName(gallery.id)!,
        products: products,
      ));
    }

    productGalleries.sort((a, b) => a.type.order.compareTo(b.type.order));

    return productGalleries;
  }

  static Future<ProductGallery> prepareFavoritesGallery(BuildContext context) async {
    List<Product> favoriteProducts = await getFavoriteProducts(context.authController.user!.favorites);

    if (favoriteProducts.isNotEmpty) {
      return ProductGallery(
        type: GalleryType.favorites,
        products: favoriteProducts,
      );
    }

    return ProductGallery(
      type: GalleryType.favorites,
      products: [],
    );
  }

  static Future<void> refreshFavoritesGallery(BuildContext context) async {
    Logger().i("Refreshing favorites gallery...");

    await context.authController.refreshUserData();

    List<Product> favoriteProducts = [];
    if (context.mounted) {
      favoriteProducts = await getFavoriteProducts(context.authController.user!.favorites);
    }

    if (context.mounted) {
      if (favoriteProducts.isNotEmpty) {
        List<ProductGallery> galleries = List.from(context.homeController.galleries);
        galleries[galleries.indexWhere(
          (element) => element.type == GalleryType.favorites,
        )] = ProductGallery(
          type: GalleryType.favorites,
          products: favoriteProducts,
        );

        context.homeController.galleries = galleries;
      }
    }
  }

  static Future<List<CustomerOrder>> fetchMyOrders() async {
    var db = FirebaseFirestore.instance;

    List<CustomerOrder> orders = [];

    try {
      await db
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .orderBy("date", descending: true)
          .get()
          .then((collection) {
        for (var doc in collection.docs) {
          orders.add(CustomerOrder.fromMap(doc.data(), id: doc.id));
        }
      });

      Logger().i("Orders fetched successfully");
    } catch (e, s) {
      Logger().e("Failed to fetch orders: ${e.toString()}");
      Logger().e(s);
    }

    return orders;
  }

  static Future<void> submitOrder(CustomerOrder customerOrder) async {
    try {
      Map<String, dynamic> order = customerOrder.toMap();
      var db = FirebaseFirestore.instance;

      Future<void> firestoreOperation =
          db.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("orders").add(order);

      await firestoreOperation.timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException("The operation has timed out.");
        },
      );

      Logger().i("Order submitted successfully");
    } catch (e, s) {
      Logger().e("Failed to submit order: $e");
      Logger().e(s);
      throw Exception("Failed to submit order: $e");
    }
  }

  static Future<void> deleteDocument({required String collection, required String id}) async {
    var db = FirebaseFirestore.instance;

    Logger().i("Deleting document $id from collection $collection");

    await db.collection(collection).doc(id).delete().catchError((e) {
      throw Exception("Failed to delete document: $e");
    });
  }

  static Future<void> addToFavorites(BuildContext context, {required String productID}) async {
    var db = FirebaseFirestore.instance;

    Logger().i("Adding product $productID to favorites...");

    await db.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
      "favorites": FieldValue.arrayUnion([productID]),
    }).catchError((e) {
      throw Exception("Failed to add product to favorites: $e");
    });

    if (context.mounted) await refreshFavoritesGallery(context);
  }

  static Future<void> removeFromFavorites(BuildContext context, {required String productID}) async {
    var db = FirebaseFirestore.instance;

    Logger().i("Removing product $productID from favorites...");

    await db.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
      "favorites": FieldValue.arrayRemove([productID]),
    }).catchError((e) {
      throw Exception("Failed to remove product from favorites: $e");
    });

    if (context.mounted) await refreshFavoritesGallery(context);
  }

  static Future<List<Product>> getFavoriteProducts(List<String> favorites) async {
    Logger().i("Fetching favorite products...");

    try {
      return await getDocumentsWhereIn("products", "id", favorites)
          .then((products) => products.map((product) => Product.fromMap(product)).toList());
    } catch (e) {
      Logger().e("Failed to fetch favorites: $e");
      return [];
    }
  }
}

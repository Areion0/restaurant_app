import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:restaurant_app/auth/auth_controller.dart';
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

    /// The function to convert the Firestore document snapshot to a Dart object
    required T Function(Map<String, dynamic> data, String id) fromJson,

    /// The function to convert the Dart object to a Firestore document snapshot
    required Map<String, dynamic> Function(T value) toJson,
  }) async {
    var db = FirebaseFirestore.instance;

    List<T> list = [];

    Query<T> query = db.collection(collection).orderBy(orderBy, descending: descending).limit(pageSize).withConverter(
          fromFirestore: (snapshot, options) => fromFirestore(snapshot, fromJson),
          toFirestore: (value, options) => toFirestore(value, toJson),
        );

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

  static Future<void> addNewUser(User user) async {
    try {
      Map<String, dynamic> userData = user.toMap();
      userData["role"] = "customer";

      Logger().i("Adding user to Firestore...");
      await addDocument(docName: user.uid, collection: "users", data: userData);
    } on Exception catch (e) {
      Logger().e("Failed to add user: $e");
    }
  }

  static Future<List<ProductGallery>> getProductGalleries() async {
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

    Logger().i("Product galleries: ${productGalleries.length}");

    return productGalleries;
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
    Map<String, dynamic> order = customerOrder.toMap();

    try {
      var db = FirebaseFirestore.instance;

      Future<void> firestoreOperation =
          db.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("orders").add(order);

      await firestoreOperation.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException("The operation has timed out.");
        },
      );

      Logger().i("Order submitted successfully");
    } catch (e) {
      Logger().i('Error submitting order: $e');
    }
  }

  static Future<void> deleteDocument(String collection, String id) async {
    var db = FirebaseFirestore.instance;

    await db.collection(collection).doc(id).delete().catchError((e) {
      throw Exception("Failed to delete document: $e");
    });
  }
}

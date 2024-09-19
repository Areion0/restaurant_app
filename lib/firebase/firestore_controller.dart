import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:restaurant_app/auth/auth_controller.dart';
import 'package:restaurant_app/models/product.dart';

import '../models/customer_order.dart';
import 'storage_controller.dart';

class FirestoreController {
  static Future<List> getCollection(String collection) async {
    var db = FirebaseFirestore.instance;

    List<Map<String, dynamic>> list = [];

    await db.collection(collection).get().then((collection) {
      for (var doc in collection.docs) {
        list.add(doc.data());
      }
    }).catchError((e) {
      throw Exception("Failed to get collection: $e");
    });

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

  static Future<List<Product>> getProducts() async {
    var productList = await getCollection('products');
    List<Product> products = [];

    for (var productData in productList.cast<Map<String, dynamic>>()) {
      var imageURL = await StorageController.getFileURL(productData["imageID"] ?? "") ?? "";
      products.add(Product.fromMap(productData, imageURL: imageURL));
    }

    return products;
  }

  static Future<void> submitOrder(CustomerOrder customerOrder) async {
    Map<String, dynamic> order = customerOrder.toMap();

    try {
      var db = FirebaseFirestore.instance;

      Future<void> firestoreOperation = db.collection('orders').add(order);

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
}

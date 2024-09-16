import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  static Future<List<Product>> getProducts() async {
    var productList = await getCollection('products');
    List<Product> products = [];

    for (var productData in productList.cast<Map<String, dynamic>>()) {
      var imageURL = await StorageController.getFileURL(productData["imageID"] ?? "") ?? "";
      products.add(Product.fromMap(productData, imageURL: imageURL));
    }

    return products;
  }

  static Future<DocumentReference<Map<String, dynamic>>> addProduct(Map<String, dynamic> product) async {
    var db = FirebaseFirestore.instance;

    return await db.collection('products').add(product);
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

      log("Order added successfully");
    } catch (e) {
      log('Error submitting order: $e');
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

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

  static Future<List<Map<String, dynamic>>> getProducts() async {
    return (await getCollection('products')).cast<Map<String, dynamic>>();
  }
}

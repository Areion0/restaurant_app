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
}

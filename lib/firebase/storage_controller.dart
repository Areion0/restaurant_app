import 'package:firebase_storage/firebase_storage.dart';

class StorageController {
  static Future<dynamic> getFileURL(String id) async {
    final storage = FirebaseStorage.instance;

    final photosRef = storage.ref().child("productImages");

    return await photosRef.child("$id.jpg").getDownloadURL();
  }
}

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class StorageController {
  static Future<dynamic> getFileURL(String id) async {
    final storage = FirebaseStorage.instance;

    final photosRef = storage.ref().child("productImages");

    return await photosRef.child("$id.jpg").getDownloadURL();
  }

  static Future<void> uploadFile(String id, String path) async {
    final imageBytes = await rootBundle.load(path);
    final imageData = imageBytes.buffer.asUint8List();

    final storage = FirebaseStorage.instance;
    final photosRef = storage.ref().child("productImages");
    await photosRef.child("$id.jpg").putData(imageData);
  }
}

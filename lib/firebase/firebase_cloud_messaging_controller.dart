import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class FirebaseCloudMessagingController {
  static Future<void> sendNotificationToUser(String userID) async {
    Logger logger = Logger();

    Uri endpointUri = Uri.parse("https://restaurant-app-backend.netlify.app/api/send-notification");

    try {
      logger.i("Sending notification to user with id:$userID");
      await http
          .post(
        endpointUri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "userID": userID,
        }),
      )
          .then(
        (value) {
          logger.i(value.body);
        },
      );
    } on Exception catch (e, s) {
      logger.e("Failed to send notification to user: $e");
      logger.e(s);
    }
  }
}

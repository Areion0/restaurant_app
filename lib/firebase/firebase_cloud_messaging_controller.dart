import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/models/order_status.dart';

class FirebaseCloudMessagingController {
  static Future<void> sendNotificationToUser(
    String userID, {
    required String idToken,
    required OrderStatus newOrderStatus,
  }) async {
    Logger logger = Logger();

    // Uri endpointUri = Uri.parse("http://10.0.2.2:8888/api/send-notification"); // For testing locally
    Uri endpointUri = Uri.parse("https://restaurant-app-backend.netlify.app/api/send-notification");

    try {
      logger.i("Sending notification to user with id:$userID");
      final response = await http.post(
        endpointUri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode(<String, String>{
          "userID": userID,
          "newOrderStatus": newOrderStatus.name,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to send notification to user: ${response.body}");
      }

      logger.i("Notification sent to user with id:$userID");
    } catch (e, s) {
      logger.e("Failed to send notification to user: $e");
      logger.e(s);
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class HttpHelper {
  static const String baseUrl = 'https://restaurant-app-backend.netlify.app/api';

  static Future<Map<String, dynamic>> get(String path, {required String token}) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final Uri uri = Uri.parse('$baseUrl$path');

    Logger().i('GET $uri');

    final response = await http.get(uri, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to get data: ${response.body}');
    }

    return jsonDecode(response.body);
  }
}

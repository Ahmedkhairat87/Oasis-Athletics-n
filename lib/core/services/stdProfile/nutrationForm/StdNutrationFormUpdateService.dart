import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiControl/apiManager.dart';

class StdNutrationFormUpdateService {
  static Future<bool> updateNutrationForm({
    required String stdId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')?.trim();

      if (token == null || token.isEmpty) {
        print('❌ Token is missing');
        return false;
      }

      final uri = Uri.parse(APIManager.updateUpdateFormData);

      final body = jsonEncode({
        "stdID": stdId,
        "token": token,
        ...payload,
      });

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: body,
      );

      if (response.statusCode != 200) {
        print('❌ updateNutrationForm failed: ${response.statusCode}');
        print('📦 response body: ${response.body}');
        print('📤 request body: $body');
        return false;
      }

      return true;
    } catch (e, s) {
      print('❌ updateNutrationForm exception: $e');
      print(s);
      return false;
    }
  }
}

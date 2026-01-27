import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oasisathletic/core/apiControl/apiManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/stdLinks/medicalFormData/MedicalFormDataResponse.dart';

class StdMedicalFormService {
  static Future<MedicalFormDataResponse?> getMedicalForm({
    required String stdId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')?.trim();

      if (token == null || token.isEmpty) {
        print('❌ Token is missing');
        return null;
      }

      final uri = Uri.parse(APIManager.getMedicalFormData);

      /// ✅ EXACT SAME BODY AS POSTMAN
      final body = jsonEncode({"token": token, "stdID": stdId});

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: body,
      );

      if (response.statusCode != 200) {
        print('❌ getMedicalForm failed: ${response.statusCode}');
        print('📦 response body: ${response.body}');
        print('📤 request body: $body');
        return null;
      }

      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return MedicalFormDataResponse.fromJson(decoded);
      }

      return null;
    } catch (e, s) {
      print('❌ getMedicalForm exception: $e');
      print(s);
      return null;
    }
  }
}

// lib/core/services/stdProfile/stdAthleticServices/StdAthleticLinksService.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oasisathletic/core/apiControl/apiManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/stdLinks/athleticReports/AthleticReports.dart';

class StdAthleticLinksService {
  static Future<AthleticReports?> getAthleticReports({
    required String stdId,
  }) async {
    try {
      /// 🔑 get token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        return null;
      }

      /// 📌 API params
      final body = {"token": token, "stdId": stdId};

      final uri = Uri.parse(APIManager.getAthleticLinks);

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body,
      );

      if (response.statusCode != 200) {
        return null;
      }

      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return AthleticReports.fromJson(decoded);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}

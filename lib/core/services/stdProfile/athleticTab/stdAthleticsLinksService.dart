import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:oasisathletic/core/apiControl/apiManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/stdLinks/athleticTab/StdAtleticReportsResponse.dart';

class StdAthleticLinksService {
  static Future<StdAtleticReportsResponse?> getAthleticReports({
    required String stdId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        debugPrint("❌ Athletic token missing");
        return null;
      }

      final body = {
        "token": token,
        "stdID": int.tryParse(stdId) ?? stdId,
      };

      debugPrint("🔹 Athletic Reports Params: $body");

      final uri = Uri.parse(APIManager.getAthleticLinks);

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      debugPrint("🔹 Status Code: ${response.statusCode}");
      debugPrint("🔹 Response: ${response.body}");

      if (response.statusCode != 200) {
        return null;
      }

      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        final parsed = StdAtleticReportsResponse.fromJson(decoded);
        debugPrint("✅ Parsed Athletic count: ${parsed.stdAthleticsReports?.length ?? 0}");
        return parsed;
      }

      debugPrint("❌ Athletic response is not Map<String, dynamic>");
      return null;
    } catch (e, st) {
      debugPrint("❌ EXCEPTION in StdAthleticLinksService:");
      debugPrint("$e");
      debugPrint("$st");
      return null;
    }
  }
}
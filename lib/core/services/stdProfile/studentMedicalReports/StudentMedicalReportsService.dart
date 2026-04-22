import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../apiControl/apiManager.dart';
import '../../../apiControl/apiServiceProvider.dart';
import '../../../model/stdLinks/medicalTab/MedicalTabReportsResponse.dart';

class StdMedicalLinksService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<MedicalTabReportsResponse?> getMedicalReports({
    required String stdId,
  }) async {
    try {
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        debugPrint("❌ Token not found");
        return null;
      }

      final params = {
        "token": token,
        "stdID": stdId,
      };

      debugPrint("📡 MEDICAL PARAMS: $params");

      final response = await APIServices().apiRequest(
        APIManager.getStdLinksMedical,
        params,
      );

      debugPrint("📡 RESPONSE: $response");

      // 🔥 IMPORTANT FIX
      if (response == null ||
          response["data"] == null ||
          response["data"].toString().isEmpty) {
        debugPrint("❌ EMPTY DATA FROM API");
        return null;
      }

      return MedicalTabReportsResponse.fromJson(response["data"]);
    } catch (e, st) {
      debugPrint("❌ EXCEPTION (Medical Service): $e");
      debugPrint("📍 STACK: $st");
      return null;
    }
  }
}
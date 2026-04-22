import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../apiControl/apiManager.dart';
import '../../apiControl/apiServiceProvider.dart';

class StudentMedicalUpdateFlagService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<bool> updateMedicalFlag({
    required String updateType,
    required String reportID,
  }) async {
    try {
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        debugPrint("❌ updateMedicalFlag: token not found");
        return false;
      }

      final params = {
        "token": token,
        "updateType": updateType,
        "ReportID": reportID,
      };

      debugPrint("📡 UPDATE FLAG PARAMS: $params");

      final response = await APIServices().apiRequest(
        APIManager.updateFlagMedicalAndReports,
        params,
      );

      debugPrint("📡 UPDATE FLAG RESPONSE: $response");

      if (response == null) return false;

      final success = response["success"];
      if (success == true) return true;

      return false;
    } catch (e, st) {
      debugPrint("❌ EXCEPTION updateMedicalFlag: $e");
      debugPrint("$st");
      return false;
    }
  }
}
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utilities/apiResponseHelper.dart';
import '../../apiControl/apiServiceProvider.dart';
import '../../apiControl/apiManager.dart';

import '../../model/dashboard/notification/NotificationResponse.dart';

class NotificationCenterService {
  /// =======================
  /// TOKEN
  /// =======================
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// =======================
  /// GET NOTIFICATIONS
  /// =======================
  static Future<NotificationResponse?> getNotifications() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) return null;

      final raw = await APIServices().apiRequest(
        APIManager.notificationCenter,
        {"token": token},
      );

      final json = ApiResponseHelper.normalize(raw);
      return NotificationResponse.fromJson(json);
    } catch (e, st) {
      debugPrint("❌ NotificationCenterService.getNotifications error: $e");
      debugPrint("$st");
      return null;
    }
  }

  /// ==========================
  /// READ ONE (token + serNo)
  /// ==========================
  static Future<bool> readOne({required num serNo}) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) return false;

      final raw = await APIServices().apiRequest(
        APIManager.readOneNotification, // or Endpoints.readOneNotification
        {
          "token": token,
          "serNo": serNo,
        },
      );

      final json = ApiResponseHelper.normalize(raw);

      // many backends return {success:true, data:1}
      final data = json["data"];
      if (json["success"] == true && (data == 1 || data == "1" || json["status"] == true)) {
        return true;
      }
      return false;
    } catch (e) {
      print("❌ readOne error: $e");
      return false;
    }
  }

  /// ==========================
  /// READ ALL (token)
  /// ==========================
  static Future<bool> readAll() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) return false;

      final raw = await APIServices().apiRequest(
        APIManager.readAllNotifications, // or Endpoints.readAllNotifications
        {
          "token": token,
        },
      );

      final json = ApiResponseHelper.normalize(raw);

      final data = json["data"];
      if (json["success"] == true && (data == 1 || data == "1" || json["status"] == true)) {
        return true;
      }
      return false;
    } catch (e) {
      print("❌ readAll error: $e");
      return false;
    }
  }
}
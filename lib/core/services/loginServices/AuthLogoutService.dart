import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiControl/apiManager.dart';
import '../../apiControl/apiServiceProvider.dart';

class ParentLogoutService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<bool> logout() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) return false;

      final response = await APIServices().apiRequest(APIManager.logOut, {
        "token": token,
      });

      dynamic json;

      /// STEP 1: normalize response
      if (response is String) {
        json = jsonDecode(response as String);
      } else if (response is Map) {
        json = Map<String, dynamic>.from(response);
      } else {
        throw Exception('Unexpected response type: ${response.runtimeType}');
      }

      /// STEP 2: unwrap apiRequest() wrapper
      if (json is Map && json.containsKey('data')) {
        json = json['data'];
      }

      if (json is Map && json.containsKey('Response')) {
        json = json['Response'];
      }

      /// STEP 3: Logout API response = "OK"
      if (json.toString().trim() == "OK") {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("token");

        print("✅ Logout success + token cleared");
        return true;
      }

      print("❌ Logout failed: $json");
      return false;
    } catch (e, st) {
      print("❌ Logout service error");
      print(e);
      print(st);
      return false;
    }
  }
}

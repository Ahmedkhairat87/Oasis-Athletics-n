import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiControl/apiManager.dart';
import '../../../apiControl/apiServiceProvider.dart';

class GalleryPaymentService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// يرجع payment URL أو null
  static Future<String?> createPaymentLink({
    required String stdId,
    required num accNo,
    required num amount,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) return null;

      final params = {
        "token": token,
        "stdID": stdId,
        "accNo": accNo,
        "amount": amount,
      };

      final response = await APIServices().apiRequest(
        APIManager.createNewVoucher,
        params,
      );

      Map<String, dynamic> json;

      // STEP 1: normalize response type
      if (response is String) {
        json = jsonDecode(response as String);
      } else if (response is Map) {
        json = Map<String, dynamic>.from(response);
      } else {
        throw Exception("Unexpected response type: ${response.runtimeType}");
      }

      if (json.containsKey("data") && json["data"] is Map) {
        json = Map<String, dynamic>.from(json["data"]);
      }
      if (json.containsKey("Response") && json["Response"] is Map) {
        json = Map<String, dynamic>.from(json["Response"]);
      }

      final url = json["URL"] ?? json["url"];
      if (url is String && url.isNotEmpty) {
        return url;
      }

      return null;
    } catch (e) {
      print("❌ createPaymentLink error: $e");
      return null;
    }
  }
}

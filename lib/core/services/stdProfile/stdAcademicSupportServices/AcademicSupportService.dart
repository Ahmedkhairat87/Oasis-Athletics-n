import 'package:oasisathletic/core/model/stdLinks/academicSupport/StdAcademicSupportResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiControl/apiManager.dart';
import '../../../apiControl/apiServiceProvider.dart';

class AcademicSupportService {
  /// Load token from SharedPreferences automatically.
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<StdAcademicSupportResponse?> getAcademicSupport({
    required String stdId,
  }) async {
    try {
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        print("❌ ERROR: Token not found in SharedPreferences!");
        return null;
      }

      final params = {"token": token, "stdID": stdId};

      print("🔹 API Params: $params");

      final response = await APIServices().apiRequest(
        APIManager.getAcademicSupport,
        params,
      );

      return StdAcademicSupportResponse.fromJson(response["data"]);
    } catch (e, st) {
      print("❌ EXCEPTION in AcademicSupportService:");
      print(e);
      print(st);
      return null;
    }
  }
}

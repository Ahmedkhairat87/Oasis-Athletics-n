import 'package:oasisathletic/core/model/stdLinks/academicSupport/StdAcademicSupportResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiControl/apiManager.dart';
import '../../../apiControl/apiServiceProvider.dart';

class AcademicSupportService {
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

      final params = {
        "token": token,
        "stdID": stdId,
      };

      print("🔹 getAcademicSupport Params: $params");

      final response = await APIServices().apiRequest(
        APIManager.getAcademicSupport,
        params,
      );

      final json = response["data"] ?? response;
      return StdAcademicSupportResponse.fromJson(json);
    } catch (e, st) {
      print("❌ EXCEPTION in getAcademicSupport:");
      print(e);
      print(st);
      return null;
    }
  }

  static Future<StdAcademicSupportResponse?> getAcademicSupportReport({
    required String stdId,
    required int reportNo,
  }) async {
    try {
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        print("❌ ERROR: Token not found in SharedPreferences!");
        return null;
      }

      final params = {
        "token": token,
        "stdID": stdId,
        "reportNo": reportNo,
      };

      print("🔹 getAcademicSupportReport Params: $params");

      final response = await APIServices().apiRequest(
        APIManager.getAcademicSupportReports,
        params,
      );

      final json = response["data"] ?? response;
      return StdAcademicSupportResponse.fromJson(json);
    } catch (e, st) {
      print("❌ EXCEPTION in getAcademicSupportReport:");
      print(e);
      print(st);
      return null;
    }
  }
}
import 'package:shared_preferences/shared_preferences.dart';
import '../../../apiControl/apiManager.dart';
import '../../../apiControl/apiServiceProvider.dart';
import '../../../model/stdLinks/schoolAcademic/StdSchoolAcademicLinks.dart';

class StdSchoolAcademicLinksService {
  /// Load token from SharedPreferences automatically.
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<StdSchoolAcademicLinks?> getAcademicLinks({
    required String stdId,
  }) async {
    try {
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        print("❌ ERROR: Token not found!");
        return null;
      }

      final params = {"token": token, "stdID": stdId};

      print("🔹 Academic Links Params: $params");

      final response = await APIServices().apiRequest(
        APIManager.getSchoolAcademicLinks,
        params,
      );

      return StdSchoolAcademicLinks.fromJson(response["data"]);
    } catch (e, st) {
      print("❌ EXCEPTION in StdSchoolAcademicLinksService:");
      print(e);
      print(st);
      return null;
    }
  }
}

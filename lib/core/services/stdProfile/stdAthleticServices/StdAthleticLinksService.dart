import 'package:shared_preferences/shared_preferences.dart';
import '../../../apiControl/apiManager.dart';
import '../../../apiControl/apiServiceProvider.dart';
import '../../../model/stdLinks/athleticReports/AthleticReports.dart';

class StdAthleticLinksService {
  /// Load token from SharedPreferences automatically.
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<AthleticReports?> getAthleticReports({
    required String stdId,
  }) async {
    try {
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        print("❌ ERROR: Token not found!");
        return null;
      }

      final params = {"token": token, "stdID": stdId};

      print("🔹 Athletic Reports Params: $params");

      final response = await APIServices().apiRequest(
        APIManager.getAthleticLinks,
        params,
      );

      return AthleticReports.fromJson(response["data"]);
    } catch (e, st) {
      print("❌ EXCEPTION in StdAthleticLinksService:");
      print(e);
      print(st);
      return null;
    }
  }
}

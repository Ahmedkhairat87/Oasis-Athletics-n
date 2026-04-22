import 'package:shared_preferences/shared_preferences.dart';

import '../../../../apiControl/apiManager.dart';
import '../../../../apiControl/apiServiceProvider.dart';
import '../../../../model/stdLinks/stdBook/StudentBookMsgsResponse.dart';


class StudentBookService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<StudentBookMsgsResponse?> getStudentBook({
    required String stdId,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) return null;

      final params = {
        "token": token,
        "stdID": stdId,
      };

      final response = await APIServices().apiRequest(
        APIManager.std_studentBook,
        params,
      );

      final json = response["data"] ?? response;
      return StudentBookMsgsResponse.fromJson(json);
    } catch (e) {
      print("❌ getStudentBook error: $e");
      return null;
    }
  }

  static Future<dynamic> prepareNewStdMsg({
    required String stdId,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) return null;

      final params = {
        "token": token,
        "stdID": stdId,
      };

      final response = await APIServices().apiRequest(
        APIManager.prepareNewStdMsg,
        params,
      );

      return response["data"] ?? response;
    } catch (e) {
      print("❌ prepareNewStdMsg error: $e");
      return null;
    }
  }

  static Future<bool> sendNewStdMsg({
    required String stdId,
    required String subject,
    required String body,
    required String matNo,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) return false;

      final params = {
        "token": token,
        "stdID": stdId,
        "Subject": subject,
        "Body": body,
        "matNo": matNo,
      };

      final response = await APIServices().apiRequest(
        APIManager.sendNewStdMsg,
        params,
      );

      return response != null;
    } catch (e) {
      print("❌ sendNewStdMsg error: $e");
      return false;
    }
  }

  static Future<bool> sendReply({
    required String stdId,
    required int taSer,
    required String body,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) return false;

      final params = {
        "token": token,
        "stdID": stdId,
        "taSer": taSer,
        "Body": body,
      };

      final response = await APIServices().apiRequest(
        APIManager.sendReply,
        params,
      );

      return response != null;
    } catch (e) {
      print("❌ sendReply error: $e");
      return false;
    }
  }

  /// iOS old app used this API before opening inbox message details
  /// and got reply body from response["Data"][0]["body"] if available.
  static Future<String?> updateStdMsgFlag({
    required int taSer,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) return null;

      final params = {
        "token": token,
        "taSer": taSer,
      };

      final response = await APIServices().apiRequest(
        APIManager.updateStdMsgFlag,
        params,
      );

      final json = response["data"] ?? response;
      final data = json["Data"] ?? json["data"];

      if (data is List && data.isNotEmpty) {
        final first = data.first;
        if (first is Map<String, dynamic>) {
          return first["body"]?.toString();
        }
      }

      return null;
    } catch (e) {
      print("❌ updateStdMsgFlag error: $e");
      return null;
    }
  }
}
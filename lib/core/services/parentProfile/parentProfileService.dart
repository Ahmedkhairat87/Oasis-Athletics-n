import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utilities/apiResponseHelper.dart';
import '../../apiControl/apiManager.dart';
import '../../apiControl/apiServiceProvider.dart';
import '../../model/sideMenu/parentProfile/jobDomain/JobDomainResponse.dart';
import '../../model/sideMenu/parentProfile/parentLanguage/ParentLanguageResponse.dart';
import '../../model/sideMenu/parentProfile/parentStatus/ParentStatusResponse.dart';
import '../../model/sideMenu/parentProfile/profileMainData/ParentProfileDataResponse.dart';
import '../../model/sideMenu/parentProfile/profileMainData/parentProfileData.dart';

class ParentProfileService {
  /// =======================
  /// TOKEN
  /// =======================
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// =======================
  /// GET PARENT PROFILE
  /// =======================
  static Future<ParentProfileDataResponse?> getParentProfile() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) return null;

      final rawResponse = await APIServices().apiRequest(
        APIManager.parentDetails,
        {"token": token},
      );

      /// 🔑 Normalize + unwrap using shared helper
      final json = ApiResponseHelper.normalize(rawResponse);

      /// 🔑 Parse model
      final parsed = ParentProfileDataResponse.fromJson(json);

      if (parsed.data == null || parsed.data!.isEmpty) {
        return null;
      }

      if (kDebugMode) {
        print("👨‍👩‍👧 Parent profile loaded successfully");
      }

      return parsed;
    } catch (e, st) {
      print("❌ ParentProfileService error");
      print(e);
      print(st);
      return null;
    }
  }

  /// ==========================
  /// GET JOB DOMAINS
  /// ==========================
  static Future<JobDomainResponse?> getJobDomains() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) return null;

      final response = await APIServices().apiRequest(
        APIManager.pa_jobsdomain,
        {"token": token},
      );

      final json = ApiResponseHelper.normalize(response);
      return JobDomainResponse.fromJson(json);
    } catch (e, st) {
      print('❌ JobDomain service error');
      print(e);
      print(st);
      return null;
    }
  }

  /// ================= STATUS =================
  static Future<ParentStatusResponse?> getParentStatus() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await APIServices().apiRequest(APIManager.pa_Status, {
        "token": token,
      });

      final json = ApiResponseHelper.normalize(response);
      return ParentStatusResponse.fromJson(json);
    } catch (e) {
      debugPrint('❌ ParentStatus error: $e');
      return null;
    }
  }

  /// ================= LANGUAGE =================
  static Future<ParentLanguageResponse?> getParentLanguages() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await APIServices().apiRequest(APIManager.pa_lang, {
        "token": token,
      });

      final json = ApiResponseHelper.normalize(response);
      return ParentLanguageResponse.fromJson(json);
    } catch (e) {
      debugPrint('❌ ParentLanguage error: $e');
      return null;
    }
  }

  // ================= UPDATE =================

  static Future<bool> updateGeneralInfo(Map<String, dynamic> body) async {
    return _post(APIManager.updatePaGeneralInfo, body);
  }

  static Future<bool> updateContactInfo(Map<String, dynamic> body) async {
    return _post(APIManager.updatePaContactInfo, body);
  }

  static Future<bool> updateWorkInfo(Map<String, dynamic> body) async {
    return _post(APIManager.updatePaWorkInfo, body);
  }

  static Future<bool> updateEduInfo(Map<String, dynamic> body) async {
    return _post(APIManager.updatePaEduInfo, body);
  }

  static Future<bool> updateEmergencyInfo(Map<String, dynamic> body) async {
    return _post(APIManager.updateEmergency, body);
  }

  static Future<bool> _post(String url, Map<String, dynamic> body) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await APIServices().apiRequest(url, {
        "token": token,
        ...body,
      });

      final json = ApiResponseHelper.normalize(response);

      return json['success'] == true || json['status'] == true;
    } catch (e) {
      debugPrint("❌ Update error: $e");
      return false;
    }
  }
}

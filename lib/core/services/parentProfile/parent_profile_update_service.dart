import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiControl/apiManager.dart';

class ParentProfileUpdateService {
  static Future<bool> _post(String url, Map<String, dynamic> payload) async {
    try {
      final uri = Uri.parse(url);

      final res = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(payload),
      );

      if (res.statusCode != 200) {
        debugPrint("❌ ParentProfileUpdate failed: ${res.statusCode}");
        debugPrint("📦 body: ${res.body}");
        debugPrint("📤 payload: ${jsonEncode(payload)}");
        return false;
      }

      debugPrint("✅ ParentProfileUpdate success");
      debugPrint("📦 body: ${res.body}");
      return true;
    } catch (e, s) {
      debugPrint("❌ ParentProfileUpdate exception: $e");
      debugPrint("$s");
      return false;
    }
  }

  static Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token")?.trim();
    return (token == null || token.isEmpty) ? null : token;
  }

  static void _printPayload(Map<String, dynamic> payload, String title) {
    debugPrint("📤 $title PAYLOAD START ==================");
    payload.forEach((k, v) => debugPrint("🔑 $k : $v"));
    debugPrint("📤 $title PAYLOAD END ====================");
  }

  // ==================== GENERAL ====================
  static Future<bool> updateGeneral({
    required String fatherTutor,
    required String fatherAddress,
    required String motherTutor,
    required String motherAddress,
    required String parentStatus, // send serNo string
  }) async {
    final token = await _token();
    if (token == null) return false;

    final payload = {
      "token": token,
      "father_tuteur": fatherTutor,
      "father_address": fatherAddress,
      "mother_tuteur": motherTutor,
      "mother_address": motherAddress,
      "parent_status": parentStatus,
    };

    _printPayload(payload, "GENERAL");
    return _post(APIManager.updatePaGeneralInfo, payload);
  }

  // ==================== CONTACT ====================
  static Future<bool> updateContact({
    required String fatherEmail,
    required String fatherHomeTel,
    required String fatherMobile,
    required String motherEmail,
    required String motherHomeTel,
    required String motherMobile,
  }) async {
    final token = await _token();
    if (token == null) return false;

    final payload = {
      "token": token,
      "father_email": fatherEmail,
      "father_hometel": fatherHomeTel,
      "father_mobile": fatherMobile,
      "mother_email": motherEmail,
      "mother_hometel": motherHomeTel,
      "mother_mobile": motherMobile,
    };

    _printPayload(payload, "CONTACT");
    return _post(APIManager.updatePaContactInfo, payload);
  }

  // ==================== WORK ====================
  static Future<bool> updateWork({
    required String fatherProfession,
    required String fatherCompany,
    required String fatherWorkplace,
    required String fatherDomainSer, // jobDomain.serno
    required String motherProfession,
    required String motherCompany,
    required String motherWorkplace,
    required String motherDomainSer, // jobDomain.serno
  }) async {
    final token = await _token();
    if (token == null) return false;

    final payload = {
      "token": token,
      "father_profession": fatherProfession,
      "father_company": fatherCompany,
      "father_workplace": fatherWorkplace,
      "father_domain": fatherDomainSer,
      "mother_profession": motherProfession,
      "mother_company": motherCompany,
      "mother_workplace": motherWorkplace,
      "mother_domain": motherDomainSer,
    };

    _printPayload(payload, "WORK");
    return _post(APIManager.updatePaWorkInfo, payload);
  }

  // ==================== EDUCATION ====================
  static Future<bool> updateEducation({
    required String fatherSchool,
    required String fatherDiplome,
    required String father1Lang,
    required String father2Lang,
    required String father3Lang,
    required String fatherAutreslang,
    required String motherSchool,
    required String motherDiplome,
    required String mother1Lang,
    required String mother2Lang,
    required String mother3Lang,
    required String motherAutreslang,
  }) async {
    final token = await _token();
    if (token == null) return false;

    final payload = {
      "token": token,
      "father_school": fatherSchool,
      "father_diplome": fatherDiplome,
      "father_1lang": father1Lang,
      "father_2lang": father2Lang,
      "father_3lang": father3Lang,
      "father_autreslang": fatherAutreslang,
      "mother_school": motherSchool,
      "mother_diplome": motherDiplome,
      "mother_1lang": mother1Lang,
      "mother_2lang": mother2Lang,
      "mother_3lang": mother3Lang,
      "mother_autreslang": motherAutreslang,
    };

    _printPayload(payload, "EDUCATION");
    return _post(APIManager.updatePaEduInfo, payload);
  }
}
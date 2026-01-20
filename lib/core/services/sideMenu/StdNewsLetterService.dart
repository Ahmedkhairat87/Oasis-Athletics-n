import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../apiControl/apiManager.dart';
import '../../apiControl/apiServiceProvider.dart';
import '../../model/sideMenu/newsLetter/NewsLetter.dart';

class StdNewsLetterService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<NewsLetter?> getNewsLetter() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) return null;

      final response = await APIServices().apiRequest(
        APIManager.getNewsLetter,
        {"token": token, "Flag": 0},
      );

      Map<String, dynamic> json;

      // STEP 1: normalize response
      if (response is String) {
        json = jsonDecode(response as String);
      } else if (response is Map) {
        json = Map<String, dynamic>.from(response);
      } else {
        throw Exception('Unexpected response type: ${response.runtimeType}');
      }

      // STEP 2: unwrap apiRequest() wrapper
      if (json.containsKey('data') && json['data'] is Map) {
        json = Map<String, dynamic>.from(json['data']);
      }

      if (json.containsKey('Response') && json['Response'] is Map) {
        json = Map<String, dynamic>.from(json['Response']);
      }

      // STEP 3: parse actual payload
      final parsed = NewsLetter.fromJson(json);

      print("📰 Parsed newsletters count: ${parsed.data.length}");

      return parsed;
    } catch (e, st) {
      print("❌ Newsletter service error");
      print(e);
      print(st);
      return null;
    }
  }
}

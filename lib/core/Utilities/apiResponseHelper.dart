import 'dart:convert';
import 'package:flutter/foundation.dart';

class ApiResponseHelper {
  static Map<String, dynamic> normalize(dynamic response) {
    if (kDebugMode) {
      print('🔹 Raw API response type: ${response.runtimeType}');
      print('🔹 Raw API response value: $response');
    }

    if (response == null) {
      throw Exception('API response is null');
    }

    Map<String, dynamic> json;

    if (response is String) {
      json = jsonDecode(response);
    } else if (response is Map) {
      json = Map<String, dynamic>.from(response);
    } else {
      throw Exception('Unexpected response type: ${response.runtimeType}');
    }

    // 🔥 UNWRAP STANDARD API FORMAT
    if (json.containsKey('data') && json['data'] is Map) {
      return Map<String, dynamic>.from(json['data']);
    }

    return json;
  }
}

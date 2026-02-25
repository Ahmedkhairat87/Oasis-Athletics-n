import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../reusable_components/Checkers/checkInternetConnection.dart';

class APIServices {
  Future<Map<String, dynamic>> apiRequest(
    String path,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 20),
    bool checkInternetBeforeRequest = true,
  }) async {
    // ✅ 1) fast-fail قبل ما نبدأ request
    if (checkInternetBeforeRequest) {
      final ok = await NetworkGuard.hasInternet();
      if (!ok) {
        return {
          "success": false,
          "message": "No Internet connection",
          "data": null,
          "statusCode": 0,
        };
      }
    }

    try {
      final uri = Uri.parse(path);

      final response = await http
          .post(
            uri,
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(params),
          )
          .timeout(timeout);

      // ignore: avoid_print
      print("🔹 Status Code: ${response.statusCode}");
      // ignore: avoid_print
      print("🔹 Response: ${response.body}");

      // ✅ safe decode
      dynamic decoded;
      if (response.body.isNotEmpty) {
        try {
          decoded = jsonDecode(response.body);
        } catch (_) {
          decoded = response.body; // fallback لو مش JSON
        }
      } else {
        decoded = null;
      }

      // ---- SUCCESS ----
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          "success": true,
          "data": decoded,
          "message": "Request successful",
          "statusCode": response.statusCode,
        };
      }

      // ---- NO CONTENT (204) ----
      if (response.statusCode == 204) {
        return {
          "success": false,
          "data": null,
          "message": "No data found",
          "statusCode": 204,
        };
      }

      // ---- CLIENT ERRORS (400–499) ----
      if (response.statusCode >= 400 && response.statusCode < 500) {
        return {
          "success": false,
          "data": decoded, // ✅ keep it
          "message": _clientErrorMessage(response.body, response.statusCode),
          "statusCode": response.statusCode,
        };
      }

      // ---- SERVER ERRORS (500–599) ----
      if (response.statusCode >= 500) {
        return {
          "success": false,
          "data": null,
          "message": "Server error, please try again later",
          "statusCode": response.statusCode,
        };
      }

      // ---- UNKNOWN ----
      return {
        "success": false,
        "data": null,
        "message": "Unexpected error occurred",
        "statusCode": response.statusCode,
      };
    } on TimeoutException {
      return {
        "success": false,
        "message": "Connection timed out",
        "data": null,
        "statusCode": 0,
      };
    } on SocketException {
      // ✅ لو النت قطع بعد pre-check أو أثناء الطلب
      return {
        "success": false,
        "message": "No Internet connection",
        "data": null,
        "statusCode": 0,
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Unexpected error: $e",
        "data": null,
        "statusCode": 0,
      };
    }
  }

  String _clientErrorMessage(String body, int statusCode) {
    try {
      final json = jsonDecode(body);
      if (json is Map && json.containsKey("message")) {
        return json["message"].toString();
      }
    } catch (_) {}
    return "Request failed ($statusCode)";
  }
}

import '../../apiControl/apiManager.dart';
import '../../apiControl/apiServiceProvider.dart';
import '../../model/loginModels/LoginResponse.dart';
import '../apiExceptions.dart';

class AuthLoginService {
  static Future<LoginResponse> login({
    required String username,
    required String password,
    required String deviceId,
    required String DeviceType,
    required String fcmToken,
  }) async {
    final params = {
      "user": username,
      "pass": password,
      "deviceID": deviceId,
      "DeviceType": DeviceType,
      "FCM": fcmToken,
    };

    print(params);

    final response = await APIServices().apiRequest(
      APIManager.loginAPI,
      params,
    );

    // ✅ Keep your base success logic as-is
    if (response["success"] == true && response["data"] != null) {
      return LoginResponse.fromJson(response["data"]);
    }

    // ✅ Try to extract statusCode from any common key
    final int? statusCode = _extractStatusCode(response);

    // ✅ Friendly meaning: invalid user/pass
    if (statusCode == 204) {
      throw ApiException(
        statusCode: 204,
        message: 'Wrong username or password.',
      );
    }

    // ✅ fallback error message
    final message = (response["message"] ?? "Login failed").toString().trim();
    throw ApiException(
      statusCode: statusCode,
      message: message.isEmpty ? "Login failed" : message,
    );
  }

  static int? _extractStatusCode(Map<dynamic, dynamic> res) {
    // Some APIs return: statusCode / status / code / StatusCode ...
    final candidates = ["statusCode", "status", "code", "StatusCode", "Status"];

    for (final k in candidates) {
      final v = res[k];
      if (v is int) return v;
      if (v is String) {
        final parsed = int.tryParse(v);
        if (parsed != null) return parsed;
      }
    }

    // Sometimes statusCode nested in meta / error
    final meta = res["meta"];
    if (meta is Map) {
      final v = meta["statusCode"] ?? meta["status"] ?? meta["code"];
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
    }

    return null;
  }
}
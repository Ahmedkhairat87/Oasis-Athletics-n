import 'dart:async';

import '../../apiControl/apiManager.dart';
import '../../apiControl/apiServiceProvider.dart';
import '../../model/regStdModels/RegStResponse.dart';

class Getregstd {
  static Future<RegStdResponse> getRegStd({
    required String token,
    required String deviceId,
    required int DeviceType,
  }) async {
    final params = {
      "token": token,
      "deviceID": deviceId,
      "DeviceType": DeviceType,
    };

    // ignore: avoid_print
    print("🔹 API Params: $params");

    try {
      // ✅ Timeout يمنع الـ loading للأبد
      final response = await APIServices()
          .apiRequest(APIManager.regStd, params)
          .timeout(const Duration(seconds: 25));

      if (response["success"] == true && response["data"] != null) {
        return RegStdResponse.fromJson(response["data"]);
      } else {
        throw Exception(response["message"] ?? "Failed to load students");
      }
    } on TimeoutException {
      throw Exception("Connection timed out. Please try again.");
    } catch (e) {
      // خلّيها Exception برسالة واضحة
      throw Exception(e.toString());
    }
  }
}

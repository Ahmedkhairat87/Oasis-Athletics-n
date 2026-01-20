import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:device_info_plus/device_info_plus.dart';

Future<Map<String, String>> getDeviceData() async {
  final deviceInfo = DeviceInfoPlugin();

  // 🌐 WEB
  // if (kIsWeb) {
  //   final web = await deviceInfo.webBrowserInfo;
  //   return {
  //     "deviceId": web.userAgent ?? "web",
  //     "deviceType": "3", // Web
  //   };
  // }

  // 🤖 ANDROID
  if (defaultTargetPlatform == TargetPlatform.android) {
    final android = await deviceInfo.androidInfo;
    return {
      "deviceId": android.id ?? android.fingerprint ?? "android",
      "deviceType": "2", // Android
    };
  }

  // 🍎 IOS (iPhone / iPad)
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    final ios = await deviceInfo.iosInfo;
    return {
      "deviceId": ios.identifierForVendor ?? "ios",
      "deviceType": "1", // iOS
    };
  }

  // ❓ FALLBACK
  return {"deviceId": "unknown", "deviceType": "0"};
}

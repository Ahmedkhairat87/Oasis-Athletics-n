import 'package:flutter/material.dart';
import 'globalNavigatorKey.dart';
import '../errorsDialogs/ErrorRetryDialog.dart'; // اللي فيه ErrorRetrySheet
//

class ApiGuard {
  static Future<Map<String, dynamic>?> run({
    required Future<Map<String, dynamic>> Function() request,
    required String title,
    required bool showDialog,
    VoidCallback? onTryAgain,
  }) async {
    final res = await request();

    final success = res["success"] == true;
    if (success) return res;

    final msg = (res["message"] ?? "").toString().toLowerCase();
    final code = (res["statusCode"] ?? 0) as int;

    // ✅ لو Offline: ما تعرضش dialog هنا… سيب GlobalOfflineListener يتصرف
    final isOffline = code == 0 && msg.contains("no internet");
    if (isOffline) return null;

    if (!showDialog) return null;

    // باقي الأخطاء عادي
    ErrorRetrySheet.show(
      rootNavKey.currentContext!,
      title: title,
      message: res["message"]?.toString() ?? "Unexpected error",
      onTryAgain: onTryAgain,
      onCancel: () {},
    );

    return null;
  }
}

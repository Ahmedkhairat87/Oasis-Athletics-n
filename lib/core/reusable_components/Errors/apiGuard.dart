import 'package:flutter/material.dart';
import 'globalNavigatorKey.dart';
import 'ErrorRetryDialog.dart'; // اللي فيه ErrorRetrySheet
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

// class ApiGuard {
//   /// Executes [request] and if failed shows ErrorRetrySheet with retry callback.
//   ///
//   /// - [request] لازم ترجع نفس شكل APIServices: {"success": bool, "message": ..., "data": ...}
//   /// - [onTryAgain] هتتنفذ لما المستخدم يدوس Try again
//   static Future<Map<String, dynamic>?> run({
//     required Future<Map<String, dynamic>> Function() request,
//     required VoidCallback onTryAgain,
//     String title = 'Something went wrong',
//     bool showDialog = true,
//   }) async {
//     final res = await request();
//
//     final ok = res["success"] == true;
//     if (ok) return res;
//
//     if (!showDialog) return res;
//
//     final ctx = rootNavKey.currentContext;
//     if (ctx == null) return res;
//
//     final msg = (res["message"] ?? "Request failed").toString();
//
//     // show sheet (Cancel + Try again)
//     await ErrorRetrySheet.show(
//       ctx,
//       title: title,
//       message: msg,
//       cancelText: 'Cancel',
//       tryAgainText: 'Try again',
//       onCancel: () {},
//       onTryAgain: onTryAgain,
//       barrierDismissible: true,
//     );
//
//     return res;
//   }
// }

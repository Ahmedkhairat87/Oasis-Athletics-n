import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorRetrySheet {
  // ✅ NEW: global lock to prevent showing twice
  static bool _isOpen = false;

  static Future<void> show(
    BuildContext context, {
    String title = 'Something went wrong',
    required String message,
    String cancelText = 'Cancel',
    String tryAgainText = 'Try again',
    VoidCallback? onTryAgain,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) async {
    if (!context.mounted) return;

    // ✅ prevent duplicate sheets
    if (_isOpen) return;
    _isOpen = true;

    try {
      await showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isDismissible: barrierDismissible,
        enableDrag: barrierDismissible,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.45),
        builder: (ctx) {
          final theme = Theme.of(ctx);
          final isDark = theme.brightness == Brightness.dark;

          final bgColor =
              isDark ? const Color(0xFF0F1115) : const Color(0xFFF9FAFB);

          final titleColor = isDark ? Colors.white : const Color(0xFF111827);
          final messageColor =
              isDark ? Colors.white70 : const Color(0xFF6B7280);

          final accentColor = const Color(0xFF2563EB); // modern blue

          return SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      color: bgColor.withOpacity(0.96),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(color: accentColor.withOpacity(0.12)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 30,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// subtle top indicator
                        Container(
                          width: 42.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),

                        SizedBox(height: 18.h),

                        /// icon
                        Container(
                          width: 54.w,
                          height: 54.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accentColor.withOpacity(0.12),
                          ),
                          child: Icon(
                            Icons.wifi_off_rounded,
                            size: 28.sp,
                            color: accentColor,
                          ),
                        ),

                        SizedBox(height: 14.h),

                        /// title
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w800,
                            color: titleColor,
                            letterSpacing: -0.2,
                          ),
                        ),

                        SizedBox(height: 6.h),

                        /// message
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.5.sp,
                            height: 1.45,
                            color: messageColor,
                          ),
                        ),

                        SizedBox(height: 20.h),

                        /// actions
                        Row(
                          children: [
                            /// cancel (ghost)
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  onCancel?.call();
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                ),
                                child: Text(
                                  cancelText,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: messageColor,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 10.w),

                            /// primary
                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    onTryAgain == null
                                        ? null
                                        : () {
                                          Navigator.of(ctx).pop();
                                          onTryAgain.call();
                                        },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  elevation: 0,
                                  backgroundColor: accentColor,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  tryAgainText,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (onTryAgain != null) ...[
                          SizedBox(height: 12.h),
                          Text(
                            'Make sure you’re connected to the internet.',
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              color: messageColor.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } finally {
      // ✅ always release lock
      _isOpen = false;
    }
  }
}

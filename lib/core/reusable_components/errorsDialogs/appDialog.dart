import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModernActionSheet {
  static bool _isOpen = false;

  /// Returns true if confirmed, false otherwise.
  static Future<bool> confirm(
      BuildContext context, {
        String title = "Confirm",
        required String message,

        String cancelText = "Cancel",
        String confirmText = "OK",

        IconData icon = Icons.help_outline_rounded,
        Color? accentColor, // default uses theme primary

        bool destructive = false, // makes confirm button red
        bool barrierDismissible = true,

        VoidCallback? onConfirmed, // optional side effect
        VoidCallback? onCancelled,
        String? footNote,
      }) async {
    if (!context.mounted) return false;
    if (_isOpen) return false;
    _isOpen = true;

    try {
      final res = await showModalBottomSheet<bool>(
        context: context,
        useRootNavigator: true,
        isDismissible: barrierDismissible,
        enableDrag: barrierDismissible,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.45),
        builder: (ctx) {
          final theme = Theme.of(ctx);
          final isDark = theme.brightness == Brightness.dark;

          final bgColor = isDark ? const Color(0xFF0F1115) : const Color(0xFFF9FAFB);
          final titleColor = isDark ? Colors.white : const Color(0xFF111827);
          final messageColor = isDark ? Colors.white70 : const Color(0xFF6B7280);

          final Color accent = accentColor ?? theme.colorScheme.primary;

          final Color confirmColor = destructive ? theme.colorScheme.error : accent;
          final Color confirmTextColor =
          destructive ? theme.colorScheme.onError : Colors.white;

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
                      border: Border.all(color: accent.withOpacity(0.12)),
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
                        // top indicator
                        Container(
                          width: 42.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),

                        SizedBox(height: 18.h),

                        // icon
                        Container(
                          width: 54.w,
                          height: 54.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: confirmColor.withOpacity(0.12),
                          ),
                          child: Icon(
                            icon,
                            size: 28.sp,
                            color: confirmColor,
                          ),
                        ),

                        SizedBox(height: 14.h),

                        // title
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

                        // message
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

                        // actions
                        Row(
                          children: [
                            // cancel (ghost)
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop(false);
                                  onCancelled?.call();
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

                            // confirm (primary)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop(true);
                                  onConfirmed?.call();
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  elevation: 0,
                                  backgroundColor: confirmColor,
                                  foregroundColor: confirmTextColor,
                                ),
                                child: Text(
                                  confirmText,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (footNote != null && footNote.trim().isNotEmpty) ...[
                          SizedBox(height: 12.h),
                          Text(
                            footNote,
                            textAlign: TextAlign.center,
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

      return res == true;
    } finally {
      _isOpen = false;
    }
  }

  static Future<void> singleAction(
      BuildContext context, {
        String title = "Notice",
        required String message,
        String actionText = "OK",
        IconData icon = Icons.info_outline_rounded,
        Color? accentColor,
        bool barrierDismissible = false,
        VoidCallback? onAction,
        String? footNote,
      }) async {
    if (!context.mounted) return;
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

          final bgColor = isDark ? const Color(0xFF0F1115) : const Color(0xFFF9FAFB);
          final titleColor = isDark ? Colors.white : const Color(0xFF111827);
          final messageColor = isDark ? Colors.white70 : const Color(0xFF6B7280);
          final Color accent = accentColor ?? theme.colorScheme.primary;

          return SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: Container(
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: bgColor.withOpacity(0.96),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: accent.withOpacity(0.12)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 42.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Container(
                        width: 54.w,
                        height: 54.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent.withOpacity(0.12),
                        ),
                        child: Icon(icon, size: 28.sp, color: accent),
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                          color: titleColor,
                        ),
                      ),
                      SizedBox(height: 6.h),
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            onAction?.call();
                          },
                          child: Text(actionText),
                        ),
                      ),
                      if (footNote != null && footNote.trim().isNotEmpty) ...[
                        SizedBox(height: 12.h),
                        Text(
                          footNote,
                          textAlign: TextAlign.center,
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
          );
        },
      );
    } finally {
      _isOpen = false;
    }
  }



}
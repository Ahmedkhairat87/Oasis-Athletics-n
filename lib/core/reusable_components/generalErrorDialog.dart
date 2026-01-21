import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UnderConstructionDialog {
  static Future<void> show(
    BuildContext context, {
    String title = 'Under Construction',
    required String message,
    String buttonText = 'Got it',
    IconData icon = Icons.construction_rounded,
    bool barrierDismissible = true,
  }) async {
    if (!context.mounted) return;

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
        final messageColor = isDark ? Colors.white70 : const Color(0xFF6B7280);

        final accentColor = const Color(
          0xFFF59E0B,
        ); // amber / construction vibe

        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: bgColor.withOpacity(0.96),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: accentColor.withOpacity(0.15)),
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
                      /// handle
                      Container(
                        width: 42.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),

                      SizedBox(height: 18.h),

                      /// icon
                      Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accentColor.withOpacity(0.15),
                        ),
                        child: Icon(icon, size: 30.sp, color: accentColor),
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

                      /// single action button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            elevation: 0,
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            buttonText,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/*UnderConstructionDialog.show(
  context,
  title: 'Coming Soon',
  message: 'Athletics reports are under development.',
  icon: Icons.build_circle_rounded,
  buttonText: 'Close',
);*/

// lib/core/reusable_components/teacher_comment_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors_Manager.dart';

/// Show a reusable bottom sheet that displays a teacher's comment.
/// `title` - subject/title shown on top
/// `teacherName` - teacher's name displayed
/// `comment` - the comment body
Future<void> showTeacherCommentSheet({
  required BuildContext context,
  required String title,
  required String teacherName,
  required String comment,
  double initialChildSize = 0.36,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // let us draw our own colorful shell
    builder: (ctx) {
      return _TeacherCommentSheetContent(
        title: title,
        teacherName: teacherName,
        comment: comment,
        initialChildSize: initialChildSize,
      );
    },
  );
}

/// Internal widget that builds the colorful, animated sheet.
class _TeacherCommentSheetContent extends StatelessWidget {
  const _TeacherCommentSheetContent({
    required this.title,
    required this.teacherName,
    required this.comment,
    required this.initialChildSize,
  });

  final String title;
  final String teacherName;
  final String comment;
  final double initialChildSize;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color primaryBlue = ColorsManager.primaryGradientStart;
    final Color primaryBlueEnd = ColorsManager.primaryGradientEnd;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentCoral = ColorsManager.accentCoral;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentPurple = ColorsManager.accentPurple;

    final Color innerBackground =
        isLight ? Colors.white.withOpacity(0.97) : ColorsManager.darkFields;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: initialChildSize,
      minChildSize: 0.2,
      maxChildSize: 0.85,
      builder: (ctx, controller) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.9, end: 1.0),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              alignment: Alignment.bottomCenter,
              child: child,
            );
          },
          child: Container(
            // outer colorful "shell"
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryBlue, primaryBlueEnd, accentSky],
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Container(
              // inner card for content
              decoration: BoxDecoration(
                color: innerBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // handle
                  Center(
                    child: Container(
                      width: 48.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: accentSky.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // colorful subject chip
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999.r),
                      gradient: LinearGradient(
                        colors: [
                          accentMint.withOpacity(0.9),
                          accentSky.withOpacity(0.9),
                          accentSun.withOpacity(0.9),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_rounded,
                          size: 16.r,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Teacher name with colorful accent underline
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 18.r,
                        color: accentPurple,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Teacher: $teacherName',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    width: 80.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999.r),
                      gradient: LinearGradient(
                        colors: [accentMint, accentSun, accentCoral],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // comment body
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color:
                              isLight
                                  ? ColorsManager.lightBackground.withOpacity(
                                    0.7,
                                  )
                                  : ColorsManager.darkBackground.withOpacity(
                                    0.8,
                                  ),
                        ),
                        child: Text(
                          comment,
                          style: TextStyle(
                            fontSize: 14.sp,
                            height: 1.45,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      // small mood icon left
                      Icon(
                        Icons.emoji_emotions_outlined,
                        size: 20.r,
                        color: accentMint,
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentMint,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 22.w,
                            vertical: 11.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          elevation: 4,
                          shadowColor: accentMint.withOpacity(0.4),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(Icons.check_rounded, size: 18.r),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

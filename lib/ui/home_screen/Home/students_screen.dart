import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/ui/home_screen/Home/student_inside_tabs/student_inside.dart';

import '../../../core/colors_Manager.dart';
import '../../../core/model/regStdModels/stdData.dart';
import '../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../core/reusable_components/app_colors_extension.dart';
import '../../../core/reusable_components/student_card.dart';
import 'home_screen.dart';

class StudentsScreen extends StatelessWidget {
  final List<stdData> students;
  final bool isRefreshing;
  final Future<void> Function() onRefresh;

  const StudentsScreen({
    super.key,
    required this.students,
    required this.isRefreshing,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = scheme.brightness == Brightness.light;

    // ✅ Save first student id for gallery cart (once)
    if (students.isNotEmpty) {
      final firstId = students.first.stdId?.toString() ?? '';
      if (firstId.isNotEmpty) {
        Future.microtask(() => GalleryStdIdStorage.save(firstId));
      }
    }

    return Stack(
      children: [
        _content(context),

        // ✅ Loading overlay
        if (isRefreshing)
          Positioned(
            top: 12.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: isLight
                    ? BoxDecoration(
                  color: Colors.white.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(color: Colors.black.withOpacity(0.06)),
                )
                    : BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.35),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 14.r,
                      height: 14.r,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8.w),
                    Text('Updating…', style: TextStyle(fontSize: 12.sp)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _content(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = scheme.brightness == Brightness.light;

    final Color primaryBlue =
    isLight ? ColorsManager.primaryGradientStart : ColorsManager.primaryGradientStartDark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Title row ONLY (no refresh/logout here anymore because in AppBar)
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      ColorsManager.accentSun,
                      ColorsManager.accentMint,
                      ColorsManager.accentSky,
                      primaryBlue,
                      ColorsManager.accentSun,
                    ],
                  ),
                ),
                child: const Center(child: Text('🎒', style: TextStyle(fontSize: 18))),
              ),
              SizedBox(width: 10.w),
              Text(
                "Students",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: scheme.textMainBlack,
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          Expanded(
            child: students.isEmpty
                ? Center(
              child: Text(
                'No students found',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: scheme.textMainBlack,
                ),
              ),
            )
                : GridView.builder(
              padding: EdgeInsets.only(bottom: 12.h),
              physics: const BouncingScrollPhysics(),
              itemCount: students.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (_, index) {
                final student = students[index];
                return _buildAnimatedStudentCard(context, student: student, index: index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStudentCard(
      BuildContext context, {
        required stdData student,
        required int index,
      }) {
    final name = student.stdFirstname ?? 'No Name';
    final photo = student.stdPicture ?? '';

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 260 + index * 40),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final double safe = value.clamp(0.0, 1.0);
        return Opacity(
          opacity: safe,
          child: Transform.translate(
            offset: Offset(0, (1 - safe) * 14),
            child: child,
          ),
        );
      },
      child: Center(
        child: StudentCard(
          name: name,
          photo: photo,
          onTap: () {
            studentNotifier.value = student;
            Navigator.pushNamed(
              context,
              StudentInside.routeName,
              arguments: student.stdId.toString(),
            );
          },
        ),
      ),
    );
  }
}


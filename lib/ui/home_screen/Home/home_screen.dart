// lib/ui/home_screen/Home/students_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/colors_Manager.dart';
import '../../../core/model/regStdModels/stdData.dart';
import '../../../core/reusable_components/app_background.dart';
import '../../../core/reusable_components/app_colors_extension.dart';
import '../../../core/reusable_components/student_card.dart';
import '../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../core/services/loginServices/AuthLogoutService.dart';
import '../../login_screen/login.dart';
import 'student_inside_tabs/student_inside.dart';

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

  Future<void> _handleLogout(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success = await ParentLogoutService.logout();
    Navigator.pop(context);

    if (success) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginScreen.routeName,
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Logout failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = scheme.brightness == Brightness.light;

    final Color primaryBlue =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;

    // ✅ Save first student id for gallery cart (once)
    if (students.isNotEmpty) {
      final firstId = students.first.stdId?.toString() ?? '';
      if (firstId.isNotEmpty) {
        Future.microtask(() => GalleryStdIdStorage.save(firstId));
      }
    }

    return  Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE + ICON (نفس الحركة)
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    final safe = value.clamp(0.0, 1.0);
                    return Opacity(
                      opacity: safe,
                      child: Transform.translate(
                        offset: Offset(0, (1 - safe) * 10),
                        child: child,
                      ),
                    );
                  },
                  child: Row(
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
                        child: const Center(
                          child: Text('🎒', style: TextStyle(fontSize: 18)),
                        ),
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
                      const Spacer(),

                      // ✅ Refresh زر صغير (اختياري، مش بيكسر UI)
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: scheme.textMainBlack,
                          size: 22.sp,
                        ),
                        onPressed: isRefreshing ? null : () => onRefresh(),
                      ),

                      /// ✅ LOGOUT BUTTON
                      IconButton(
                        icon: Icon(
                          Icons.logout,
                          color: scheme.textMainBlack,
                          size: 22.sp,
                        ),
                        onPressed: () => _handleLogout(context),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                Expanded(
                  child:
                      students.isEmpty
                          ? _emptyState(context, onRefresh)
                          : GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: students.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16.w,
                                  mainAxisSpacing: 16.h,
                                  childAspectRatio: 0.85,
                                ),
                            itemBuilder: (_, index) {
                              final student = students[index];
                              return _buildAnimatedStudentCard(
                                context,
                                student: student,
                                index: index,
                              );
                            },
                          ),
                ),
              ],
            ),
          ),

          // ✅ Loading overlay خفيف فوق الخلفية (مش solid)
          if (isRefreshing)
            Positioned(
              left: 0,
              right: 0,
              top: 8.h,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration:
                      isLight
                          ? BoxDecoration(
                            color: Colors.white.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(999.r),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.06),
                            ),
                          )
                          : BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(999.r),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.outline.withOpacity(0.35),
                            ),
                          ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 14.r,
                        height: 14.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Updating…',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ]
    );


  }

  Widget _emptyState(BuildContext context, Future<void> Function() onRefresh) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'No students found',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color:
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade700
                      : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 10.h),
          ElevatedButton.icon(
            onPressed: () => onRefresh(),
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
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

class GalleryStdIdStorage {
  static const _key = "galleryCartStdID";

  static Future<void> save(String stdId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, stdId);
  }

  static Future<String?> get() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}

// lib/core/reusable_components/student_header.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/core/reusable_components/widgets/app_avatar.dart';
import '../colors_Manager.dart';
import '../model/regStdModels/stdData.dart';
import '../model/stdLinks/StdFullData.dart';
import 'Notifiers/student_notifier.dart';

/// Compact header showing avatar, name, and grade only.
/// Use StudentHeader.fromNotifier() to listen automatically to studentNotifier.
class StudentHeader extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String grade;

  const StudentHeader({
    super.key,
    this.imageUrl,
    required this.name,
    required this.grade,
  });

  /// Builds automatically from studentNotifier (global).
  factory StudentHeader.fromNotifier({Key? key}) {
    return _StudentHeaderFromNotifier(key: key);
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final primaryBlue = ColorsManager.primaryGradientStart;
    final accentMint = ColorsManager.accentMint;
    final accentSun = ColorsManager.accentSun;
    final accentSky = ColorsManager.accentSky;

    final nameColor =
        isLight ? ColorsManager.lightText : ColorsManager.darkText;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.88, end: 1.0),
      duration: const Duration(milliseconds: 260),
      // you can keep easeOutBack for the “pop” feel, but clamp its output
      curve: Curves.easeOutBack,
      builder: (context, t, child) {
        // Clamp the animated value so opacity stays inside [0,1]
        final double safe = t.clamp(0.0, 1.0);
        return Opacity(
          opacity: safe,
          child: Transform.translate(
            // use the clamped value for translation too to avoid odd overshoot visuals
            offset: Offset((1 - safe) * -12, 0),
            child: child,
          ),
        );
      },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar (centered with name/class)
               Container(
                padding: EdgeInsets.all(2.5.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      primaryBlue,
                      accentSky,
                      ColorsManager.accentPurple,
                      accentMint,
                      accentSun,
                      ColorsManager.accentCoral,
                    ],
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surface, // ✅ مهم
                  ),
                  child: AppAvatar(
                    imageUrl: imageUrl,
                    name: name,
                    radius: 26, // ⬅️ صغرها شوية عشان البوردر
                  ),
                ),
              ),
            SizedBox(width: 12.w),

            // Name + Grade only
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final dynamicFont =
                          constraints.maxWidth < 200 ? 16.sp : 18.sp;
                      return Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: dynamicFont,
                          fontWeight: FontWeight.w800,
                          color: nameColor,
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 4.h),

                  Row(
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isLight
                                  ? accentMint
                                  : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          grade,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Theme.of(
                              context,
                            ).textTheme.bodySmall?.color?.withOpacity(0.82),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Listens to studentNotifier and updates header live.
class _StudentHeaderFromNotifier extends StudentHeader {
  const _StudentHeaderFromNotifier({super.key}) : super(name: "", grade: "");

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<stdData>(
      valueListenable: studentNotifier,
      builder: (context, student, _) {
        // Prepare avatar safely
        final imageUrl = student.stdPicture;

        return StudentHeader(
          imageUrl: imageUrl,
          name: student.stdFirstname ?? "",
          grade: student.currentClasse?.toString() ?? "",
        );
      },
    );
  }
}

/// NEW — Reads from Full Student Notifier

String fixImageUrl(String? raw) {
  if (raw == null || raw.isEmpty) return "";

  // Replace \ with /
  String clean = raw.replaceAll("\\", "/");

  // If already URL
  if (clean.startsWith("http")) return clean;

  // Otherwise assume server root
  return "https://staff.oasisdemaadi.com/$clean";
}

class StudentHeaderFromFull extends StatelessWidget {
  const StudentHeaderFromFull({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<StdFullData?>(
      valueListenable: studentFullNotifier,
      builder: (context, student, _) {
        if (student == null) return const SizedBox();

        final imageUrl = fixImageUrl(student.stdPicture);



        final gradeText =
            "${student.gradeDesc ?? ''} - ${student.className ?? ''}";

        return StudentHeader(
          imageUrl: imageUrl,
          name: student.stdFirstname ?? "",
          grade: gradeText,
        );
      },
    );
  }
}

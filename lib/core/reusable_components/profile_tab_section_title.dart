// lib/core/reusable_components/section_title.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors_Manager.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = ColorsManager.primaryGradientStart;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.85, end: 1.0),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        // ✅ Clamp to keep Opacity happy (0.0–1.0)
        final double safe = value.clamp(0.0, 1.0);

        return Opacity(
          opacity: safe,
          child: Transform.translate(
            offset: Offset(0, (1 - safe) * 6),
            child: Transform.scale(scale: safe, child: child),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Row(
          children: [
            // 🎨 Multicolor gradient bar accent
            Container(
              width: 5.w,
              height: 24.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primaryBlue, accentSky, accentMint, accentSun],
                ),
              ),
            ),

            SizedBox(width: 10.w),

            // 🌈 Title text
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors_Manager.dart';
import 'app_colors_extension.dart';

class StudentDetailsGridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const StudentDetailsGridItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    final Color primaryBlue = ColorsManager.primaryGradientStart;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;

    final Color innerBg =
        isDark
            ? Colors.grey.shade900.withOpacity(0.95)
            : Colors.white.withOpacity(0.98);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.92, end: 1.0),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 8),
          child: Transform.scale(scale: value, child: child),
        );
      },
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.r),
          child: Container(
            decoration:
                isDark
                    ? BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.35),
                      ),
                    )
                    : BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
                      // joyful multicolor halo
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primaryBlue.withOpacity(0.16),
                          accentSky.withOpacity(0.14),
                          accentMint.withOpacity(0.12),
                          accentSun.withOpacity(0.10),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.18),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
            child: Container(
              margin: EdgeInsets.all(1.5.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: innerBg,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ICON WITH MULTICOLOR RING
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.95, end: 1.0),
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOut,
                      builder: (context, value, iconChild) {
                        return Transform.scale(scale: value, child: iconChild);
                      },
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration:
                            isDark
                                ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outline
                                      .withOpacity(0.35),
                                )
                                : BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: SweepGradient(
                                    colors: [
                                      primaryBlue,
                                      accentSky,
                                      accentMint,
                                      accentSun,
                                      primaryBlue,
                                    ],
                                  ),
                                ),
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(icon, size: 26.sp, color: primaryBlue),
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // LABEL
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: scheme.textMainBlack,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 4.h),

                    // tiny colorful underline
                    Container(
                      width: 30.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999.r),
                        gradient: LinearGradient(
                          colors: [accentMint, accentSun],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

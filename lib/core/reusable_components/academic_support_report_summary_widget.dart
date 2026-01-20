import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Small summary tile used in the Academic Support Report header.
/// Example: Total / School / Extra
class ReportSummaryTile extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  /// When true the tile uses stronger background/border/shadow to improve legibility
  /// (useful inside a frosted/transparent panel).
  final bool elevated;

  const ReportSummaryTile({
    super.key,
    required this.label,
    required this.count,
    required this.color,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color textColor =
        Theme.of(context).textTheme.bodyMedium?.color ??
        (isLight ? Colors.black87 : Colors.white);

    // Appearance variations
    final double bgOpacity = elevated ? 0.94 : 0.75;
    final double gradientStartOpacity = elevated ? 0.18 : 0.12;
    final double gradientEndOpacity = elevated ? 0.06 : 0.04;
    final double borderOpacity = elevated ? 0.6 : 0.35;
    final double shadowOpacity = elevated ? 0.18 : 0.10;
    final double blurRadius = elevated ? 10 : 6;
    final Offset shadowOffset = const Offset(0, 3);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 6),
          child: Transform.scale(scale: value, child: child),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Theme.of(context).colorScheme.surface.withOpacity(
            bgOpacity,
          ), // stronger surface when elevated
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(gradientStartOpacity),
              color.withOpacity(gradientEndOpacity),
            ],
          ),
          border: Border.all(color: color.withOpacity(borderOpacity)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(shadowOpacity),
              blurRadius: blurRadius,
              offset: shadowOffset,
            ),
          ],
        ),
        child: Row(
          children: [
            // Tiny colorful dot as a playful accent
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            SizedBox(width: 8.w),

            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: textColor.withOpacity(elevated ? 0.88 : 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
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

// lib/core/reusable_components/profile_tab_read_only_field.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors_Manager.dart';

class ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  /// preferred label width in design px; will be capped to a portion of available width
  final double preferredLabelWidth;

  const ReadOnlyField({
    super.key,
    required this.label,
    required this.value,
    this.preferredLabelWidth = 110,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = ColorsManager.primaryGradientStart;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentMint = ColorsManager.accentMint;

    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // compute maximum label width as a fraction of available space
          final double maxLabelByFraction = constraints.maxWidth * 0.45;
          // preferredLabelWidth uses .w (ScreenUtil) for responsive scale
          final double preferredW = preferredLabelWidth.w;
          // choose the smaller of the preferred and the fraction; ensure it's non-negative
          final double labelW = max(0.0, min(preferredW, maxLabelByFraction));

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.85, end: 1.0),
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset((1 - value) * 8, 0),
                  child: child,
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // label: takes labelW (which will be <= 45% of available width)
                SizedBox(
                  width: labelW,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          primaryBlue.withOpacity(0.14),
                          accentSky.withOpacity(0.10),
                          accentMint.withOpacity(0.08),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // tiny colorful dot
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryBlue,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            label,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: primaryBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // small spacer
                SizedBox(width: 8.w),

                // value: takes remaining space, wraps, but limited to a few lines
                Expanded(
                  child: Text(
                    value,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.4,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

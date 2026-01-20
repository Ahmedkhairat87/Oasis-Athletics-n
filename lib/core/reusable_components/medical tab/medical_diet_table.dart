// lib/core/reusable_components/medical tab/medical_diet_table.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../colors_Manager.dart';

/// Model used by the weekly diet plan table.
class DietDayPlan {
  final String dayLabel; // e.g. "Sun"
  final String breakfast;
  final String lunch;
  final String dinner;
  final String snack;

  const DietDayPlan({
    required this.dayLabel,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snack,
  });
}

/// Portrait-style weekly diet widget (no horizontal scroll).
/// Uses a vertical column of "cards" — each card shows the day and its meals.
/// This avoids nested scroll issues and ensures each card is fully visible.
class MedicalDietTable extends StatelessWidget {
  final List<DietDayPlan> week;

  const MedicalDietTable({super.key, required this.week});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color primaryBlue =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
    final Color accentMint = ColorsManager.accentMint;

    final Color textColor = Theme.of(
      context,
    ).colorScheme.onSurface.withOpacity(0.92);

    final dayStyle = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
      color: primaryBlue,
    );

    final labelStyle = TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: textColor.withOpacity(0.95),
    );

    final valueStyle = TextStyle(
      fontSize: 12.sp,
      color: textColor,
      height: 1.35,
    );

    // If week is empty, render a helpful placeholder
    if (week.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "This week's diet plan",
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: primaryBlue,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Theme.of(context).colorScheme.surface.withOpacity(0.96),
              border: Border.all(color: accentMint.withOpacity(0.55)),
            ),
            child: Text(
              'No diet plan available for this week.',
              style: valueStyle,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "This week's diet plan",
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: primaryBlue,
          ),
        ),
        SizedBox(height: 8.h),

        // Use a Column of cards (no nested scrolling). The parent (MedicalTab)
        // already supplies scrolling via its SingleChildScrollView.
        Column(
          children: List.generate(week.length, (index) {
            final day = week[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == week.length - 1 ? 0 : 8.h,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: accentMint.withOpacity(0.55),
                    width: 0.9,
                  ),
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withOpacity(isLight ? 0.98 : 0.96),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day header
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999.r),
                            color: accentMint.withOpacity(0.12),
                          ),
                          child: Text(day.dayLabel, style: dayStyle),
                        ),
                        const Spacer(),
                        // optional small icon for visual balance
                        Icon(
                          Icons.restaurant_menu,
                          size: 18.sp,
                          color: primaryBlue.withOpacity(0.8),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // Meals in portrait layout — each row wraps naturally
                    _mealRow(
                      'Breakfast',
                      day.breakfast,
                      labelStyle,
                      valueStyle,
                    ),
                    SizedBox(height: 8.h),
                    _mealRow('Lunch', day.lunch, labelStyle, valueStyle),
                    SizedBox(height: 8.h),
                    _mealRow('Dinner', day.dinner, labelStyle, valueStyle),
                    SizedBox(height: 8.h),
                    _mealRow('Snack', day.snack, labelStyle, valueStyle),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _mealRow(
    String label,
    String value,
    TextStyle labelStyle,
    TextStyle valueStyle,
  ) {
    // Use flexible layout so long values wrap and do not overflow vertically.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label on the left (fixed width)
        SizedBox(
          width: 86.w,
          child: Text(
            '$label:',
            style: labelStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 8.w),
        // Value expands on the right and wraps on multiple lines if needed
        Expanded(
          child: Text(
            value.isNotEmpty ? value : '-',
            style: valueStyle,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}

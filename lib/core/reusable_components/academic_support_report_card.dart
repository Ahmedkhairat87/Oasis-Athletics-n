// lib/core/reusable_components/academic_support_report_card.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../colors_Manager.dart';

class AcademicSupportReportCard extends StatelessWidget {
  final String subject;
  final DateTime sessionDate;
  final bool isSchool;

  final String fromTime;
  final String toTime;

  // ✅ ONLY ADDITION
  final bool wasPresent;

  final VoidCallback onTap;

  const AcademicSupportReportCard({
    super.key,
    required this.subject,
    required this.sessionDate,
    required this.isSchool,
    required this.fromTime,
    required this.toTime,
    required this.wasPresent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = ColorsManager.primaryGradientStart;
    final Color accentMint = ColorsManager.accentMint; // “School”
    final Color accentCoral = ColorsManager.accentPurple; // “Extra”
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;

    final dateLabel = DateFormat.yMMMd().add_jm().format(sessionDate);

    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color cardBaseColor =
        isLight ? Colors.white : ColorsManager.darkFields;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.94, end: 1.0),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cardBaseColor,
                accentSky.withOpacity(0.10),
                accentMint.withOpacity(0.08),
              ],
            ),
            border: Border.all(
              color: (isSchool ? accentMint : accentCoral).withOpacity(0.8),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SUBJECT + DATE + TIME SLOT
              Row(
                children: [
                  Expanded(
                    child: Text(
                      subject,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: primaryBlue,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            size: 14.r,
                            color: accentSun.withOpacity(0.9),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            dateLabel,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color?.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),

                      // TIME SLOT
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 12.r,
                            color: Theme.of(
                              context,
                            ).textTheme.bodySmall?.color?.withOpacity(0.7),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Time Slot: $fromTime – $toTime',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color?.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              // ✅ ATTENDANCE STATUS (ONLY ADDITION)
              Row(
                children: [
                  Icon(
                    wasPresent
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    size: 14.r,
                    color: wasPresent ? Colors.green : Colors.redAccent,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    wasPresent ? 'Attendance: Present' : 'Attendance: Absent',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(
                        context,
                      ).textTheme.bodySmall?.color?.withOpacity(0.9),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // SCHOOL / EXTRA TOGGLE
              Row(
                children: [
                  Expanded(
                    child: _buildTogglePill(
                      label: 'school'.tr(),
                      icon: Icons.school,
                      active: isSchool,
                      activeColor: accentMint,
                      inactiveColor:
                          Theme.of(context).textTheme.bodySmall?.color ??
                          Colors.black54,
                    ),
                  ),
                  Expanded(
                    child: _buildTogglePill(
                      label: 'extra'.tr(),
                      icon: Icons.sports,
                      active: !isSchool,
                      activeColor: accentCoral,
                      inactiveColor:
                          Theme.of(context).textTheme.bodySmall?.color ??
                          Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTogglePill({
    required String label,
    required IconData icon,
    required bool active,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: active ? 16.w : 10.w,
            vertical: 6.h,
          ),
          decoration: BoxDecoration(
            color: active ? activeColor.withOpacity(0.14) : Colors.transparent,
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.r,
                color: active ? activeColor : inactiveColor.withOpacity(0.4),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? activeColor : inactiveColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
          height: 4.h,
          width: active ? 40.w : 0,
          decoration: BoxDecoration(
            color: active ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ],
    );
  }
}

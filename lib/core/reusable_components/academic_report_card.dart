// lib/core/reusable_components/academic_report_card.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors_Manager.dart';
import '../reusable_components/profile_tab_golden_card.dart';

class Report {
  final String id;
  final String title;
  final DateTime date;
  final int schoolTasks;
  final int extraTasks;
  final int attendedCount;
  final int totalSessions;

  Report({
    required this.id,
    required this.title,
    required this.date,
    required this.schoolTasks,
    required this.extraTasks,
    required this.attendedCount,
    required this.totalSessions,
  });

  double get attendanceRate =>
      totalSessions == 0 ? 0.0 : (attendedCount / totalSessions) * 100.0;
}

/// A single academic-style card that shows: icon + title + date + attendance bar + three badges
/// (School, Extra, Attendance). Each badge has its own tap callback.
/// Styled with a joyful, multicolor theme (blue brand + playful accents).
class AcademicReportCard extends StatelessWidget {
  const AcademicReportCard({
    super.key,
    required this.report,
    this.onTap,
    this.onTapSchoolTasks,
    this.onTapExtraTasks,
    this.onTapAttendance,
  });

  final Report report;
  final VoidCallback? onTap;
  final VoidCallback? onTapSchoolTasks;
  final VoidCallback? onTapExtraTasks;
  final VoidCallback? onTapAttendance;

  @override
  Widget build(BuildContext context) {
    // Brand + accents
    final Color primaryBlue = ColorsManager.primaryGradientStart;
    final Color secondaryBlue = ColorsManager.primaryGradientEnd;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentPurple = ColorsManager.accentPurple;
    final Color accentCoral = ColorsManager.accentCoral;

    final Color cardBackground =
        Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : ColorsManager.darkFields;

    return GoldCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            // subtle multicolor “confetti” gradient behind content
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryBlue.withOpacity(0.08),
                accentSky.withOpacity(0.06),
                accentMint.withOpacity(0.04),
              ],
            ),
          ),
          child: Container(
            // inner white/field area so content is crisp
            decoration: BoxDecoration(
              color: cardBackground.withOpacity(0.96),
              borderRadius: BorderRadius.circular(18.r),
            ),
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                // LEFT: circular icon – joyful multicolor “medal/balloon”
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        primaryBlue,
                        accentSky,
                        accentMint,
                        accentSun,
                        accentCoral,
                        accentPurple,
                        primaryBlue,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.menu_book, color: Colors.white, size: 26.r),
                        SizedBox(height: 4.h),
                        Text(
                          report.title,
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // MIDDLE: title, date, attendance progress
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title – strong joyful blue
                      Text(
                        report.title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: primaryBlue,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),

                      // Date – neutral text
                      Text(
                        '${report.date.year}-${report.date.month.toString().padLeft(2, '0')}-${report.date.day.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall?.color?.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // Attendance bar + % — joyful rainbow-like fill
                      GestureDetector(
                        onTap: onTapAttendance,
                        child: Row(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  // Background track
                                  Container(
                                    height: 9.h,
                                    decoration: BoxDecoration(
                                      color: secondaryBlue.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(
                                        999.r,
                                      ),
                                    ),
                                  ),
                                  // Filled portion with multicolor gradient
                                  FractionallySizedBox(
                                    widthFactor:
                                        (report.attendanceRate.clamp(0, 100) /
                                            100.0),
                                    child: Container(
                                      height: 9.h,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            accentMint,
                                            accentSky,
                                            accentSun,
                                            accentCoral,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          999.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: accentPurple.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(999.r),
                                border: Border.all(
                                  color: accentPurple.withOpacity(0.9),
                                ),
                              ),
                              child: Text(
                                '${report.attendanceRate.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: accentPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 12.w),

                // RIGHT: School / Extra / Attendance badges (vertical)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // School count badge – blue / purple
                    GestureDetector(
                      onTap: onTapSchoolTasks,
                      child: _countBadge(
                        context,
                        label: 'school'.tr(),
                        count: report.schoolTasks,
                        background: accentSky.withOpacity(0.15),
                        borderColor: accentSky,
                        pillColor: accentPurple,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Extra count badge – mint / coral
                    GestureDetector(
                      onTap: onTapExtraTasks,
                      child: _countBadge(
                        context,
                        label: 'extra'.tr(),
                        count: report.extraTasks,
                        background: accentMint.withOpacity(0.16),
                        borderColor: accentMint,
                        pillColor: accentCoral,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Attendance badge – sun + coral with blue icon
                    GestureDetector(
                      onTap: onTapAttendance,
                      child: _attendanceBadge(
                        context,
                        '${report.attendedCount}/${report.totalSessions}',
                        labelColor: accentSun,
                        pillColor: accentCoral,
                        iconColor: primaryBlue,
                        background: accentSun.withOpacity(0.10),
                        borderColor: accentSun.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _countBadge(
    BuildContext context, {
    required String label,
    required int count,
    required Color background,
    required Color borderColor,
    required Color pillColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: borderColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: pillColor,
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceBadge(
    BuildContext context,
    String text, {
    required Color labelColor,
    required Color pillColor,
    required Color iconColor,
    required Color background,
    required Color borderColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today, size: 14.r, color: iconColor),
          SizedBox(width: 6.w),
          Text(
            'attend'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              color: labelColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: pillColor,
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

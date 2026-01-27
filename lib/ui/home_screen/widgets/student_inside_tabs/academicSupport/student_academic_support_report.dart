import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/core/model/stdLinks/academicSupport/StdSubjectDetailsData.dart';

import '../../../../../core/Utilities/dateHelper.dart';
import '../../../../../core/reusable_components/academic_support_bottom_sheet.dart';
import '../../../../../core/reusable_components/academic_support_report_summary_widget.dart';
import '../../../../../core/reusable_components/app_background.dart';
import '../../../../../core/reusable_components/academic_support_report_card.dart';
import '../../../../../core/colors_Manager.dart';

class AcademicReportItem {
  final String id;
  final String subject;
  final DateTime sessionDate;
  final bool isSchoolTask;
  final String teacherName;
  final String teacherComment;

  AcademicReportItem({
    required this.id,
    required this.subject,
    required this.sessionDate,
    required this.isSchoolTask,
    required this.teacherName,
    required this.teacherComment,
  });
}

class StudentAcademicSupportReport extends StatelessWidget {
  final List<StdSubjectDetailsData> reports;

  const StudentAcademicSupportReport({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color primaryBlue =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;

    final Color secondaryBlue =
        isLight
            ? ColorsManager.primaryGradientEnd
            : ColorsManager.primaryGradientEndDark;

    // final items = _mockItems();
    final items =
        reports
            .map(
              (r) => AcademicReportItem(
                id: r.attendanceId.toString(),
                subject: r.subjectNameFR ?? 'Unknown',
                sessionDate: parseApiDate(r.attendanceDate) ?? DateTime(2000),
                isSchoolTask: (r.devoir?.trim().toLowerCase() == 'yes'),
                teacherName: r.empName ?? '',
                teacherComment: r.comment ?? '',
              ),
            )
            .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          "academic_support_report".tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryBlue.withOpacity(0.98),
                    secondaryBlue.withOpacity(0.98),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: AppBackground(
        useAppBarBlur: true,
        child: SafeArea(
          top: false,
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 980.w),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface, // OPAQUE
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      final t = value.clamp(0.0, 1.0);
                      return Opacity(
                        opacity: t,
                        child: Transform.translate(
                          offset: Offset(0, (1 - t) * 10),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ReportSummaryTile(
                                label: 'total'.tr(),
                                count: items.length,
                                color: ColorsManager.accentSky,
                                elevated: true,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: ReportSummaryTile(
                                label: 'school'.tr(),
                                count:
                                    items.where((e) => e.isSchoolTask).length,
                                color: ColorsManager.accentMint,
                                elevated: true,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: ReportSummaryTile(
                                label: 'extra'.tr(),
                                count:
                                    items.length -
                                    items.where((e) => e.isSchoolTask).length,
                                color: ColorsManager.accentPurple,
                                elevated: true,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: items.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final it = items[index];

                              return TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: Duration(
                                  milliseconds: 200 + index * 40,
                                ),
                                curve: Curves.easeOutBack,
                                builder: (context, value, child) {
                                  final t = value.clamp(0.0, 1.0);
                                  return Opacity(
                                    opacity: t,
                                    child: Transform.translate(
                                      offset: Offset(0, (1 - t) * 8),
                                      child: child,
                                    ),
                                  );
                                },
                                child: AcademicSupportReportCard(
                                  subject: it.subject,
                                  sessionDate: it.sessionDate,
                                  isSchool: it.isSchoolTask,
                                  onTap: () => _onReportTap(context, it),
                                  fromTime: '12:00',
                                  toTime: '1:00',
                                  wasPresent: true,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onReportTap(BuildContext context, AcademicReportItem item) {
    showTeacherCommentSheet(
      context: context,
      title: item.subject,
      teacherName: item.teacherName,
      comment: item.teacherComment,
    );
  }
}

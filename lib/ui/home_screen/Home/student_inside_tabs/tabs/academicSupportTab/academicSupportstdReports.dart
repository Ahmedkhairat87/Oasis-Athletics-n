import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/core/reusable_components/app_background.dart';
import '../../../../../../core/colors_Manager.dart';

import 'package:oasisathletic/core/model/stdLinks/academicSupport/StdAcademicSupportResponse.dart';

import '../../../../../../core/reusable_components/widgets/app_avatar.dart';

class StudentReports extends StatelessWidget {
  static const routeName = '/studentReports';

  final StdAcademicSupportResponse? response;
  final int reportNo;

  const StudentReports({
    super.key,
    required this.response,
    required this.reportNo,
  });

  // --------- helpers (safe) ----------
  String _txt(dynamic v, {String empty = '-'}) {
    if (v == null) return empty;
    final s = v.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'null') return empty;
    return s;
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toInt();
    final s = v.toString().trim();
    return int.tryParse(s) ?? 0;
  }


  String _fixImageUrl(String? raw) {
    if (raw == null || raw.isEmpty) return "";

    final clean = raw.replaceAll("\\", "/");

    if (clean.startsWith("http")) return clean;

    return "https://staff.oasisdemaadi.com/$clean";
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color titleColor = isLight
        ? ColorsManager.primaryGradientStart
        : Theme.of(context).colorScheme.onSurface;
    final report =
        (response?.stdReports != null && response!.stdReports!.isNotEmpty)
            ? response!.stdReports!.first
            : null;

    final subjects = response?.stdSubjectData ?? [];

    // ===== header values =====
    final studentName = _txt(report?.nom, empty: '-');
    final className = _txt(report?.className, empty: '-');
    final schoolTasks = _toInt(report?.schoolTask);
    final extraTasks = _toInt(report?.extraTask);

    final present = _toInt(report?.presentCount);
    final absent = _toInt(report?.absentCount);



    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          "Report $reportNo",
          style: TextStyle(
            color: isLight ? Colors.white : Theme.of(context).colorScheme.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration:
                  isLight
                      ? BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorsManager.primaryGradientStart.withOpacity(
                              0.98,
                            ),
                            ColorsManager.primaryGradientEnd.withOpacity(0.98),
                          ],
                        ),
                      )
                      : BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                      ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 16.h),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                /// ================= HEADER CARD =================
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration:
                      isLight
                          ? BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.r),
                          )
                          : BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.outline.withOpacity(0.35),
                            ),
                          ),
                  child: Row(
                    children: [
                      AppAvatar(
                        imageUrl: _fixImageUrl(report?.stdPicture), // ✅ الصحيح
                        name: studentName,
                        radius: 28, // خليها نفس CircleAvatar القديمة
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              studentName,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: titleColor,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Class: $className",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: isLight ? Colors.grey.shade600 : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                           Text("school_tasks".tr()),
                          _pill(context, "$schoolTasks", Colors.cyan),
                        ],
                      ),
                      SizedBox(width: 6.w),
                      Column(
                        children: [
                           Text("extra_tasks".tr()),
                          _pill(context, "$extraTasks", Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 14.h),

                /// ================= ATTENDANCE =================
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isLight ? Colors.red.shade400 : Colors.red.shade400,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _attendanceRow(
                        context,
                        "Present",
                        "$present",
                        Icons.check_circle,
                      ),
                      SizedBox(height: 6.h),
                      _attendanceRow(
                        context,
                        "Absent",
                        "$absent",
                        Icons.cancel,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                /// ================= SUBJECTS =================
                if (subjects.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color:
                          isLight
                              ? Colors.white
                              : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color:
                            isLight
                                ? Colors.grey.shade300
                                : Theme.of(
                                  context,
                                ).colorScheme.outline.withOpacity(0.35),
                      ),
                    ),
                    child: Text(
                      "no_subrepo_found".tr(),
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  )
                else
                  ...List.generate(subjects.length, (index) {
                    final s = subjects[index];

                    // ✅ title + fields
                    final title = _txt(s.subjectName, empty: 'Unknown');

                    final autonomie = _txt(s.autonomie);
                    final organisation = _txt(s.organisation);
                    final expression = _txt(s.expression);
                    final participation = _txt(s.participation);

                    final comment = _txt(s.commentaire, empty: '-');

                    // ✅ نفس ال UI بتاعك: indicators list of strings
                    final indicators = <String>[
                      "Autonomie: $autonomie",
                      "Organisation: $organisation",
                      "Expression: $expression",
                      "Participation: $participation",
                    ];

                    // ✅ نفس الألوان اللي في المثال (أول كارت أخضر، تاني برتقالي، والباقي alternation)
                    final bgColor =
                        (index % 2 == 0)
                            ? Colors.green.shade50
                            : Colors.orange.shade50;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: _subjectCard(
                        context: context,
                        title: title,
                        color: bgColor,
                        indicators: indicators,
                        comment: comment,
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= SMALL WIDGETS =================

  Widget _pill(BuildContext context, String text, Color color) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color:
              isLight
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _attendanceRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Row(
      children: [
        Icon(
          icon,
          color:
              isLight
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
          size: 18.sp,
        ),
        SizedBox(width: 6.w),
        Text(
          "$label: $value",
          style: TextStyle(
            color:
                isLight
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _subjectCard({
    required BuildContext context,
    required String title,
    required Color color,
    required List<String> indicators,
    required String comment,
  }) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color titleColor =
        isLight
            ? ColorsManager.primaryGradientStart
            : Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color:
              isLight
                  ? Colors.grey.shade300
                  : Theme.of(context).colorScheme.outline.withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          SizedBox(height: 12.h),

          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children:
                indicators.map((e) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isLight
                              ? Colors.white
                              : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      e,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
          ),

          SizedBox(height: 14.h),

          // 📝 Teacher's Comment label
          Row(
            children: [
              const Text("📝"),
              SizedBox(width: 6.w),
              Text(
                "teacher_cmnt".tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Comment box
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color:
                  isLight
                      ? Colors.blue.shade50
                      : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              comment,
              style: TextStyle(fontSize: 14.sp, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/core/reusable_components/app_background.dart';
import '../../../../../core/colors_Manager.dart';

import 'package:oasisathletic/core/model/stdLinks/academicSupport/StdAcademicSupportResponse.dart';

class StudentReports extends StatelessWidget {
  static const routeName = '/studentReports';

  /// ✅ نستقبل الداتا الجاهزة من الصفحة اللي قبلها
  final StdAcademicSupportResponse? response;

  const StudentReports({super.key, required this.response});

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

  // اختياري: لو الصورة جاية path من API
  // رجّع null لو مفيش صورة عشان نسيبها زي ما هي (Asset)
  static const String _imagesBaseUrl = "https://staff.oasisdemaadi.com/";
  ImageProvider? _studentImage(String? apiPath) {
    final p = (apiPath ?? '').trim();
    if (p.isEmpty || p.toLowerCase() == 'null') return null;

    // Normalize slashes لو جاية بـ \
    final normalizedPath = p.replaceAll('\\', '/');

    return NetworkImage("$_imagesBaseUrl$normalizedPath");
  }

  @override
  Widget build(BuildContext context) {
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

    // صورة الطالب: لو عندك std_picture
    final studentAvatar = _studentImage(report?.stdPicture);

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
                    ColorsManager.primaryGradientStart.withOpacity(0.98),
                    ColorsManager.primaryGradientEnd.withOpacity(0.98),
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                /// ================= HEADER CARD =================
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28.r,
                        backgroundImage:
                            studentAvatar ??
                            const AssetImage('assets/images/Lucka.jpg'),
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
                                color: ColorsManager.primaryGradientStart,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Class: $className",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                           Text("school_tasks".tr()),
                          _pill("$schoolTasks", Colors.cyan),
                        ],
                      ),
                      SizedBox(width: 6.w),
                      Column(
                        children: [
                           Text("extra_tasks".tr()),
                          _pill("$extraTasks", Colors.orange),
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
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _attendanceRow("Present", "$present", Icons.check_circle),
                      SizedBox(height: 6.h),
                      _attendanceRow("Absent", "$absent", Icons.cancel),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: Colors.grey.shade300),
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

  Widget _pill(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _attendanceRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18.sp),
        SizedBox(width: 6.w),
        Text(
          "$label: $value",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _subjectCard({
    required String title,
    required Color color,
    required List<String> indicators,
    required String comment,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: ColorsManager.primaryGradientStart,
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
                      color: Colors.white,
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
                  color: ColorsManager.primaryGradientStart,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Comment box
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
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

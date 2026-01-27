import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/core/model/stdLinks/academicSupport/StdAcademicSupportResponse.dart';
import '../../../../../core/colors_Manager.dart';
import '../../../../../core/reusable_components/profile_tab_golden_card.dart';
import '../../../../../core/reusable_components/profile_tab_section_title.dart';
import '../../../../../core/reusable_components/Notifiers/student_notifier.dart';

import '../../../../../core/services/stdProfile/stdAcademicSupportServices/AcademicSupportService.dart';
import '../academicSupport/student_academic_support_report.dart';
import 'academicSupportstdReports.dart';

class AcademicSupportMainTab extends StatefulWidget {
  const AcademicSupportMainTab({super.key});

  @override
  State<AcademicSupportMainTab> createState() => _AcademicTabState();
}

class _AcademicTabState extends State<AcademicSupportMainTab> {
  bool loading = true;

  StdAcademicSupportResponse? responseData;

  int schoolTasks = 0;
  int extraTasks = 0;
  int attendanceCount = 0;

  @override
  void initState() {
    super.initState();
    loadAcademicSupport();
  }

  Future<void> loadAcademicSupport() async {
    setState(() => loading = true);

    final stdId = studentNotifier.value.stdId.toString();

    final data = await AcademicSupportService.getAcademicSupport(
      stdId: studentNotifier.value.stdId.toString(),
    );

    if (!mounted) return;

    setState(() {
      responseData = data;
      loading = false;

      if (data?.stdReports != null && data!.stdReports!.isNotEmpty) {
        final r = data.stdReports!.first;

        schoolTasks = (r.schoolTask ?? 0).toInt();
        extraTasks = (r.extraTask ?? 0).toInt();
        attendanceCount = (r.presentCount ?? 0).toInt();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = ColorsManager.primaryGradientStart;

    if (loading) {
      return Center(child: CircularProgressIndicator(color: primaryBlue));
    }

    return _buildUI(context);
  }

  Widget _buildUI(BuildContext context) {
    final Color primaryBlue = ColorsManager.primaryGradientStart;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentPurple = ColorsManager.accentPurple;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          final double t = value.clamp(0.0, 1.0);
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, (1 - t) * 10),
              child: child,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SectionTitle('academic_support'.tr()),
            SizedBox(height: 12.h),

            GoldCard(
              child: Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
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
                          child: Icon(
                            Icons.menu_book,
                            color: Colors.white,
                            size: 28.r,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            "tasks".tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      "tasks_overview".tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withOpacity(0.85),
                      ),
                    ),

                    SizedBox(height: 14.h),

                    InkWell(
                      borderRadius: BorderRadius.circular(14.r),
                      onTap: () {
                        if (responseData?.stdSubjectDetailsData != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => StudentAcademicSupportReport(
                                    reports:
                                        responseData!.stdSubjectDetailsData!,
                                  ),
                            ),
                          );
                        }
                      },
                      child: _assignmentsCard(
                        context,
                        primaryBlue,
                        accentMint,
                        accentSky,
                        accentPurple,
                      ),
                    ),

                    /*SizedBox(height: 14.h),

                    _attendanceCard(
                      context,
                      attendanceCount,
                      primaryBlue,
                      accentMint,
                      accentPurple,
                    ),*/
                  ],
                ),
              ),
            ),

            SizedBox(height: 14.h),

            /// ================= SECOND GOLD CARD =================
            /// Students’ Reports
            GoldCard(
              child: Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                accentPurple,
                                accentSky,
                                accentMint,
                                accentSun,
                                accentPurple,
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.description_rounded,
                            color: Colors.white,
                            size: 28.r,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            "students_reports".tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      "reports_description".tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withOpacity(0.85),
                      ),
                    ),

                    SizedBox(height: 14.h),

                    _studentsReportsCard(
                      context,
                      primaryBlue,
                      accentMint,
                      accentPurple,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= REST UNCHANGED =================

  Widget _assignmentsCard(
    BuildContext context,
    Color primaryBlue,
    Color accentMint,
    Color accentSky,
    Color accentPurple,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: LinearGradient(
          colors: [accentSky.withOpacity(0.16), accentMint.withOpacity(0.14)],
        ),
        border: Border.all(color: accentMint.withOpacity(0.9)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "assignments".tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: primaryBlue,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20.r,
                color: ColorsManager.accentSun,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(child: _badge("school".tr(), schoolTasks, primaryBlue)),
              SizedBox(width: 10.w),
              Expanded(child: _badge("extra".tr(), extraTasks, primaryBlue)),
            ],
          ),
        ],
      ),
    );
  }



  Widget _studentsReportsCard(
    BuildContext context,
    Color primaryBlue,
    Color accentMint,
    Color accentPurple,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: accentMint.withOpacity(0.9)),
        gradient: LinearGradient(
          colors: [
            accentPurple.withOpacity(0.10),
            accentMint.withOpacity(0.08),
          ],
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StudentReports(response: responseData),
            ),
          );
        },
        child: Row(
          children: [
            Icon(Icons.description_rounded, color: accentPurple, size: 18.r),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                "students_reports".tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: primaryBlue,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20.r,
              color: ColorsManager.accentSun,
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, int count, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
        color: color.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: color,
                fontSize: 14.sp,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text("$count", style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

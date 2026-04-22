import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:oasisathletic/core/apiControl/apiManager.dart';

import '../../../../../../../core/colors_Manager.dart';
import '../../../../../../../core/model/stdLinks/medicalTab/MedicalTabReportsResponse.dart';
import '../../../../../../../core/model/stdLinks/medicalTab/StdDoctorPhysiotherapist.dart';
import '../../../../../../../core/model/stdLinks/medicalTab/StdDoctorReports.dart';
import '../../../../../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../../../../../core/reusable_components/profile_tab_golden_card.dart';
import '../../../../../../../core/reusable_components/profile_tab_section_title.dart';
import '../../../../../../../core/reusable_components/medical tab/medical_diet_table.dart';
import '../../../../../../../core/services/stdProfile/StudentMedicalUpdateFlagService.dart';
import '../../../../../../../core/services/stdProfile/studentMedicalReports/StudentMedicalReportsService.dart';
import '../../../../../../webView-attachmentopener/WebViewScreen.dart';
import '../widget/PhysioVisitCard.dart';


class MedicalTab extends StatefulWidget {
  const MedicalTab({super.key});

  @override
  State<MedicalTab> createState() => _MedicalTabState();
}

class _MedicalTabState extends State<MedicalTab> {
  bool _loading = true;
  bool _error = false;
  MedicalTabReportsResponse? _data;

  bool get isLight => Theme.of(context).brightness == Brightness.light;

  Color get titleColor =>
      isLight
          ? ColorsManager.primaryGradientStart
          : Theme.of(context).colorScheme.onSurface;

  @override
  void initState() {
    super.initState();
    _loadMedicalData();
  }

  // ================= API CALL =================
  Future<void> _loadMedicalData() async {
    setState(() {
      _loading = true;
      _error = false;
    });

    final stdId = studentNotifier.value.stdId.toString();
    debugPrint("🧑‍🎓 STD ID: $stdId");

    debugPrint("📡 CALLING MEDICAL SERVICE...");
    final result = await StdMedicalLinksService.getMedicalReports(
      stdId: stdId,
    );
    debugPrint("📡 RESULT: $result");
    if (result != null) {
      setState(() {
        _data = result;
        _loading = false;
      });
    } else {
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  // ================= Update readed flag=================
  Future<void> _markDoctorReportAsRead(StdDoctorReports report) async {
    if ((report.readflag ?? 0) == 1) return;

    final updateType = report.updateType?.toString().trim() ?? '';
    final reportID = report.ReportID?.toString() ?? '';

    if (updateType.isEmpty || reportID.isEmpty) {
      debugPrint("❌ Doctor report missing updateType or ReportID");
      return;
    }

    final ok = await StudentMedicalUpdateFlagService.updateMedicalFlag(
      updateType: updateType,
      reportID: reportID,
    );

    if (!mounted) return;

    if (ok) {
      setState(() {
        report.readflag = 1;
      });
    }
  }

  Future<void> _markPhysioReportAsRead(StdDoctorPhysiotherapist report) async {
    if ((report.readflag ?? 0) == 1) return;

    final updateType = report.updateType?.toString().trim() ?? '';
    final reportID = report.ReportID?.toString() ?? '';

    if (updateType.isEmpty || reportID.isEmpty) {
      debugPrint("❌ Physio report missing updateType or ReportID");
      return;
    }

    final ok = await StudentMedicalUpdateFlagService.updateMedicalFlag(
      updateType: updateType,
      reportID: reportID,
    );

    if (!mounted) return;

    if (ok) {
      setState(() {
        report.readflag = 1;
      });
    }
  }

  // ================= WEBVIEW =================
  void _openWebView(String? path) {
    if (path == null || path.isEmpty) {
      debugPrint("❌ EMPTY FILE PATH");
      return;
    }

    const baseUrl = "https://athletic.oasisdemaadi.com/";

    final fullUrl = path.startsWith('http')
        ? path
        : baseUrl + path.replaceAll('\\', '/');

    debugPrint("🌐 OPENING URL: $fullUrl");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WebViewScreen(
          url: fullUrl,
          title: 'report'.tr(),
        ),
      ),
    );
  }

  // ================= FORMAT =================
  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "—";
    try {
      final d = DateTime.parse(date);
      return "${d.day.toString().padLeft(2, '0')}/"
          "${d.month.toString().padLeft(2, '0')}/"
          "${d.year}";
    } catch (_) {
      return date;
    }
  }

  Widget _empty(String text) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Center(
        child: Text(text, style: TextStyle(fontSize: 13.sp)),
      ),
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    final accentMint = ColorsManager.accentMint;
    final accentSun = ColorsManager.accentSun;
    final accentSky = ColorsManager.accentSky;
    final accentPurple = ColorsManager.accentPurple;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('error_loading'.tr()),
            SizedBox(height: 10.h),
            ElevatedButton(
              onPressed: _loadMedicalData,
              child: Text('try_again'.tr()),
            ),
          ],
        ),
      );
    }

    final allDoctorReports = _data?.stdDoctorReports ?? [];
    final physio = _data?.stdDoctorPhysiotherapist ?? [];
    final inbody = _data?.stdDoctorinbody ?? [];
    final diet = _data?.stdDoctorDiet ?? [];

    final doctorReports = allDoctorReports.where((e) {
      final who = (e.who ?? '').trim().toLowerCase();
      return who == 'doctor';
    }).toList();

    final psychologistReports = allDoctorReports.where((e) {
      final who = (e.who ?? '').trim().toLowerCase();
      return who == 'psychologist';
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= DOCTOR GROUP =================
          SectionTitle('doctor'.tr()),
          SizedBox(height: 10.h),

          // 1) DOCTOR SECTION
          _sectionHeader(
            Icons.medical_services,
            'doctor_section'.tr(),
            accentSky,
          ),
          SizedBox(height: 6.h),
          GoldCard(
            child: doctorReports.isEmpty
                ? _empty('no_doctor_reports'.tr())
                : Column(
              children: doctorReports.map((r) {
                final isRead = (r.readflag ?? 0) == 1;

                return ListTile(
                  title: Text(_formatDate(r.uploadDate)),
                  subtitle: Text(
                    (r.doctorComments ?? '').trim().isEmpty
                        ? '—'
                        : r.doctorComments!,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _statusChip(isRead, accentMint),
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () async {
                          await _markDoctorReportAsRead(r);
                          _openWebView(r.filePath);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 14.h),

          // 2) PSYCHOLOGIST SECTION
          _sectionHeader(
            Icons.psychology,
            'psychologist_section'.tr(),
            accentPurple,
          ),
          SizedBox(height: 6.h),
          GoldCard(
            child: psychologistReports.isEmpty
                ? _empty('no_psychologist_reports'.tr())
                : Column(
              children: psychologistReports.map((r) {
                final isRead = (r.readflag ?? 0) == 1;

                return ListTile(
                  title: Text(_formatDate(r.uploadDate)),
                  subtitle: Text(
                    (r.doctorComments ?? '').trim().isEmpty
                        ? '—'
                        : r.doctorComments!,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _statusChip(isRead, accentMint),
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () => _openWebView(r.filePath),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 14.h),

          // 3) PHYSIOTHERAPIST SECTION
          _sectionHeader(
            Icons.fitness_center,
            'physiotherapist_section'.tr(),
            accentMint,
          ),
          SizedBox(height: 6.h),
          physio.isEmpty
              ? _emptySectionCard('no_physiotherapy_reports'.tr())
              : GoldCard(
            child: Column(
              children: List.generate(physio.length, (index) {
                final v = physio[index];
                final isRead = (v.readflag ?? 0) == 1;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == physio.length - 1 ? 0 : 10.h,
                  ),
                  child: PhysioVisitCard(
                    visit: v,
                    isRead: isRead,
                    accentMint: accentMint,
                    accentSun: accentSun,
                    accentSky: accentSky,
                    titleColor: titleColor,
                    onView: () async {
                      await _markPhysioReportAsRead(v);
                    },
                    onOpenLink: () {
                      final path =
                      (v.exerciseLinks?.toString().trim().isNotEmpty ?? false)
                          ? v.exerciseLinks.toString()
                          : v.exerciseVideoPath?.toString();
                      _openWebView(path);
                    },
                  ),
                );
              }),
            ),
          ),

          SizedBox(height: 18.h),

          // ================= NUTRITIONIST GROUP =================
          SectionTitle('nutritionist'.tr()),
          SizedBox(height: 10.h),

          // 4) INBODY
          _sectionHeader(
            Icons.monitor_weight,
            'inbody_follow_up'.tr(),
            accentSun,
          ),
          SizedBox(height: 6.h),
          GoldCard(
            child: inbody.isEmpty
                ? _empty('no_inbody_reports'.tr())
                : Column(
              children: inbody.map((b) {
                return ListTile(
                  title: Text(_formatDate(b.createdAt)),
                  subtitle: Text(
                    (b.notes ?? '').trim().isEmpty ? '—' : b.notes!,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    onPressed: () => _openWebView(b.inbodyPath),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 14.h),

          // 5) WEEKLY DIET PLAN
          _sectionHeader(
            Icons.restaurant,
            'weekly_diet_plan'.tr(),
            accentMint,
          ),
          SizedBox(height: 6.h),
          GoldCard(
            child: diet.isEmpty
                ? _empty('no_diet_plan'.tr())
                : MedicalDietTable(
              week: diet.map((d) {
                return DietDayPlan(
                  dayLabel: d.dayOfWeek ?? '',
                  breakfast: d.breakfast ?? '',
                  lunch: d.lunch ?? '',
                  dinner: d.dinner ?? '',
                  snack: d.snack ?? '',
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _sectionHeader(IconData icon, String title, Color color) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14.r,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, size: 16.sp, color: color),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _statusChip(bool isRead, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: isRead ? color.withOpacity(0.1) : Colors.red.withOpacity(0.1),
      ),
      child: Text(
        isRead ? 'read'.tr() : 'unread'.tr(),
        style: TextStyle(
          fontSize: 10.sp,
          color: isRead ? color : Colors.red,
        ),
      ),
    );
  }

  Widget _emptySectionCard(String text) {
    return GoldCard(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ),
    );
  }


}
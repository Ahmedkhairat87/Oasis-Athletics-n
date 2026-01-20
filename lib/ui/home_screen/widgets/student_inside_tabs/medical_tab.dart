// lib/ui/home_screen/widgets/student_inside_tabs/medical_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/colors_Manager.dart';
import '../../../../core/reusable_components/profile_tab_golden_card.dart';
import '../../../../core/reusable_components/profile_tab_section_title.dart';
import '../../../../core/reusable_components/medical tab/medical_diet_table.dart';

// ----------------------------- MODELS ---------------------------------

class PsychologistReport {
  final String id;
  final DateTime date;
  final String doctorName;
  final String comment;
  final String fileName;
  bool isRead;

  PsychologistReport({
    required this.id,
    required this.date,
    required this.doctorName,
    required this.comment,
    required this.fileName,
    this.isRead = false,
  });
}

class PhysiotherapyVisit {
  final String id;
  final DateTime visitDate;
  final String complaint;
  final String diagnosis;
  final String neededScans;
  final DateTime? followUpDate;
  final String fileName;
  bool isRead;

  PhysiotherapyVisit({
    required this.id,
    required this.visitDate,
    required this.complaint,
    required this.diagnosis,
    required this.neededScans,
    required this.fileName,
    this.followUpDate,
    this.isRead = false,
  });
}

class ClinicVisit {
  final String id;
  final DateTime visitDate;
  final String reason;
  final String treatmentGiven;
  final String medication;
  final String notes;
  final String fileName;
  bool isRead;

  ClinicVisit({
    required this.id,
    required this.visitDate,
    required this.reason,
    required this.treatmentGiven,
    required this.medication,
    required this.notes,
    required this.fileName,
    this.isRead = false,
  });
}

class InBodyReport {
  final String id;
  final DateTime date;
  final double weight;
  final double bodyFat;
  final double muscleMass;
  final double bmi;
  final String fileName;

  InBodyReport({
    required this.id,
    required this.date,
    required this.weight,
    required this.bodyFat,
    required this.muscleMass,
    required this.bmi,
    required this.fileName,
  });
}

// ----------------------------- WIDGET ---------------------------------

class MedicalTab extends StatefulWidget {
  const MedicalTab({super.key});

  @override
  State<MedicalTab> createState() => _MedicalTabState();
}

class _MedicalTabState extends State<MedicalTab> {
  // Mock data – replace with API data later
  final List<PsychologistReport> _psychologistReports = [
    PsychologistReport(
      id: 'P1',
      date: DateTime.now().subtract(const Duration(days: 1)),
      doctorName: 'Dr. Sara (Psychologist)',
      comment: 'Student showed good progress. Continue the same routine.',
      fileName: 'psychology_report_1.pdf',
      isRead: false,
    ),
    PsychologistReport(
      id: 'P2',
      date: DateTime.now().subtract(const Duration(days: 10)),
      doctorName: 'Dr. Sara (Psychologist)',
      comment: 'Needs more support with stress management at home.',
      fileName: 'psychology_report_2.pdf',
      isRead: true,
    ),
  ];

  final List<PhysiotherapyVisit> _physioVisits = [
    PhysiotherapyVisit(
      id: 'F1',
      visitDate: DateTime.now().subtract(const Duration(days: 3)),
      complaint: 'Knee pain after training.',
      diagnosis: 'Mild overuse injury.',
      neededScans: 'No scans needed at the moment.',
      followUpDate: DateTime.now().add(const Duration(days: 7)),
      fileName: 'physio_visit_1.pdf',
      isRead: false,
    ),
    PhysiotherapyVisit(
      id: 'F2',
      visitDate: DateTime.now().subtract(const Duration(days: 25)),
      complaint: 'Shoulder stiffness.',
      diagnosis: 'Muscle tightness, no structural issue.',
      neededScans: 'X-ray if pain increases.',
      followUpDate: null,
      fileName: 'physio_visit_2.pdf',
      isRead: true,
    ),
  ];

  final List<ClinicVisit> _clinicVisits = [
    ClinicVisit(
      id: 'C1',
      visitDate: DateTime.now().subtract(const Duration(days: 2)),
      reason: 'Mild fever during school day.',
      treatmentGiven: 'Temperature monitored, paracetamol given.',
      medication: 'Paracetamol 250mg if fever > 38.5°C.',
      notes: 'Student picked up by parent at 1:30 PM.',
      fileName: 'clinic_visit_1.pdf',
      isRead: false,
    ),
    ClinicVisit(
      id: 'C2',
      visitDate: DateTime.now().subtract(const Duration(days: 21)),
      reason: 'Stomach ache.',
      treatmentGiven: 'Rest + water, observed for 1 lesson.',
      medication: 'No medication needed.',
      notes: 'Advised to check at home if pain continues.',
      fileName: 'clinic_visit_2.pdf',
      isRead: true,
    ),
  ];

  final List<InBodyReport> _inBodyReports = [
    InBodyReport(
      id: 'B1',
      date: DateTime.now().subtract(const Duration(days: 5)),
      weight: 35.2,
      bodyFat: 18.0,
      muscleMass: 13.4,
      bmi: 17.8,
      fileName: 'inbody_report_march.pdf',
    ),
    InBodyReport(
      id: 'B2',
      date: DateTime.now().subtract(const Duration(days: 34)),
      weight: 34.6,
      bodyFat: 18.5,
      muscleMass: 13.0,
      bmi: 17.5,
      fileName: 'inbody_report_february.pdf',
    ),
  ];

  // Weekly diet plan data (for the table)
  final List<DietDayPlan> _dietWeek = const [
    DietDayPlan(
      dayLabel: 'Sun',
      breakfast: 'Boiled egg + toast',
      lunch: 'Grilled chicken + rice',
      dinner: 'Vegetable soup',
      snack: 'Apple',
    ),
    DietDayPlan(
      dayLabel: 'Mon',
      breakfast: 'Oats with milk',
      lunch: 'Beef stew + veggies',
      dinner: 'Tuna salad',
      snack: 'Banana',
    ),
    DietDayPlan(
      dayLabel: 'Tue',
      breakfast: 'Cheese sandwich',
      lunch: 'Pasta with tomato sauce',
      dinner: 'Yogurt + fruit',
      snack: 'Carrot sticks',
    ),
    DietDayPlan(
      dayLabel: 'Wed',
      breakfast: 'Foul + bread',
      lunch: 'Fish + potatoes',
      dinner: 'Chicken salad',
      snack: 'Dates',
    ),
    DietDayPlan(
      dayLabel: 'Thu',
      breakfast: 'Milk + cereal',
      lunch: 'Kofta + rice',
      dinner: 'Vegetable omelette',
      snack: 'Orange',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color primaryBlue =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------- DOCTOR SECTION --------------------
            const SectionTitle('Doctor'),
            SizedBox(height: 10.h),

            // Psychologist
            _sectionHeader(
              icon: Icons.psychology,
              title: 'Psychologist',
              color: accentPurple,
            ),
            SizedBox(height: 6.h),
            GoldCard(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _psychologistReports.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final r = _psychologistReports[index];
                  return _psychologistItem(
                    context,
                    r,
                    primaryBlue: primaryBlue,
                    accentMint: accentMint,
                    accentSun: accentSun,
                  );
                },
              ),
            ),

            SizedBox(height: 14.h),

            // Physiotherapist
            _sectionHeader(
              icon: Icons.accessibility_new_rounded,
              title: 'Physiotherapist',
              color: accentMint,
            ),
            SizedBox(height: 6.h),
            GoldCard(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _physioVisits.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final v = _physioVisits[index];
                  return _physioItem(
                    context,
                    v,
                    primaryBlue: primaryBlue,
                    accentMint: accentMint,
                    accentSun: accentSun,
                  );
                },
              ),
            ),

            SizedBox(height: 14.h),

            // Clinic visits
            _sectionHeader(
              icon: Icons.local_hospital,
              title: 'Clinic visits',
              color: accentSky,
            ),
            SizedBox(height: 6.h),
            GoldCard(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _clinicVisits.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final c = _clinicVisits[index];
                  return _clinicItem(
                    context,
                    c,
                    primaryBlue: primaryBlue,
                    accentSky: accentSky,
                    accentSun: accentSun,
                  );
                },
              ),
            ),

            SizedBox(height: 18.h),

            // -------------------- NUTRITIONIST SECTION --------------------
            const SectionTitle('Nutritionist'),
            SizedBox(height: 10.h),

            // Body follow-up (InBody)
            _sectionHeader(
              icon: Icons.monitor_weight,
              title: 'Body follow-up',
              color: accentSun,
            ),
            SizedBox(height: 6.h),
            GoldCard(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _inBodyReports.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final r = _inBodyReports[index];
                  return _bodyFollowUpItem(
                    context,
                    r,
                    primaryBlue: primaryBlue,
                    accentMint: accentMint,
                  );
                },
              ),
            ),

            SizedBox(height: 14.h),

            // Weekly diet plan
            _sectionHeader(
              icon: Icons.restaurant_menu,
              title: 'Weekly diet plan',
              color: accentMint,
            ),
            SizedBox(height: 6.h),
            GoldCard(child: MedicalDietTable(week: _dietWeek)),

            SizedBox(height: 18.h),
          ],
        ),
      ),
    );
  }

  // ----------------------------- SMALL HELPERS ------------------------

  Widget _sectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.12),
          ),
          child: Icon(icon, size: 18.sp, color: color),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _statusChip({required bool isRead, required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999.r),
        color: isRead ? color.withOpacity(0.12) : Colors.red.withOpacity(0.10),
        border: Border.all(color: isRead ? color : Colors.redAccent, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRead ? Icons.check_circle : Icons.mark_email_unread,
            size: 14.sp,
            color: isRead ? color : Colors.redAccent,
          ),
          SizedBox(width: 4.w),
          Text(
            isRead ? 'Read' : 'Unread',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: isRead ? color : Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- ITEM BUILDERS: PSYCHOLOGIST -------------------

  Widget _psychologistItem(
    BuildContext context,
    PsychologistReport r, {
    required Color primaryBlue,
    required Color accentMint,
    required Color accentSun,
  }) {
    return InkWell(
      onTap: () => _showPsychologistDetails(context, r, primaryBlue),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Theme.of(context).colorScheme.surface.withOpacity(0.98),
          border: Border.all(
            color: (r.isRead ? accentMint : accentSun).withOpacity(0.65),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top row: date + status + download
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date: ${_formatDate(r.date)}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                    ),
                  ),
                ),
                _statusChip(isRead: r.isRead, color: accentMint),
                SizedBox(width: 6.w),
                IconButton(
                  onPressed: () => _downloadFile(context, r.fileName),
                  icon: Icon(
                    Icons.file_download,
                    size: 20.sp,
                    color: primaryBlue,
                  ),
                  tooltip: 'Download report',
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              r.doctorName,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              r.comment,
              style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(
                  context,
                ).textTheme.bodySmall?.color?.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPsychologistDetails(
    BuildContext context,
    PsychologistReport r,
    Color primaryBlue,
  ) {
    setState(() {
      r.isRead = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16.w,
            right: 16.w,
            top: 12.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999.r),
                    color: primaryBlue.withOpacity(0.3),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Psychologist report',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: primaryBlue,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Date: ${_formatDate(r.date)}',
                style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
              ),
              SizedBox(height: 6.h),
              Text(
                r.doctorName,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10.h),
              Text(r.comment, style: TextStyle(fontSize: 13.sp, height: 1.4)),
              SizedBox(height: 14.h),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _downloadFile(context, r.fileName),
                  icon: const Icon(Icons.file_download),
                  label: const Text('Download full report'),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  // -------------------- ITEM BUILDERS: PHYSIO ------------------------

  Widget _physioItem(
    BuildContext context,
    PhysiotherapyVisit v, {
    required Color primaryBlue,
    required Color accentMint,
    required Color accentSun,
  }) {
    final Color color = v.isRead ? accentMint : accentSun;

    return InkWell(
      onTap: () => _showPhysioDetails(context, v, primaryBlue),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Theme.of(context).colorScheme.surface.withOpacity(0.98),
          border: Border.all(color: color.withOpacity(0.75)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top row
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Visit: ${_formatDate(v.visitDate)}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                    ),
                  ),
                ),
                _statusChip(isRead: v.isRead, color: accentMint),
                SizedBox(width: 6.w),
                IconButton(
                  onPressed: () => _downloadFile(context, v.fileName),
                  icon: Icon(
                    Icons.file_download,
                    size: 20.sp,
                    color: primaryBlue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              'Complaint: ${v.complaint}',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Text(
              'Diagnosis: ${v.diagnosis}',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (v.neededScans.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Text(
                'Needed scans: ${v.neededScans}',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (v.followUpDate != null) ...[
              SizedBox(height: 2.h),
              Text(
                'Follow-up: ${_formatDate(v.followUpDate!)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPhysioDetails(
    BuildContext context,
    PhysiotherapyVisit v,
    Color primaryBlue,
  ) {
    setState(() {
      v.isRead = true;
    });

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Text(
              'Physiotherapy visit',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: primaryBlue,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailRow('Visit date', _formatDate(v.visitDate)),
                  _detailRow('Complaint', v.complaint),
                  _detailRow('Diagnosis', v.diagnosis),
                  _detailRow('Needed scans', v.neededScans),
                  if (v.followUpDate != null)
                    _detailRow('Follow-up', _formatDate(v.followUpDate!)),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => _downloadFile(context, v.fileName),
                child: const Text('Download report'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  // -------------------- ITEM BUILDERS: CLINIC ------------------------

  Widget _clinicItem(
    BuildContext context,
    ClinicVisit c, {
    required Color primaryBlue,
    required Color accentSky,
    required Color accentSun,
  }) {
    final Color color = c.isRead ? accentSky : accentSun;

    return InkWell(
      onTap: () => _showClinicDetails(context, c, primaryBlue),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Theme.of(context).colorScheme.surface.withOpacity(0.98),
          border: Border.all(color: color.withOpacity(0.75)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top row
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Visit: ${_formatDate(c.visitDate)}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                    ),
                  ),
                ),
                _statusChip(isRead: c.isRead, color: accentSky),
                SizedBox(width: 6.w),
                IconButton(
                  onPressed: () => _downloadFile(context, c.fileName),
                  icon: Icon(
                    Icons.file_download,
                    size: 20.sp,
                    color: primaryBlue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              'Reason: ${c.reason}',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 2.h),
            Text(
              'Treatment: ${c.treatmentGiven}',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Text(
              'Medication: ${c.medication}',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Text(
              'Notes: ${c.notes}',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showClinicDetails(
    BuildContext context,
    ClinicVisit c,
    Color primaryBlue,
  ) {
    setState(() {
      c.isRead = true;
    });

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Text(
              'Clinic visit',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: primaryBlue,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailRow('Date', _formatDate(c.visitDate)),
                  _detailRow('Reason', c.reason),
                  _detailRow('Treatment', c.treatmentGiven),
                  _detailRow('Medication', c.medication),
                  _detailRow('Notes', c.notes),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => _downloadFile(context, c.fileName),
                child: const Text('Download report'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  // -------------------- BODY FOLLOW-UP (INBODY) ----------------------

  Widget _bodyFollowUpItem(
    BuildContext context,
    InBodyReport r, {
    required Color primaryBlue,
    required Color accentMint,
  }) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.98),
        border: Border.all(color: accentMint.withOpacity(0.75)),
      ),
      child: Row(
        children: [
          // left: short stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(r.date),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: primaryBlue,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Weight: ${r.weight.toStringAsFixed(1)} kg',
                  style: TextStyle(fontSize: 12.sp),
                ),
                Text(
                  'Body fat: ${r.bodyFat.toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 12.sp),
                ),
                Text(
                  'Muscle: ${r.muscleMass.toStringAsFixed(1)} kg',
                  style: TextStyle(fontSize: 12.sp),
                ),
                Text(
                  'BMI: ${r.bmi.toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 12.sp),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          TextButton.icon(
            onPressed: () => _downloadFile(context, r.fileName),
            icon: const Icon(Icons.file_download),
            label: const Text('Report'),
          ),
        ],
      ),
    );
  }

  // -------------------- COMMON HELPERS -------------------------------

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _downloadFile(BuildContext context, String fileName) {
    // Placeholder – integrate with real download/preview later
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading $fileName...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

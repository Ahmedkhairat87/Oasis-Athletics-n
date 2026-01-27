import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/model/stdLinks/medicalFormData/Medications.dart';
import '../medical_form_helpers.dart';
import '../medical_form_state.dart';


class MedicalFormMedicationsSection extends StatelessWidget {
  final MedicalFormState state;
  const MedicalFormMedicationsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader('5. Current Medications'),
        sectionCard(
          context,
          state.isEditing
              ? _MedicationEditTable(state: state)
              : _MedicationViewList(state: state),
        ),
      ],
    );
  }
}

class _MedicationViewList extends StatelessWidget {
  final MedicalFormState state;
  const _MedicationViewList({required this.state});

  @override
  Widget build(BuildContext context) {
    final meds = state.medicationModels;

    if (meds.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(8.w),
        child: Text(
          'No medications recorded.',
          style: TextStyle(fontSize: 13.sp),
        ),
      );
    }

    return Column(
      children: meds.map((m) {
        final title = (m.medicationName ?? '').trim().isNotEmpty
            ? m.medicationName!.trim()
            : 'Medication';

        final dosage = (m.dosage ?? '').trim().isNotEmpty ? m.dosage!.trim() : '-';
        final freq = (m.frequency ?? '').trim().isNotEmpty ? m.frequency!.trim() : '-';

        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.black.withOpacity(0.06)),
          ),
          child: ListTile(
            title: Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            subtitle: Text(
              'Dosage: $dosage\nFrequency: $freq',
              style: TextStyle(fontSize: 12.sp),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showMedicationDetails(context, m),
          ),
        );
      }).toList(),
    );
  }

  void _showMedicationDetails(BuildContext context, Medications m) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // important for full-width look
      builder: (_) {
        String v(String? x) => (x ?? '').trim().isEmpty ? '-' : x!.trim();

        return SafeArea(
          child: Container(
            width: double.infinity, // ✅ full width
            margin: EdgeInsets.zero,
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 16.h,
              bottom: 16.h + MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Medication Details',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  _row('Medication', v(m.medicationName)),
                  _row('Dosage', v(m.dosage)),
                  _row('Frequency', v(m.frequency)),
                  SizedBox(height: 12.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        '$label: $value',
        style: TextStyle(fontSize: 13.sp),
      ),
    );
  }
}

class _MedicationEditTable extends StatelessWidget {
  final MedicalFormState state;
  const _MedicationEditTable({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        smallHint('Add medications the child is taking (Medication / Dosage / Frequency)'),
        SizedBox(height: 10.h),

        // Header row (like the web design)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.black.withOpacity(0.06)),
          ),
          child: Row(
            children: [
              Expanded(flex: 4, child: Text('Medication', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp))),
              SizedBox(width: 8.w),
              Expanded(flex: 3, child: Text('Dosage', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp))),
              SizedBox(width: 8.w),
              Expanded(flex: 3, child: Text('Frequency', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp))),
              SizedBox(width: 8.w),
              SizedBox(width: 34.w), // delete icon space
            ],
          ),
        ),

        SizedBox(height: 10.h),

        for (int i = 0; i < state.medications.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    controller: state.medications[i]['name'],
                    decoration: medicalInputDecoration(context, 'Medication'),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: state.medications[i]['dosage'],
                    decoration: medicalInputDecoration(context, 'Dosage'),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: state.medications[i]['freq'],
                    decoration: medicalInputDecoration(context, 'Frequency'),
                  ),
                ),
                SizedBox(width: 8.w),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: state.medications.length > 1
                      ? () => state.removeMedicationRow(i)
                      : null,
                ),
              ],
            ),
          ),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add medication'),
            onPressed: state.addMedicationRow,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


import 'medical_form_helpers.dart';
import 'medical_form_state.dart';

class MedicalFormBodyPart2 extends StatelessWidget {
  final MedicalFormState state;

  const MedicalFormBodyPart2({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 6. Immunization Record
        sectionHeader('6. Immunization Record'),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                InkWell(
                  onTap: state.isEditing
                      ? () => state.pickDate(
                    context,
                        (d) => state.lastImmunizationDate = d,
                    initial: state.lastImmunizationDate,
                  )
                      : null,
                  child: InputDecorator(
                    decoration: medicalInputDecoration(
                        context, 'Date of Last Immunization'),
                    child: Text(
                      state.lastImmunizationDate != null
                          ? DateFormat.yMMMd()
                          .format(state.lastImmunizationDate!)
                          : 'Select date',
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.vaccinesReceivedController,
                  decoration: medicalInputDecoration(
                      context, 'Vaccines Received'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),

        /// 7. Vision & Hearing
        sectionHeader('7. Vision & Hearing'),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                TextFormField(
                  controller: state.visionProblemsController,
                  decoration:
                  medicalInputDecoration(context, 'Vision Problems'),
                ),
                SizedBox(height: 8.h),
                _dateAndToggleRow(
                  context,
                  label: 'Last Eye Exam Date',
                  date: state.lastEyeExam,
                  onPick: (d) => state.lastEyeExam = d,
                  no: state.visionProblemNo,
                  yes: state.visionProblemYes,
                  onToggle: (idx) => state.toggleVision(idx),
                  enabled: state.isEditing,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.hearingProblemsController,
                  decoration:
                  medicalInputDecoration(context, 'Hearing Problems'),
                ),
                SizedBox(height: 8.h),
                _dateAndToggleRow(
                  context,
                  label: 'Last Hearing Test Date',
                  date: state.lastHearingTest,
                  onPick: (d) => state.lastHearingTest = d,
                  no: state.hearingProblemNo,
                  yes: state.hearingProblemYes,
                  onToggle: (idx) => state.toggleHearing(idx),
                  enabled: state.isEditing,
                ),
              ],
            ),
          ),
        ),

        /// 8. Physical Activity & Sports
        sectionHeader('8. Physical Activity & Sports'),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                TextFormField(
                  controller: state.activityLimitationsController,
                  decoration: medicalInputDecoration(
                      context, 'Limitations on Physical Activity'),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.sportsParticipationController,
                  decoration: medicalInputDecoration(
                      context, 'Sports Participation (limitations)'),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.specialEquipmentController,
                  decoration: medicalInputDecoration(
                      context, 'Special Equipment Needed'),
                ),
              ],
            ),
          ),
        ),

        /// 9. Mental & Behavioral Health
        sectionHeader('9. Mental & Behavioral Health'),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                TextFormField(
                  controller: state.mentalHistoryController,
                  decoration:
                  medicalInputDecoration(context, 'Mental Health History'),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.diagnosedConditionsController,
                  decoration:
                  medicalInputDecoration(context, 'Diagnosed Conditions'),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.therapyMedicationController,
                  decoration:
                  medicalInputDecoration(context, 'Medication or Therapy'),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.behavioralConcernsController,
                  decoration:
                  medicalInputDecoration(context, 'Behavioral Concerns'),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.supportNeededController,
                  decoration:
                  medicalInputDecoration(context, 'Support Needed'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateAndToggleRow(
      BuildContext context, {
        required String label,
        required DateTime? date,
        required ValueChanged<DateTime?> onPick,
        required bool no,
        required bool yes,
        required ValueChanged<int> onToggle,
        required bool enabled,
      }) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: enabled
                ? () => state.pickDate(context, onPick, initial: date)
                : null,
            child: InputDecorator(
              decoration: medicalInputDecoration(context, label),
              child: Text(
                date != null ? DateFormat.yMMMd().format(date) : 'dd/mm/yyyy',
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        ToggleButtons(
          isSelected: [no, yes],
          onPressed: enabled ? onToggle : null,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('No'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('Yes'),
            ),
          ],
        ),
      ],
    );
  }
}
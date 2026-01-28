import 'package:easy_localization/easy_localization.dart';
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
        sectionHeader('immunization_record'.tr()),
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
                        context, 'last_immunization'.tr()),
                    child: Text(
                      state.lastImmunizationDate != null
                          ? DateFormat.yMMMd()
                          .format(state.lastImmunizationDate!)
                          : 'select_date'.tr(),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.vaccinesReceivedController,
                  decoration: medicalInputDecoration(
                      context, 'vaccines_received'.tr()),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),

        /// 7. Vision & Hearing
        /// 7. Vision & Hearing
        sectionHeader('vision_hearing'.tr()),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                TextFormField(
                  controller: state.visionProblemsController,
                  decoration: medicalInputDecoration(context, 'vision_problems'.tr()),
                ),
                SizedBox(height: 8.h),
                _dateAndToggleRow(
                  context,
                  label: 'last_eye_exam'.tr(),
                  date: state.lastEyeExam,
                  onPick: (d) => state.lastEyeExam = d,
                  no: state.visionProblemNo,
                  yes: state.visionProblemYes,
                  onToggle: state.toggleVision,
                  enabled: state.isEditing,
                ),
                SizedBox(height: 12.h),

                _dateAndToggleRow(
                  context,
                  label: 'last_hearing_test'.tr(),
                  date: state.lastHearingTest,
                  onPick: (d) => state.lastHearingTest = d,
                  no: state.hearingProblemNo,
                  yes: state.hearingProblemYes,
                  onToggle: state.toggleHearing,
                  enabled: state.isEditing,
                ),
              ],
            ),
          ),
        ),

        /// 8. Physical Activity & Sports
        sectionHeader('physical_activity'.tr()),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                TextFormField(
                  controller: state.activityLimitationsController,
                  decoration: medicalInputDecoration(
                      context, 'activity_limitations'.tr()),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.sportsParticipationController,
                  decoration: medicalInputDecoration(
                      context, 'sports_participation'.tr()),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.specialEquipmentController,
                  decoration: medicalInputDecoration(
                      context, 'special_equipment'.tr()),
                ),
              ],
            ),
          ),
        ),

        /// 9. Mental & Behavioral Health
        sectionHeader('mental_behavioral'.tr()),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                TextFormField(
                  controller: state.mentalHistoryController,
                  decoration:
                  medicalInputDecoration(context, 'mental_history'.tr()),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.diagnosedConditionsController,
                  decoration:
                  medicalInputDecoration(context, 'diagnosed_conditions'.tr()),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.therapyMedicationController,
                  decoration:
                  medicalInputDecoration(context, 'therapy_medication'.tr()),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.behavioralConcernsController,
                  decoration:
                  medicalInputDecoration(context, 'behavioral_concerns'.tr()),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.supportNeededController,
                  decoration:
                  medicalInputDecoration(context, 'support_needed'.tr()),
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
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('no'.tr()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('yes'.tr()),
            ),
          ],
        ),
      ],
    );
  }
}
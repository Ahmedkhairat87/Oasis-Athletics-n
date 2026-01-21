import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/medical_constants.dart';

import 'medical_form_helpers.dart';
import 'medical_form_state.dart';

class MedicalFormBodyPart3 extends StatelessWidget {
  final MedicalFormState state;

  const MedicalFormBodyPart3({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 10. Dietary Restrictions
        sectionHeader('10. Dietary Restrictions'),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                TextFormField(
                  controller: state.specialDietController,
                  decoration: medicalInputDecoration(
                      context, 'Any Special Diet / Nutritional Needs'),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.foodAllergiesController,
                  decoration: medicalInputDecoration(
                      context, 'Food Allergies or Sensitivities'),
                ),
              ],
            ),
          ),
        ),

        /// 11. Past Injuries
        sectionHeader('11. Past Injuries'),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('No'),
                      selected: state.pastInjuryNone,
                      onSelected: state.isEditing
                          ? (_) => state.togglePastInjuryNone()
                          : null,
                    ),
                    SizedBox(width: 8.w),
                    ChoiceChip(
                      label: const Text('Yes'),
                      selected: state.pastInjuryYes,
                      onSelected: state.isEditing
                          ? (_) => state.togglePastInjuryYes()
                          : null,
                    ),
                  ],
                ),
                if (state.pastInjuryYes) ...[
                  SizedBox(height: 8.h),
                  Column(
                    children: MedicalConstants.pastInjuryTypes
                        .map(
                          (k) => CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(k),
                        value: state.pastInjuries[k],
                        onChanged: state.isEditing
                            ? (v) =>
                            state.setPastInjury(k, v ?? false)
                            : null,
                      ),
                    )
                        .toList(),
                  ),
                  TextFormField(
                    controller: state.pastInjuriesOtherController,
                    decoration:
                    medicalInputDecoration(context, 'If other'),
                  ),
                ],
              ],
            ),
          ),
        ),

        /// 12. Surgeries
        sectionHeader('12. Surgeries'),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('No'),
                      selected: state.surgeriesNone,
                      onSelected: state.isEditing
                          ? (_) => state.toggleSurgeryNone()
                          : null,
                    ),
                    SizedBox(width: 8.w),
                    ChoiceChip(
                      label: const Text('Yes'),
                      selected: state.surgeriesYes,
                      onSelected: state.isEditing
                          ? (_) => state.toggleSurgeryYes()
                          : null,
                    ),
                  ],
                ),
                if (state.surgeriesYes) ...[
                  SizedBox(height: 8.h),
                  Column(
                    children: MedicalConstants.surgeryTypes
                        .map(
                          (k) => CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(k),
                        value: state.surgeries[k],
                        onChanged: state.isEditing
                            ? (v) =>
                            state.setSurgery(k, v ?? false)
                            : null,
                      ),
                    )
                        .toList(),
                  ),
                  TextFormField(
                    controller: state.surgeriesOtherController,
                    decoration:
                    medicalInputDecoration(context, 'If other'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
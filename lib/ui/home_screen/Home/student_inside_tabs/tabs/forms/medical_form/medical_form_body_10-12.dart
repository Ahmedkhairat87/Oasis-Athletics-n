import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/medical_constants.dart';
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
        sectionHeader('dietary_restrictions'.tr()),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                TextFormField(
                  controller: state.specialDietController,
                  decoration: medicalInputDecoration(
                      context, 'special_diet'.tr()),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.foodAllergiesController,
                  decoration: medicalInputDecoration(
                      context, 'food_allergies'.tr()),
                ),
              ],
            ),
          ),
        ),

        /// 11. Past Injuries
        sectionHeader('past_injuries'.tr()),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                Row(
                  children: [
                    ChoiceChip(
                      label: Text('no'.tr()),
                      selected: state.pastInjuryNone,
                      onSelected: state.isEditing
                          ? (_) => state.togglePastInjuryNone()
                          : null,
                    ),
                    SizedBox(width: 8.w),
                    ChoiceChip(
                      label: Text('yes'.tr()),
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
                    medicalInputDecoration(context, 'if_other'.tr()),
                  ),
                ],
              ],
            ),
          ),
        ),

        /// 12. Surgeries
        sectionHeader('surgeries'.tr()),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                Row(
                  children: [
                    ChoiceChip(
                      label: Text('no'.tr()),
                      selected: state.surgeriesNone,
                      onSelected: state.isEditing
                          ? (_) => state.toggleSurgeryNone()
                          : null,
                    ),
                    SizedBox(width: 8.w),
                    ChoiceChip(
                      label: Text('yes'.tr()),
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
                    medicalInputDecoration(context, 'if_other'.tr()),
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
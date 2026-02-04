import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'helpersFiles/medical_form_medications_section.dart';
import 'helpersFiles/medical_form_preview_field.dart';
import 'medical_form_helpers.dart';
import 'medical_form_state.dart';

class MedicalFormBodyPart1 extends StatelessWidget {
  final MedicalFormState state;

  const MedicalFormBodyPart1({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 2. Chronic Conditions
        sectionHeader('chronic_conditions'.tr()),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                TextFormField(
                  controller: state.chronicConditionsController,
                  decoration: medicalInputDecoration(context, 'conditions'.tr()),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.chronicTreatmentController,
                  decoration: medicalInputDecoration(
                      context, 'treatment_plan'.tr()),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.chronicEmergencyController,
                  decoration: medicalInputDecoration(
                      context, 'emergency_protocols'.tr()),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),

        /// 3. Past Surgeries / Procedures
        sectionHeader('past_surgeries'.tr()),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                TextFormField(
                  controller: state.pastSurgeryController,
                  decoration: medicalInputDecoration(
                      context, 'surgery_type_date'.tr()),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.hospitalizationReasonController,
                  decoration: medicalInputDecoration(
                      context, 'hospitalization_reason'.tr()),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.hospitalizationDatesController,
                  decoration: medicalInputDecoration(context, 'dates'.tr()),
                ),
              ],
            ),
          ),
        ),

        /// 4. Family Medical History
        sectionHeader('family_history'.tr()),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            TextFormField(
              controller: state.familyHistoryController,
              decoration: medicalInputDecoration(
                  context, 'family_medical_history'.tr()),
              maxLines: 3,
            ),
          ),
        ),
        /// 5. Current Medications
        MedicalFormMedicationsSection(state: state),
      ],
    );
  }
}
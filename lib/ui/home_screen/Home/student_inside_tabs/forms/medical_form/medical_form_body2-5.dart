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
        sectionHeader('2. Chronic Conditions'),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                TextFormField(
                  controller: state.chronicConditionsController,
                  decoration: medicalInputDecoration(context, 'Condition(s)'),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.chronicTreatmentController,
                  decoration: medicalInputDecoration(
                      context, 'Treatment / Management Plan'),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.chronicEmergencyController,
                  decoration: medicalInputDecoration(
                      context, 'Emergency Protocols (if any)'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),

        /// 3. Past Surgeries / Procedures
        sectionHeader('3. Past Surgeries / Procedures'),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                TextFormField(
                  controller: state.pastSurgeryController,
                  decoration: medicalInputDecoration(
                      context, 'Surgery Type & Date'),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.hospitalizationReasonController,
                  decoration: medicalInputDecoration(
                      context, 'Reason for Hospitalization'),
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: state.hospitalizationDatesController,
                  decoration: medicalInputDecoration(context, 'Date(s)'),
                ),
              ],
            ),
          ),
        ),

        /// 4. Family Medical History
        sectionHeader('4. Family Medical History'),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            TextFormField(
              controller: state.familyHistoryController,
              decoration: medicalInputDecoration(
                  context, 'Relevant Family Medical History'),
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
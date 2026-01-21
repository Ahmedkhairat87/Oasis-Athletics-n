import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
        sectionHeader('5. Current Medications'),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              children: [
                smallHint(
                  'Add medications the child is taking (Medication / Dosage / Frequency)',
                ),
                for (int i = 0; i < state.medications.length; i++)
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            controller: state.medications[i]['name'],
                            decoration: medicalInputDecoration(
                                context, 'Medication'),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: state.medications[i]['dosage'],
                            decoration:
                            medicalInputDecoration(context, 'Dosage'),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: state.medications[i]['freq'],
                            decoration:
                            medicalInputDecoration(context, 'Frequency'),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: state.isEditing &&
                              state.medications.length > 1
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
                    onPressed:
                    state.isEditing ? state.addMedicationRow : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
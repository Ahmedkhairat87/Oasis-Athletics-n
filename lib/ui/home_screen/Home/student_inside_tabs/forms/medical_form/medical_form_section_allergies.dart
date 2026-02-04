import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'medical_form_helpers.dart';
import 'medical_form_state.dart';


class MedicalFormAllergiesSection extends StatelessWidget {
  final MedicalFormState state;

  const MedicalFormAllergiesSection({super.key, required this.state});

  static const List<String> severityOptions = [
    'Mild',
    'Moderate',
    'Severe',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader('1. Allergies'),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Does the child have allergies?',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ChoiceChip(
                      label: const Text('No'),
                      selected: !state.hasAllergies,
                      onSelected: state.isEditing
                          ? (_) => state.setHasAllergies(false)
                          : null,
                    ),
                    SizedBox(width: 8.w),
                    ChoiceChip(
                      label: const Text('Yes'),
                      selected: state.hasAllergies,
                      onSelected: state.isEditing
                          ? (_) => state.setHasAllergies(true)
                          : null,
                    ),
                  ],
                ),

                if (state.hasAllergies) ...[
                  SizedBox(height: 10.h),

                  TextFormField(
                    controller: state.typeOfAllergyController,
                    decoration: medicalInputDecoration(context, 'Type of Allergy'),
                  ),
                  SizedBox(height: 8.h),

                  DropdownButtonFormField<String>(
                    value: state.allergySeverity,
                    items: severityOptions
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: state.isEditing ? state.setAllergySeverity : null,
                    decoration: medicalInputDecoration(context, 'Severity'),
                  ),
                  SizedBox(height: 8.h),

                  TextFormField(
                    controller: state.specificTreatmentController,
                    decoration: medicalInputDecoration(
                      context,
                      'Specific Treatment or Medication',
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: 8.h),

                  TextFormField(
                    controller: state.otherAllergyController,
                    decoration: medicalInputDecoration(context, 'If other (describe)'),
                    maxLines: 2,
                  ),

                  SizedBox(height: 14.h),
                  Text(
                    'Please check if your child suffers from one or more of the following conditions. '
                        'If so, please provide details below.',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8.h),

                  Column(
                    children: state.knownAllergies.keys.map((k) {
                      return CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(k),
                        value: state.knownAllergies[k] ?? false,
                        onChanged: state.isEditing
                            ? (v) => state.toggleKnownAllergy(k, v ?? false)
                            : null,
                      );
                    }).toList(),
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
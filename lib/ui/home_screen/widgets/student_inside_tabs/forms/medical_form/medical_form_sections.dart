import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/colors_Manager.dart';
import '../../../../../../core/medical_constants.dart';


import 'medical_form_helpers.dart';
import 'medical_form_state.dart';

class MedicalFormSections extends StatelessWidget {
  final MedicalFormState state;

  const MedicalFormSections({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// BLOOD GROUP
        sectionHeader('Blood Group'),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: MedicalConstants.bloodGroups.map((g) {
                final selected = state.bloodGroup == g;
                return ChoiceChip(
                  label: Text(
                    g,
                    style: TextStyle(
                        color: selected ? Colors.white : Colors.black),
                  ),
                  selected: selected,
                  selectedColor: ColorsManager.accentMint,
                  onSelected: state.isEditing
                      ? (_) => state.setBloodGroup(g)
                      : null,
                );
              }).toList(),
            ),
          ),
        ),

        /// ALLERGIES
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
                      selectedColor: ColorsManager.accentCoral,
                      onSelected: state.isEditing
                          ? (_) => state.setHasAllergies(true)
                          : null,
                    ),
                  ],
                ),

                if (state.hasAllergies) ...[
                  SizedBox(height: 8.h),
                  Text(
                    'Known Allergies (select any):',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Column(
                    children: state.knownAllergies.keys.map((k) {
                      return CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(k),
                        value: state.knownAllergies[k],
                        onChanged: state.isEditing
                            ? (v) => state.toggleKnownAllergy(k, v ?? false)
                            : null,
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    controller: state.typeOfAllergyController,
                    decoration:
                    medicalInputDecoration(context, 'Type of Allergy'),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: state.severityController,
                    decoration:
                    medicalInputDecoration(context, 'Severity'),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: state.specificTreatmentController,
                    decoration: medicalInputDecoration(
                        context, 'Specific Treatment or Medication'),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: state.otherAllergyController,
                    decoration: medicalInputDecoration(
                        context, 'If other (describe)'),
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
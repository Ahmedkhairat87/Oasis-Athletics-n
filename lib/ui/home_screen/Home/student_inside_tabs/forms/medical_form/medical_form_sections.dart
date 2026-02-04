import 'package:easy_localization/easy_localization.dart';
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
    final groups = (state.bloodOptions.isNotEmpty
        ? state.bloodOptions
        : MedicalConstants.bloodGroups)
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// BLOOD GROUP
        sectionHeader('blood_group'.tr()),
        editableWrapper(
          state.isEditing,
          sectionCard(
            context,
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: groups.map((g) {
                final selected = state.bloodGroup == g;
                return ChoiceChip(
                  label: Text(
                    g,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: selected,
                  selectedColor: ColorsManager.accentMint,
                  onSelected: state.isEditing ? (_) => state.setBloodGroup(g) : null,
                );
              }).toList(),
            ),
          ),
        ),

      ],
    );
  }
}
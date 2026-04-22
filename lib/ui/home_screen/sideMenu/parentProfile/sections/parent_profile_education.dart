import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/model/sideMenu/parentProfile/parentLanguage/ParentLanguage.dart';
import '../parentProfile/parent_profile_helpers.dart';
import '../parentProfile/parent_profile_state.dart';
import '../parentProfile/parent_profile_cards.dart';

class ParentProfileSectionEducation extends StatelessWidget {
  final ParentProfileState state;
  const ParentProfileSectionEducation({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ParentProfileCard(
          child: Column(
            children: [
              SectionTitle("father_info".tr()),
              EditableField(
                label: "school".tr(),
                controller: state.fatherSchoolCtrl,
                editMode: state.editMode,
              ),
              EditableField(
                label: "diploma".tr(),
                controller: state.fatherDiplomeCtrl,
                editMode: state.editMode,
              ),
              ProfileDropdown<ParentLanguage>(
                label: "mother_tongue".tr(),
                value: state.fatherLang1,
                items: state.parentLanguages,
                enabled: state.editMode,
                itemLabel: (e) => e.parentlang ?? '',
                onChanged: (val) {
                  state.fatherLang1 = val;
                  state.dirtySections.add(ProfileSection.education);
                  state.notifyListeners();
                },
              ),
              ProfileDropdown<ParentLanguage>(
                label: "second_language".tr(),
                value: state.fatherLang2,
                items: state.parentLanguages,
                enabled: state.editMode,
                itemLabel: (e) => e.parentlang ?? '',
                onChanged: (val) {
                  state.fatherLang2 = val;
                  state.dirtySections.add(ProfileSection.education);
                  state.notifyListeners();
                },
              ),
              ProfileDropdown<ParentLanguage>(
                label: "third_language".tr(),
                value: state.fatherLang3,
                items: state.parentLanguages,
                enabled: state.editMode,
                itemLabel: (e) => e.parentlang ?? '',
                onChanged: (val) {
                  state.fatherLang3 = val;
                  state.dirtySections.add(ProfileSection.education);
                  state.notifyListeners();
                },
              ),
              EditableField(
                label: "other_language".tr(),
                controller: state.fatherOtherLangCtrl,
                editMode: state.editMode,
              ),
            ],
          ),
        ),
        ParentProfileCard(
          child: Column(
            children: [
              SectionTitle("mother_info".tr()),
              EditableField(
                label: "school".tr(),
                controller: state.motherSchoolCtrl,
                editMode: state.editMode,
              ),
              EditableField(
                label: "diploma".tr(),
                controller: state.motherDiplomeCtrl,
                editMode: state.editMode,
              ),
              ProfileDropdown<ParentLanguage>(
                label: "mother_tongue".tr(),
                value: state.motherLang1,
                items: state.parentLanguages,
                enabled: state.editMode,
                itemLabel: (e) => e.parentlang ?? '',
                onChanged: (val) {
                  state.motherLang1 = val;
                  state.dirtySections.add(ProfileSection.education);
                  state.notifyListeners();
                },
              ),
              ProfileDropdown<ParentLanguage>(
                label: "second_language".tr(),
                value: state.motherLang2,
                items: state.parentLanguages,
                enabled: state.editMode,
                itemLabel: (e) => e.parentlang ?? '',
                onChanged: (val) {
                  state.motherLang2 = val;
                  state.dirtySections.add(ProfileSection.education);
                  state.notifyListeners();
                },
              ),
              ProfileDropdown<ParentLanguage>(
                label: "third_language".tr(),
                value: state.motherLang3,
                items: state.parentLanguages,
                enabled: state.editMode,
                itemLabel: (e) => e.parentlang ?? '',
                onChanged: (val) {
                  state.motherLang3 = val;
                  state.dirtySections.add(ProfileSection.education);
                  state.notifyListeners();
                },
              ),
              EditableField(
                label: "other_language".tr(),
                controller: state.motherOtherLangCtrl,
                editMode: state.editMode,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
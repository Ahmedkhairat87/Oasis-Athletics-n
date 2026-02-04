

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../parentProfile/parent_profile_helpers.dart';
import '../parentProfile/parent_profile_state.dart';

class ParentProfileSectionContact extends StatelessWidget {
  final ParentProfileState state;
  const ParentProfileSectionContact({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle("father_info".tr()),
        EditableField(
          label: "email".tr(),
          controller: state.fatherEmailCtrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "home_tel".tr(),
          controller: state.fatherHomeTelCtrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "cell_phone".tr(),
          controller: state.fatherMobileCtrl,
          editMode: state.editMode,
        ),

        SectionTitle("mother_info".tr()),
        EditableField(
          label: "email".tr(),
          controller: state.motherEmailCtrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "home_tel".tr(),
          controller: state.motherHomeTelCtrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "cell_phone".tr(),
          controller: state.motherMobileCtrl,
          editMode: state.editMode,
        ),

        SectionTitle("responsable_info".tr()),
        EditableField(
          label: "email".tr(),
          controller: state.contactEmailCtrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "cell_phone".tr(),
          controller: state.contactMobileCtrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "password".tr(),
          controller: state.parentPasswordCtrl,
          editMode: state.editMode,
        ),
      ],
    );
  }
}
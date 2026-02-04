import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../parentProfile/parent_profile_helpers.dart';
import '../parentProfile/parent_profile_state.dart';


class ParentProfileSectionEmergency extends StatelessWidget {
  final ParentProfileState state;
  const ParentProfileSectionEmergency({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle("first_person".tr()),
        EditableField(
          label: "name".tr(),
          controller: state.urgentName1Ctrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "relation".tr(),
          controller: state.urgentRelation1Ctrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "home_tel".tr(),
          controller: state.urgentTel1Ctrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "cell_phone".tr(),
          controller: state.urgentMobile1Ctrl,
          editMode: state.editMode,
        ),

        SectionTitle("second_person".tr()),
        EditableField(
          label: "name".tr(),
          controller: state.urgentName2Ctrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "relation".tr(),
          controller: state.urgentRelation2Ctrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "home_tel".tr(),
          controller: state.urgentTel2Ctrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "cell_phone".tr(),
          controller: state.urgentMobile2Ctrl,
          editMode: state.editMode,
        ),

        SectionTitle("third_person".tr()),
        EditableField(
          label: "name".tr(),
          controller: state.urgentName3Ctrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "relation".tr(),
          controller: state.urgentRelation3Ctrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "home_tel".tr(),
          controller: state.urgentTel3Ctrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "cell_phone".tr(),
          controller: state.urgentMobile3Ctrl,
          editMode: state.editMode,
        ),
      ],
    );
  }
}
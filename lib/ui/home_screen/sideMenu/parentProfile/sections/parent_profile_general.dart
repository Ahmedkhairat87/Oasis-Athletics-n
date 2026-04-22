import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../parentProfile/parent_profile_helpers.dart';
import '../parentProfile/parent_profile_state.dart';
import '../parentProfile/parent_profile_cards.dart';

class ParentProfileSectionGeneral extends StatelessWidget {
  final ParentProfileState state;
  const ParentProfileSectionGeneral({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ParentProfileCard(
          child: Column(
            children: [
              SectionTitle("father_info".tr()),
              EditableField(
                label: "father_name".tr(),
                controller: state.fatherNameCtrl,
                editMode: state.editMode,
                canEdit: false,
              ),
              EditableField(
                label: "tutor_name".tr(),
                controller: state.fatherTutorCtrl,
                editMode: state.editMode,
              ),
              EditableField(
                label: "private_address".tr(),
                controller: state.fatherAddressCtrl,
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
                label: "mother_name".tr(),
                controller: state.motherNameCtrl,
                editMode: state.editMode,
                canEdit: false,
              ),
              EditableField(
                label: "tutor_name".tr(),
                controller: state.motherTutorCtrl,
                editMode: state.editMode,
              ),
              EditableField(
                label: "private_address".tr(),
                controller: state.motherAddressCtrl,
                editMode: state.editMode,
              ),
              ProfileDropdown(
                label: 'Family Situation'.tr(),
                value: state.selectedParentStatus,
                items: state.parentStatuses,
                enabled: state.editMode,
                itemLabel: (e) => e.parentstatusEn ?? e.parentstatus ?? '',
                onChanged: (val) {
                  state.selectedParentStatus = val;
                  state.dirtySections.add(ProfileSection.general);
                  state.notifyListeners();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/model/sideMenu/parentProfile/jobDomain/jobDomain.dart';
import '../parentProfile/parent_profile_helpers.dart';
import '../parentProfile/parent_profile_state.dart';

class ParentProfileSectionWork extends StatelessWidget {
  final ParentProfileState state;
  const ParentProfileSectionWork({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle("father_info".tr()),
        ProfileDropdown<jobDomain>(
          label: "area_of_work".tr(),
          value: state.selectedFatherDomain,
          items: state.jobDomains,
          enabled: state.editMode,
          itemLabel: (d) => d.jobdomainEn ?? d.jobdomain ?? '',
          onChanged: (val) {
            state.selectedFatherDomain = val;
            state.dirtySections.add(ProfileSection.work);
            state.notifyListeners();
          },
        ),
        EditableField(
          label: "profession".tr(),
          controller: state.fatherProfessionCtrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "company_name".tr(),
          controller: state.fatherCompanyCtrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "workplace".tr(),
          controller: state.fatherWorkplaceCtrl,
          editMode: state.editMode,
        ),

        SectionTitle("mother_info".tr()),
        ProfileDropdown<jobDomain>(
          label: "area_of_work".tr(),
          value: state.selectedMotherDomain,
          items: state.jobDomains,
          enabled: state.editMode,
          itemLabel: (d) => d.jobdomainEn ?? d.jobdomain ?? '',
          onChanged: (val) {
            state.selectedMotherDomain = val;
            state.dirtySections.add(ProfileSection.work);
            state.notifyListeners();
          },
        ),
        EditableField(
          label: "profession".tr(),
          controller: state.motherProfessionCtrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "company_name".tr(),
          controller: state.motherCompanyCtrl,
          editMode: state.editMode,
        ),
        EditableField(
          label: "workplace".tr(),
          controller: state.motherWorkplaceCtrl,
          editMode: state.editMode,
        ),
      ],
    );
  }
}
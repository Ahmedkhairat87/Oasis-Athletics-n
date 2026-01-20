import 'package:flutter/material.dart';

import '../../../../core/model/sideMenu/parentProfile/jobDomain/jobDomain.dart';
import '../../../../core/model/sideMenu/parentProfile/parentLanguage/ParentLanguage.dart';
import '../../../../core/model/sideMenu/parentProfile/parentStatus/ParentStatus.dart';
import '../../../../core/model/sideMenu/parentProfile/profileMainData/parentProfileData.dart';

enum ProfileSection { general, contact, work, education, emergency }

class ParentProfileState {
  /// SECTION DIRTY TRACKING
  final Set<ProfileSection> dirtySections = {};

  /// PROFILE MODEL
  parentProfileData? profile;

  /// ===== JOB DOMAINS =====
  List<jobDomain> jobDomains = [];
  jobDomain? selectedFatherDomain;
  jobDomain? selectedMotherDomain;

  /// ===== STATUS =====
  List<ParentStatus> parentStatuses = [];
  ParentStatus? selectedParentStatus;

  /// ===== LANGUAGES =====
  List<ParentLanguage> parentLanguages = [];

  ParentLanguage? fatherLang1;
  ParentLanguage? fatherLang2;
  ParentLanguage? fatherLang3;

  ParentLanguage? motherLang1;
  ParentLanguage? motherLang2;
  ParentLanguage? motherLang3;

  /// ======================= GENERAL =======================
  late TextEditingController fatherTutorCtrl;
  late TextEditingController fatherAddressCtrl;
  late TextEditingController motherTutorCtrl;
  late TextEditingController motherAddressCtrl;

  /// ======================= CONTACT =======================
  late TextEditingController fatherEmailCtrl;
  late TextEditingController fatherHomeTelCtrl;
  late TextEditingController fatherMobileCtrl;

  late TextEditingController motherEmailCtrl;
  late TextEditingController motherHomeTelCtrl;
  late TextEditingController motherMobileCtrl;

  late TextEditingController contactEmailCtrl;
  late TextEditingController contactMobileCtrl;
  late TextEditingController parentPasswordCtrl;

  /// ======================= WORK =======================
  late TextEditingController fatherProfessionCtrl;
  late TextEditingController fatherCompanyCtrl;
  late TextEditingController fatherWorkplaceCtrl;

  late TextEditingController motherProfessionCtrl;
  late TextEditingController motherCompanyCtrl;
  late TextEditingController motherWorkplaceCtrl;

  /// ======================= EDUCATION =======================
  late TextEditingController fatherSchoolCtrl;
  late TextEditingController fatherDiplomeCtrl;
  late TextEditingController fatherOtherLangCtrl;

  late TextEditingController motherSchoolCtrl;
  late TextEditingController motherDiplomeCtrl;
  late TextEditingController motherOtherLangCtrl;

  /// ======================= EMERGENCY =======================
  late TextEditingController urgentName1Ctrl;
  late TextEditingController urgentRelation1Ctrl;
  late TextEditingController urgentTel1Ctrl;
  late TextEditingController urgentMobile1Ctrl;

  late TextEditingController urgentName2Ctrl;
  late TextEditingController urgentRelation2Ctrl;
  late TextEditingController urgentTel2Ctrl;
  late TextEditingController urgentMobile2Ctrl;

  late TextEditingController urgentName3Ctrl;
  late TextEditingController urgentRelation3Ctrl;
  late TextEditingController urgentTel3Ctrl;
  late TextEditingController urgentMobile3Ctrl;

  /// INIT CONTROLLERS FROM PROFILE
  void initControllers(parentProfileData? p) {
    profile = p;

    fatherTutorCtrl = TextEditingController(text: p?.fatherTuteur ?? "");
    fatherAddressCtrl = TextEditingController(text: p?.fatherAddress ?? "");
    motherTutorCtrl = TextEditingController(text: p?.motherTuteur ?? "");
    motherAddressCtrl = TextEditingController(text: p?.motherAddress ?? "");

    fatherEmailCtrl = TextEditingController(text: p?.fatherEmail ?? "");
    fatherHomeTelCtrl = TextEditingController(text: p?.fatherHometel ?? "");
    fatherMobileCtrl = TextEditingController(text: p?.fatherMobile ?? "");

    motherEmailCtrl = TextEditingController(text: p?.motherEmail ?? "");
    motherHomeTelCtrl = TextEditingController(text: p?.motherHometel ?? "");
    motherMobileCtrl = TextEditingController(text: p?.motherMobile ?? "");

    contactEmailCtrl = TextEditingController(text: p?.contactEmail ?? "");
    contactMobileCtrl = TextEditingController(text: p?.contactMobile ?? "");
    parentPasswordCtrl = TextEditingController(text: p?.parentPwd ?? "");

    fatherProfessionCtrl = TextEditingController(
      text: p?.fatherProfession ?? "",
    );
    fatherCompanyCtrl = TextEditingController(text: p?.fatherCompany ?? "");
    fatherWorkplaceCtrl = TextEditingController(text: p?.fatherWorkplace ?? "");

    motherProfessionCtrl = TextEditingController(
      text: p?.motherProfession ?? "",
    );
    motherCompanyCtrl = TextEditingController(text: p?.motherCompany ?? "");
    motherWorkplaceCtrl = TextEditingController(text: p?.motherWorkplace ?? "");

    fatherSchoolCtrl = TextEditingController(text: p?.fatherSchool ?? "");
    fatherDiplomeCtrl = TextEditingController(text: p?.fatherDiplome ?? "");
    fatherOtherLangCtrl = TextEditingController(
      text: p?.fatherAutreslang ?? "",
    );

    motherSchoolCtrl = TextEditingController(text: p?.motherSchool ?? "");
    motherDiplomeCtrl = TextEditingController(text: p?.motherDiplome ?? "");
    motherOtherLangCtrl = TextEditingController(
      text: p?.motherAutreslang ?? "",
    );

    urgentName1Ctrl = TextEditingController(text: p?.urgentName1 ?? "");
    urgentRelation1Ctrl = TextEditingController(
      text: p?.urgentParentrelation1 ?? "",
    );
    urgentTel1Ctrl = TextEditingController(text: p?.urgentTel1 ?? "");
    urgentMobile1Ctrl = TextEditingController(text: p?.urgentMobile1 ?? "");

    urgentName2Ctrl = TextEditingController(text: p?.urgentName2 ?? "");
    urgentRelation2Ctrl = TextEditingController(
      text: p?.urgentParentrelation2 ?? "",
    );
    urgentTel2Ctrl = TextEditingController(text: p?.urgentTel2 ?? "");
    urgentMobile2Ctrl = TextEditingController(text: p?.urgentMobile2 ?? "");

    urgentName3Ctrl = TextEditingController(text: p?.urgentName3 ?? "");
    urgentRelation3Ctrl = TextEditingController(
      text: p?.urgentParentrelation3 ?? "",
    );
    urgentTel3Ctrl = TextEditingController(text: p?.urgentTel3 ?? "");
    urgentMobile3Ctrl = TextEditingController(text: p?.urgentMobile3 ?? "");
  }

  /// REGISTER LISTENERS (MARK DIRTY)
  void registerDirtyListeners() {
    fatherTutorCtrl.addListener(
      () => dirtySections.add(ProfileSection.general),
    );
    fatherAddressCtrl.addListener(
      () => dirtySections.add(ProfileSection.general),
    );
    motherTutorCtrl.addListener(
      () => dirtySections.add(ProfileSection.general),
    );
    motherAddressCtrl.addListener(
      () => dirtySections.add(ProfileSection.general),
    );

    fatherEmailCtrl.addListener(
      () => dirtySections.add(ProfileSection.contact),
    );
    fatherHomeTelCtrl.addListener(
      () => dirtySections.add(ProfileSection.contact),
    );
    fatherMobileCtrl.addListener(
      () => dirtySections.add(ProfileSection.contact),
    );

    motherEmailCtrl.addListener(
      () => dirtySections.add(ProfileSection.contact),
    );
    motherHomeTelCtrl.addListener(
      () => dirtySections.add(ProfileSection.contact),
    );
    motherMobileCtrl.addListener(
      () => dirtySections.add(ProfileSection.contact),
    );

    contactEmailCtrl.addListener(
      () => dirtySections.add(ProfileSection.contact),
    );
    contactMobileCtrl.addListener(
      () => dirtySections.add(ProfileSection.contact),
    );
    parentPasswordCtrl.addListener(
      () => dirtySections.add(ProfileSection.contact),
    );

    fatherProfessionCtrl.addListener(
      () => dirtySections.add(ProfileSection.work),
    );
    fatherCompanyCtrl.addListener(() => dirtySections.add(ProfileSection.work));
    fatherWorkplaceCtrl.addListener(
      () => dirtySections.add(ProfileSection.work),
    );

    motherProfessionCtrl.addListener(
      () => dirtySections.add(ProfileSection.work),
    );
    motherCompanyCtrl.addListener(() => dirtySections.add(ProfileSection.work));
    motherWorkplaceCtrl.addListener(
      () => dirtySections.add(ProfileSection.work),
    );

    fatherSchoolCtrl.addListener(
      () => dirtySections.add(ProfileSection.education),
    );
    fatherDiplomeCtrl.addListener(
      () => dirtySections.add(ProfileSection.education),
    );
    fatherOtherLangCtrl.addListener(
      () => dirtySections.add(ProfileSection.education),
    );

    motherSchoolCtrl.addListener(
      () => dirtySections.add(ProfileSection.education),
    );
    motherDiplomeCtrl.addListener(
      () => dirtySections.add(ProfileSection.education),
    );
    motherOtherLangCtrl.addListener(
      () => dirtySections.add(ProfileSection.education),
    );

    urgentName1Ctrl.addListener(
      () => dirtySections.add(ProfileSection.emergency),
    );
    urgentRelation1Ctrl.addListener(
      () => dirtySections.add(ProfileSection.emergency),
    );
    urgentTel1Ctrl.addListener(
      () => dirtySections.add(ProfileSection.emergency),
    );
    urgentMobile1Ctrl.addListener(
      () => dirtySections.add(ProfileSection.emergency),
    );

    urgentName2Ctrl.addListener(
      () => dirtySections.add(ProfileSection.emergency),
    );
    urgentRelation2Ctrl.addListener(
      () => dirtySections.add(ProfileSection.emergency),
    );
    urgentTel2Ctrl.addListener(
      () => dirtySections.add(ProfileSection.emergency),
    );
    urgentMobile2Ctrl.addListener(
      () => dirtySections.add(ProfileSection.emergency),
    );

    urgentName3Ctrl.addListener(
      () => dirtySections.add(ProfileSection.emergency),
    );
    urgentRelation3Ctrl.addListener(
      () => dirtySections.add(ProfileSection.emergency),
    );
    urgentTel3Ctrl.addListener(
      () => dirtySections.add(ProfileSection.emergency),
    );
    urgentMobile3Ctrl.addListener(
      () => dirtySections.add(ProfileSection.emergency),
    );
  }

  /// DISPOSE ALL CONTROLLERS
  void dispose() {
    fatherTutorCtrl.dispose();
    fatherAddressCtrl.dispose();
    motherTutorCtrl.dispose();
    motherAddressCtrl.dispose();

    fatherEmailCtrl.dispose();
    fatherHomeTelCtrl.dispose();
    fatherMobileCtrl.dispose();
    motherEmailCtrl.dispose();
    motherHomeTelCtrl.dispose();
    motherMobileCtrl.dispose();

    contactEmailCtrl.dispose();
    contactMobileCtrl.dispose();
    parentPasswordCtrl.dispose();

    fatherProfessionCtrl.dispose();
    fatherCompanyCtrl.dispose();
    fatherWorkplaceCtrl.dispose();
    motherProfessionCtrl.dispose();
    motherCompanyCtrl.dispose();
    motherWorkplaceCtrl.dispose();

    fatherSchoolCtrl.dispose();
    fatherDiplomeCtrl.dispose();
    fatherOtherLangCtrl.dispose();
    motherSchoolCtrl.dispose();
    motherDiplomeCtrl.dispose();
    motherOtherLangCtrl.dispose();

    urgentName1Ctrl.dispose();
    urgentRelation1Ctrl.dispose();
    urgentTel1Ctrl.dispose();
    urgentMobile1Ctrl.dispose();

    urgentName2Ctrl.dispose();
    urgentRelation2Ctrl.dispose();
    urgentTel2Ctrl.dispose();
    urgentMobile2Ctrl.dispose();

    urgentName3Ctrl.dispose();
    urgentRelation3Ctrl.dispose();
    urgentTel3Ctrl.dispose();
    urgentMobile3Ctrl.dispose();
  }
}

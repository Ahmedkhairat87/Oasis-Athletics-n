import 'package:flutter/material.dart';

import '../../../../../core/model/sideMenu/parentProfile/jobDomain/jobDomain.dart';
import '../../../../../core/model/sideMenu/parentProfile/parentLanguage/ParentLanguage.dart';
import '../../../../../core/model/sideMenu/parentProfile/parentStatus/ParentStatus.dart';
import '../../../../../core/model/sideMenu/parentProfile/profileMainData/parentProfileData.dart';
import '../../../../../core/services/parentProfile/parentProfileService.dart';
import '../../../../../core/services/parentProfile/parent_profile_update_service.dart';

enum ProfileSection { general, contact, work, education, emergency }

class ParentProfileState extends ChangeNotifier {
  bool loading = false;
  String? error;

  /// UI
  ProfileSection currentSection = ProfileSection.general;
  bool editMode = false;

  // ===================== helpers =====================
  String _s(dynamic v) => (v ?? '').toString().trim();

  void _startLoading() {
    loading = true;
    error = null;
    notifyListeners();
  }

  void _stopLoading({String? err}) {
    loading = false;
    error = err;
    notifyListeners();
  }

  // ===================== data =====================
  parentProfileData? profile;

  // lists
  List<jobDomain> jobDomains = [];
  List<ParentStatus> parentStatuses = [];
  List<ParentLanguage> parentLanguages = [];

  // selections
  jobDomain? selectedFatherDomain;
  jobDomain? selectedMotherDomain;
  ParentStatus? selectedParentStatus;

  ParentLanguage? fatherLang1;
  ParentLanguage? fatherLang2;
  ParentLanguage? fatherLang3;

  ParentLanguage? motherLang1;
  ParentLanguage? motherLang2;
  ParentLanguage? motherLang3;

  /// dirty sections
  final Set<ProfileSection> dirtySections = {};

  // ===================== controllers =====================
  late TextEditingController fatherNameCtrl;
  late TextEditingController fatherTutorCtrl;
  late TextEditingController fatherAddressCtrl;

  late TextEditingController motherNameCtrl;
  late TextEditingController motherTutorCtrl;
  late TextEditingController motherAddressCtrl;

  late TextEditingController fatherEmailCtrl;
  late TextEditingController fatherHomeTelCtrl;
  late TextEditingController fatherMobileCtrl;

  late TextEditingController motherEmailCtrl;
  late TextEditingController motherHomeTelCtrl;
  late TextEditingController motherMobileCtrl;

  late TextEditingController contactEmailCtrl;
  late TextEditingController contactMobileCtrl;
  late TextEditingController parentPasswordCtrl;

  late TextEditingController fatherProfessionCtrl;
  late TextEditingController fatherCompanyCtrl;
  late TextEditingController fatherWorkplaceCtrl;

  late TextEditingController motherProfessionCtrl;
  late TextEditingController motherCompanyCtrl;
  late TextEditingController motherWorkplaceCtrl;

  late TextEditingController fatherSchoolCtrl;
  late TextEditingController fatherDiplomeCtrl;
  late TextEditingController fatherOtherLangCtrl;

  late TextEditingController motherSchoolCtrl;
  late TextEditingController motherDiplomeCtrl;
  late TextEditingController motherOtherLangCtrl;

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

  ParentProfileState() {
    load();
  }

  // ===================== UI actions =====================
  void selectSection(ProfileSection s) {
    currentSection = s;
    notifyListeners();
  }

  void toggleEdit() {
    editMode = !editMode;
    notifyListeners();
  }

  /// ✅ Called by AppBar (X) -> restore original values and close edit mode
  void cancelEdit() {
    final p = profile;

    // if no profile loaded yet, just exit edit mode
    if (p == null) {
      editMode = false;
      dirtySections.clear();
      notifyListeners();
      return;
    }

    // restore controllers text (NO recreating controllers)
    fatherNameCtrl.text = p.fatherFullname ?? "";
    fatherTutorCtrl.text = p.fatherTuteur ?? "";
    fatherAddressCtrl.text = p.fatherAddress ?? "";

    motherNameCtrl.text = p.motherFullname ?? "";
    motherTutorCtrl.text = p.motherTuteur ?? "";
    motherAddressCtrl.text = p.motherAddress ?? "";

    fatherEmailCtrl.text = p.fatherEmail ?? "";
    fatherHomeTelCtrl.text = p.fatherHometel ?? "";
    fatherMobileCtrl.text = p.fatherMobile ?? "";

    motherEmailCtrl.text = p.motherEmail ?? "";
    motherHomeTelCtrl.text = p.motherHometel ?? "";
    motherMobileCtrl.text = p.motherMobile ?? "";

    contactEmailCtrl.text = p.contactEmail ?? "";
    contactMobileCtrl.text = p.contactMobile ?? "";
    parentPasswordCtrl.text = p.parentPwd ?? "";

    fatherProfessionCtrl.text = p.fatherProfession ?? "";
    fatherCompanyCtrl.text = p.fatherCompany ?? "";
    fatherWorkplaceCtrl.text = p.fatherWorkplace ?? "";

    motherProfessionCtrl.text = p.motherProfession ?? "";
    motherCompanyCtrl.text = p.motherCompany ?? "";
    motherWorkplaceCtrl.text = p.motherWorkplace ?? "";

    fatherSchoolCtrl.text = p.fatherSchool ?? "";
    fatherDiplomeCtrl.text = p.fatherDiplome ?? "";
    fatherOtherLangCtrl.text = p.fatherAutreslang ?? "";

    motherSchoolCtrl.text = p.motherSchool ?? "";
    motherDiplomeCtrl.text = p.motherDiplome ?? "";
    motherOtherLangCtrl.text = p.motherAutreslang ?? "";

    urgentName1Ctrl.text = p.urgentName1 ?? "";
    urgentRelation1Ctrl.text = p.urgentParentrelation1 ?? "";
    urgentTel1Ctrl.text = p.urgentTel1 ?? "";
    urgentMobile1Ctrl.text = p.urgentMobile1 ?? "";

    urgentName2Ctrl.text = p.urgentName2 ?? "";
    urgentRelation2Ctrl.text = p.urgentParentrelation2 ?? "";
    urgentTel2Ctrl.text = p.urgentTel2 ?? "";
    urgentMobile2Ctrl.text = p.urgentMobile2 ?? "";

    urgentName3Ctrl.text = p.urgentName3 ?? "";
    urgentRelation3Ctrl.text = p.urgentParentrelation3 ?? "";
    urgentTel3Ctrl.text = p.urgentTel3 ?? "";
    urgentMobile3Ctrl.text = p.urgentTel3 ?? ""; // ✅ check if you have urgentMobile3 in model
    // If your model has urgentMobile3, use:
    // urgentMobile3Ctrl.text = p.urgentMobile3 ?? "";

    // restore selections from profile
    _initSelections(p);

    dirtySections.clear();
    editMode = false;
    notifyListeners();
  }

  // ===================== LOAD =====================
  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final profileRes = await ParentProfileService.getParentProfile();
      final domainRes = await ParentProfileService.getJobDomains();
      final statusRes = await ParentProfileService.getParentStatus();
      final langRes = await ParentProfileService.getParentLanguages();

      final p = profileRes?.data?.isNotEmpty == true ? profileRes!.data!.first : null;
      profile = p;

      jobDomains = domainRes?.data ?? [];
      parentStatuses = statusRes?.data ?? [];
      parentLanguages = langRes?.data ?? [];

      _initControllers(p);
      _initSelections(p);

      loading = false;
      notifyListeners();
    } catch (e, st) {
      debugPrint('❌ ParentProfile load error: $e');
      debugPrint(st.toString());
      loading = false;
      error = 'Failed to load parent profile';
      notifyListeners();
    }
  }

  void _initControllers(parentProfileData? p) {
    fatherNameCtrl = TextEditingController(text: p?.fatherFullname ?? "");
    fatherTutorCtrl = TextEditingController(text: p?.fatherTuteur ?? "");
    fatherAddressCtrl = TextEditingController(text: p?.fatherAddress ?? "");

    motherNameCtrl = TextEditingController(text: p?.motherFullname ?? "");
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

    fatherProfessionCtrl = TextEditingController(text: p?.fatherProfession ?? "");
    fatherCompanyCtrl = TextEditingController(text: p?.fatherCompany ?? "");
    fatherWorkplaceCtrl = TextEditingController(text: p?.fatherWorkplace ?? "");

    motherProfessionCtrl = TextEditingController(text: p?.motherProfession ?? "");
    motherCompanyCtrl = TextEditingController(text: p?.motherCompany ?? "");
    motherWorkplaceCtrl = TextEditingController(text: p?.motherWorkplace ?? "");

    fatherSchoolCtrl = TextEditingController(text: p?.fatherSchool ?? "");
    fatherDiplomeCtrl = TextEditingController(text: p?.fatherDiplome ?? "");
    fatherOtherLangCtrl = TextEditingController(text: p?.fatherAutreslang ?? "");

    motherSchoolCtrl = TextEditingController(text: p?.motherSchool ?? "");
    motherDiplomeCtrl = TextEditingController(text: p?.motherDiplome ?? "");
    motherOtherLangCtrl = TextEditingController(text: p?.motherAutreslang ?? "");

    urgentName1Ctrl = TextEditingController(text: p?.urgentName1 ?? "");
    urgentRelation1Ctrl = TextEditingController(text: p?.urgentParentrelation1 ?? "");
    urgentTel1Ctrl = TextEditingController(text: p?.urgentTel1 ?? "");
    urgentMobile1Ctrl = TextEditingController(text: p?.urgentMobile1 ?? "");

    urgentName2Ctrl = TextEditingController(text: p?.urgentName2 ?? "");
    urgentRelation2Ctrl = TextEditingController(text: p?.urgentParentrelation2 ?? "");
    urgentTel2Ctrl = TextEditingController(text: p?.urgentTel2 ?? "");
    urgentMobile2Ctrl = TextEditingController(text: p?.urgentMobile2 ?? "");

    urgentName3Ctrl = TextEditingController(text: p?.urgentName3 ?? "");
    urgentRelation3Ctrl = TextEditingController(text: p?.urgentParentrelation3 ?? "");
    urgentTel3Ctrl = TextEditingController(text: p?.urgentTel3 ?? "");
    urgentMobile3Ctrl = TextEditingController(text: p?.urgentMobile3 ?? "");

    _registerDirtyListeners();
  }

  void _registerDirtyListeners() {
    void mark(ProfileSection s) => dirtySections.add(s);

    fatherTutorCtrl.addListener(() => mark(ProfileSection.general));
    fatherAddressCtrl.addListener(() => mark(ProfileSection.general));
    motherTutorCtrl.addListener(() => mark(ProfileSection.general));
    motherAddressCtrl.addListener(() => mark(ProfileSection.general));

    fatherEmailCtrl.addListener(() => mark(ProfileSection.contact));
    fatherHomeTelCtrl.addListener(() => mark(ProfileSection.contact));
    fatherMobileCtrl.addListener(() => mark(ProfileSection.contact));
    motherEmailCtrl.addListener(() => mark(ProfileSection.contact));
    motherHomeTelCtrl.addListener(() => mark(ProfileSection.contact));
    motherMobileCtrl.addListener(() => mark(ProfileSection.contact));
    contactEmailCtrl.addListener(() => mark(ProfileSection.contact));
    contactMobileCtrl.addListener(() => mark(ProfileSection.contact));
    parentPasswordCtrl.addListener(() => mark(ProfileSection.contact));

    fatherProfessionCtrl.addListener(() => mark(ProfileSection.work));
    fatherCompanyCtrl.addListener(() => mark(ProfileSection.work));
    fatherWorkplaceCtrl.addListener(() => mark(ProfileSection.work));
    motherProfessionCtrl.addListener(() => mark(ProfileSection.work));
    motherCompanyCtrl.addListener(() => mark(ProfileSection.work));
    motherWorkplaceCtrl.addListener(() => mark(ProfileSection.work));

    fatherSchoolCtrl.addListener(() => mark(ProfileSection.education));
    fatherDiplomeCtrl.addListener(() => mark(ProfileSection.education));
    fatherOtherLangCtrl.addListener(() => mark(ProfileSection.education));
    motherSchoolCtrl.addListener(() => mark(ProfileSection.education));
    motherDiplomeCtrl.addListener(() => mark(ProfileSection.education));
    motherOtherLangCtrl.addListener(() => mark(ProfileSection.education));

    urgentName1Ctrl.addListener(() => mark(ProfileSection.emergency));
    urgentRelation1Ctrl.addListener(() => mark(ProfileSection.emergency));
    urgentTel1Ctrl.addListener(() => mark(ProfileSection.emergency));
    urgentMobile1Ctrl.addListener(() => mark(ProfileSection.emergency));
    urgentName2Ctrl.addListener(() => mark(ProfileSection.emergency));
    urgentRelation2Ctrl.addListener(() => mark(ProfileSection.emergency));
    urgentTel2Ctrl.addListener(() => mark(ProfileSection.emergency));
    urgentMobile2Ctrl.addListener(() => mark(ProfileSection.emergency));
    urgentName3Ctrl.addListener(() => mark(ProfileSection.emergency));
    urgentRelation3Ctrl.addListener(() => mark(ProfileSection.emergency));
    urgentTel3Ctrl.addListener(() => mark(ProfileSection.emergency));
    urgentMobile3Ctrl.addListener(() => mark(ProfileSection.emergency));
  }

  void _initSelections(parentProfileData? p) {
    jobDomain? findDomain(num? serNo) {
      if (serNo == null) return null;
      for (final d in jobDomains) {
        if (d.serno == serNo) return d;
      }
      return null;
    }

    selectedFatherDomain = findDomain(p?.fatherDomain);
    selectedMotherDomain = findDomain(p?.motherDomain);

    selectedParentStatus = _matchParentStatus(parentStatuses, p?.parentStatus);

    if (p != null) _assignLanguages(p);
  }

  ParentStatus? _matchParentStatus(List<ParentStatus> statuses, String? profileValue) {
    if (profileValue == null || profileValue.isEmpty) return null;
    final parsedSerNo = num.tryParse(profileValue);
    for (final s in statuses) {
      if (s.serNo == parsedSerNo) return s;
    }
    return null;
  }

  void _assignLanguages(parentProfileData p) {
    ParentLanguage? findLang(String? value) {
      if (value == null || value.trim().isEmpty) return null;
      final normalized = value.trim().toLowerCase();
      for (final lang in parentLanguages) {
        if ((lang.parentlang ?? '').trim().toLowerCase() == normalized) return lang;
      }
      return null;
    }

    fatherLang1 = findLang(p.father1lang);
    fatherLang2 = findLang(p.father2lang);
    fatherLang3 = findLang(p.father3lang);

    motherLang1 = findLang(p.mother1lang);
    motherLang2 = findLang(p.mother2lang);
    motherLang3 = findLang(p.mother3lang);
  }

  // ===================== SAVE (used by AppBar Save) =====================

  /// ✅ Save ONLY current section (AppBar check), returns true on success.
  Future<bool> save() async {
    // If nothing changed -> just exit edit mode in UI
    if (!dirtySections.contains(currentSection)) {
      return true;
    }
    return saveCurrentSection(currentSection);
  }

  Future<bool> saveGeneral() async {
    _startLoading();

    final ok = await ParentProfileUpdateService.updateGeneral(
      fatherTutor: _s(fatherTutorCtrl.text),
      fatherAddress: _s(fatherAddressCtrl.text),
      motherTutor: _s(motherTutorCtrl.text),
      motherAddress: _s(motherAddressCtrl.text),
      parentStatus: (selectedParentStatus?.serNo?.toString() ?? ""),
    );

    _stopLoading(err: ok ? null : "Failed to save general info");
    if (ok) dirtySections.remove(ProfileSection.general);
    return ok;
  }

  Future<bool> saveContact() async {
    _startLoading();

    final ok = await ParentProfileUpdateService.updateContact(
      fatherEmail: _s(fatherEmailCtrl.text),
      fatherHomeTel: _s(fatherHomeTelCtrl.text),
      fatherMobile: _s(fatherMobileCtrl.text),
      motherEmail: _s(motherEmailCtrl.text),
      motherHomeTel: _s(motherHomeTelCtrl.text),
      motherMobile: _s(motherMobileCtrl.text),
    );

    _stopLoading(err: ok ? null : "Failed to save contact info");
    if (ok) dirtySections.remove(ProfileSection.contact);
    return ok;
  }

  Future<bool> saveWork() async {
    _startLoading();

    final ok = await ParentProfileUpdateService.updateWork(
      fatherProfession: _s(fatherProfessionCtrl.text),
      fatherCompany: _s(fatherCompanyCtrl.text),
      fatherWorkplace: _s(fatherWorkplaceCtrl.text),
      fatherDomainSer: (selectedFatherDomain?.serno?.toString() ?? ""),
      motherProfession: _s(motherProfessionCtrl.text),
      motherCompany: _s(motherCompanyCtrl.text),
      motherWorkplace: _s(motherWorkplaceCtrl.text),
      motherDomainSer: (selectedMotherDomain?.serno?.toString() ?? ""),
    );

    _stopLoading(err: ok ? null : "Failed to save work info");
    if (ok) dirtySections.remove(ProfileSection.work);
    return ok;
  }

  Future<bool> saveEducation() async {
    _startLoading();

    final ok = await ParentProfileUpdateService.updateEducation(
      fatherSchool: _s(fatherSchoolCtrl.text),
      fatherDiplome: _s(fatherDiplomeCtrl.text),
      father1Lang: _s(fatherLang1?.parentlang),
      father2Lang: _s(fatherLang2?.parentlang),
      father3Lang: _s(fatherLang3?.parentlang),
      fatherAutreslang: _s(fatherOtherLangCtrl.text),
      motherSchool: _s(motherSchoolCtrl.text),
      motherDiplome: _s(motherDiplomeCtrl.text),
      mother1Lang: _s(motherLang1?.parentlang),
      mother2Lang: _s(motherLang2?.parentlang),
      mother3Lang: _s(motherLang3?.parentlang),
      motherAutreslang: _s(motherOtherLangCtrl.text),
    );

    _stopLoading(err: ok ? null : "Failed to save education info");
    if (ok) dirtySections.remove(ProfileSection.education);
    return ok;
  }

  Future<bool> saveCurrentSection(ProfileSection section) async {
    switch (section) {
      case ProfileSection.general:
        return saveGeneral();
      case ProfileSection.contact:
        return saveContact();
      case ProfileSection.work:
        return saveWork();
      case ProfileSection.education:
        return saveEducation();
      case ProfileSection.emergency:
        _stopLoading(err: "Emergency API not added yet");
        return false;
    }
  }

  // ===================== dispose =====================
  @override
  void dispose() {
    fatherNameCtrl.dispose();
    motherNameCtrl.dispose();

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

    super.dispose();
  }
}
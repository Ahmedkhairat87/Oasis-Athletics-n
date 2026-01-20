import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:oasisathletic/core/reusable_components/app_background.dart';

import '../../../../core/model/sideMenu/parentProfile/jobDomain/jobDomain.dart';
import '../../../../core/model/sideMenu/parentProfile/parentLanguage/ParentLanguage.dart';
import '../../../../core/model/sideMenu/parentProfile/parentStatus/ParentStatus.dart';
import '../../../../core/model/sideMenu/parentProfile/profileMainData/parentProfileData.dart';
import '../../../../core/services/parentProfile/parentProfileService.dart';

class Parentprofile extends StatefulWidget {
  static const routeName = '/parentprofile';
  const Parentprofile({super.key});

  @override
  State<Parentprofile> createState() => _ParentprofileState();
}

class _ParentprofileState extends State<Parentprofile> {
  ProfileSection _currentSection = ProfileSection.general;
  final Set<ProfileSection> _dirtySections = {};
  bool _editMode = false;
  parentProfileData? _profile;
  bool _loadingProfile = true;
  List<jobDomain> _jobDomains = [];
  jobDomain? _selectedFatherDomain;
  jobDomain? _selectedMotherDomain;
  // ===== STATUS =====
  List<ParentStatus> _parentStatuses = [];
  ParentStatus? _selectedParentStatus;

  // ===== LANGUAGE =====
  List<ParentLanguage> _parentLanguages = [];
  // ===== FATHER =====
  ParentLanguage? _fatherLang1;
  ParentLanguage? _fatherLang2;
  ParentLanguage? _fatherLang3;
  // ===== MOTHER =====
  ParentLanguage? _motherLang1;
  ParentLanguage? _motherLang2;
  ParentLanguage? _motherLang3;

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

  @override
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

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadParentProfile();
  }

  void _toggleEdit() {
    setState(() => _editMode = !_editMode);
    if (!_editMode) FocusScope.of(context).unfocus();
  }

  void _selectSection(ProfileSection section) {
    setState(() => _currentSection = section);
  }

  Future<void> _loadParentProfile() async {
    setState(() => _loadingProfile = true);

    try {
      final profileRes = await ParentProfileService.getParentProfile();
      final domainRes = await ParentProfileService.getJobDomains();
      final statusRes = await ParentProfileService.getParentStatus();
      final langRes = await ParentProfileService.getParentLanguages();

      if (!mounted) return;

      final profile =
          profileRes?.data?.isNotEmpty == true ? profileRes!.data!.first : null;

      setState(() {
        _profile = profile;
        // ================= CONTROLLERS INIT =================
        fatherTutorCtrl = TextEditingController(
          text: profile?.fatherTuteur ?? "",
        );
        fatherAddressCtrl = TextEditingController(
          text: profile?.fatherAddress ?? "",
        );
        motherTutorCtrl = TextEditingController(
          text: profile?.motherTuteur ?? "",
        );
        motherAddressCtrl = TextEditingController(
          text: profile?.motherAddress ?? "",
        );

        // ================= CONTACT =================
        fatherEmailCtrl = TextEditingController(
          text: profile?.fatherEmail ?? "",
        );
        fatherHomeTelCtrl = TextEditingController(
          text: profile?.fatherHometel ?? "",
        );
        fatherMobileCtrl = TextEditingController(
          text: profile?.fatherMobile ?? "",
        );

        motherEmailCtrl = TextEditingController(
          text: profile?.motherEmail ?? "",
        );
        motherHomeTelCtrl = TextEditingController(
          text: profile?.motherHometel ?? "",
        );
        motherMobileCtrl = TextEditingController(
          text: profile?.motherMobile ?? "",
        );

        contactEmailCtrl = TextEditingController(
          text: profile?.contactEmail ?? "",
        );
        contactMobileCtrl = TextEditingController(
          text: profile?.contactMobile ?? "",
        );
        parentPasswordCtrl = TextEditingController(
          text: profile?.parentPwd ?? "",
        );

        // ================= WORK =================
        fatherProfessionCtrl = TextEditingController(
          text: profile?.fatherProfession ?? "",
        );
        fatherCompanyCtrl = TextEditingController(
          text: profile?.fatherCompany ?? "",
        );
        fatherWorkplaceCtrl = TextEditingController(
          text: profile?.fatherWorkplace ?? "",
        );

        motherProfessionCtrl = TextEditingController(
          text: profile?.motherProfession ?? "",
        );
        motherCompanyCtrl = TextEditingController(
          text: profile?.motherCompany ?? "",
        );
        motherWorkplaceCtrl = TextEditingController(
          text: profile?.motherWorkplace ?? "",
        );

        // ================= EDUCATION =================
        fatherSchoolCtrl = TextEditingController(
          text: profile?.fatherSchool ?? "",
        );
        fatherDiplomeCtrl = TextEditingController(
          text: profile?.fatherDiplome ?? "",
        );
        fatherOtherLangCtrl = TextEditingController(
          text: profile?.fatherAutreslang ?? "",
        );

        motherSchoolCtrl = TextEditingController(
          text: profile?.motherSchool ?? "",
        );
        motherDiplomeCtrl = TextEditingController(
          text: profile?.motherDiplome ?? "",
        );
        motherOtherLangCtrl = TextEditingController(
          text: profile?.motherAutreslang ?? "",
        );

        // ================= EMERGENCY =================
        urgentName1Ctrl = TextEditingController(
          text: profile?.urgentName1 ?? "",
        );
        urgentRelation1Ctrl = TextEditingController(
          text: profile?.urgentParentrelation1 ?? "",
        );
        urgentTel1Ctrl = TextEditingController(text: profile?.urgentTel1 ?? "");
        urgentMobile1Ctrl = TextEditingController(
          text: profile?.urgentMobile1 ?? "",
        );

        urgentName2Ctrl = TextEditingController(
          text: profile?.urgentName2 ?? "",
        );
        urgentRelation2Ctrl = TextEditingController(
          text: profile?.urgentParentrelation2 ?? "",
        );
        urgentTel2Ctrl = TextEditingController(text: profile?.urgentTel2 ?? "");
        urgentMobile2Ctrl = TextEditingController(
          text: profile?.urgentMobile2 ?? "",
        );

        urgentName3Ctrl = TextEditingController(
          text: profile?.urgentName3 ?? "",
        );
        urgentRelation3Ctrl = TextEditingController(
          text: profile?.urgentParentrelation3 ?? "",
        );
        urgentTel3Ctrl = TextEditingController(text: profile?.urgentTel3 ?? "");
        urgentMobile3Ctrl = TextEditingController(
          text: profile?.urgentMobile3 ?? "",
        );

        // ================= DOMAINS =================
        _jobDomains = domainRes?.data ?? [];

        jobDomain? findDomain(num? serNo) {
          if (serNo == null) return null;
          for (final d in _jobDomains) {
            if (d.serno == serNo) return d;
          }
          return null;
        }

        _selectedFatherDomain = findDomain(profile?.fatherDomain);
        _selectedMotherDomain = findDomain(profile?.motherDomain);

        // ================= STATUS =================
        _parentStatuses = statusRes?.data ?? [];

        _selectedParentStatus = _matchParentStatus(
          _parentStatuses,
          profile?.parentStatus,
        );

        // ================= LANGUAGES =================
        _parentLanguages = langRes?.data ?? [];

        if (profile != null) {
          _assignLanguages(profile);
        }

        _loadingProfile = false;
      });
    } catch (e, st) {
      debugPrint('❌ Parent profile load error');
      debugPrint(e.toString());
      debugPrint(st.toString());

      if (mounted) {
        setState(() => _loadingProfile = false);
      }
    }
  }

  ParentStatus? _matchParentStatus(
    List<ParentStatus> statuses,
    String? profileValue,
  ) {
    if (profileValue == null || profileValue.isEmpty) return null;

    final parsedSerNo = num.tryParse(profileValue);

    for (final s in statuses) {
      if (s.serNo == parsedSerNo) {
        return s;
      }
    }
    return null;
  }

  void _assignLanguages(parentProfileData p) {
    ParentLanguage? findLang(String? value) {
      if (value == null || value.trim().isEmpty) return null;

      final normalized = value.trim().toLowerCase();

      for (final lang in _parentLanguages) {
        if (lang.parentlang?.trim().toLowerCase() == normalized) {
          return lang;
        }
      }
      return null;
    }

    // ===== FATHER =====
    _fatherLang1 = findLang(p.father1lang);
    _fatherLang2 = findLang(p.father2lang);
    _fatherLang3 = findLang(p.father3lang);

    // ===== MOTHER =====
    _motherLang1 = findLang(p.mother1lang);
    _motherLang2 = findLang(p.mother2lang);
    _motherLang3 = findLang(p.mother3lang);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Parents Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_editMode ? Icons.check : Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: Stack(
            children: [
              _loadingProfile
                  ? const Center(child: CircularProgressIndicator())
                  : _buildSection(),

              /// ===== CIRCULAR MENU =====
              CircularMenu(
                alignment: Alignment.bottomRight,
                radius: 90.w,
                startingAngleInRadian: 3.0,
                endingAngleInRadian: 4.7,
                toggleButtonColor: Colors.blue,
                toggleButtonIconColor: Colors.white,
                items:
                    ProfileSection.values.map((section) {
                      final isActive = section == _currentSection;
                      return CircularMenuItem(
                        icon: section.icon,
                        iconSize: 16.sp,
                        padding: 10.w,
                        iconColor: isActive ? Colors.white : Colors.blue,
                        color: isActive ? Colors.blue : Colors.white,
                        onTap: () => _selectSection(section),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= SECTION SWITCH =================
  Widget _buildSection() {
    switch (_currentSection) {
      /// ---------- GENERAL ----------
      case ProfileSection.general:
        return _section("general".tr(), [
          SectionTitle("father_info".tr()),
          EditableField(
            label: "father_name".tr(),
            initialValue: _profile?.fatherFullname ?? '',
            editMode: _editMode,
            canEdit: false,
          ),
          EditableField(
            label: "tutor_name".tr(),
            initialValue: _profile?.fatherTuteur ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "private_address".tr(),
            initialValue: _profile?.fatherAddress ?? '',
            editMode: _editMode,
          ),

          SectionTitle("mother_info".tr()),
          EditableField(
            label: "mother_name".tr(),
            initialValue: _profile?.motherFullname ?? '',
            editMode: _editMode,
            canEdit: false, // 🔒 LOCKED
          ),
          EditableField(
            label: "tutor_name".tr(),
            initialValue: _profile?.motherTuteur ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "private_address".tr(),
            initialValue: _profile?.motherAddress ?? '',
            editMode: _editMode,
          ),
          ProfileDropdown<ParentStatus>(
            label: 'Family Situation'.tr(),
            value: _selectedParentStatus,
            items: _parentStatuses,
            enabled: _editMode,
            itemLabel: (e) => e.parentstatusEn ?? e.parentstatus ?? '',
            onChanged: (val) {
              setState(() => _selectedParentStatus = val);
            },
          ),
        ]);

      /// ---------- EDUCATION ----------
      case ProfileSection.education:
        return _section("education".tr(), [
          SectionTitle("father_info".tr()),
          EditableField(
            label: "school".tr(),
            initialValue: _profile?.fatherSchool ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "diploma".tr(),
            initialValue: _profile?.fatherDiplome ?? '',
            editMode: _editMode,
          ),
          ProfileDropdown<ParentLanguage>(
            label: "mother_tongue".tr(),
            value: _fatherLang1,
            items: _parentLanguages,
            enabled: _editMode,
            itemLabel: (e) => e.parentlang ?? '',
            onChanged: (val) {
              setState(() => _fatherLang1 = val);
            },
          ),
          ProfileDropdown<ParentLanguage>(
            label: "second_language".tr(),
            value: _fatherLang2,
            items: _parentLanguages,
            enabled: _editMode,
            itemLabel: (e) => e.parentlang ?? '',
            onChanged: (val) {
              setState(() => _fatherLang2 = val);
            },
          ),
          ProfileDropdown<ParentLanguage>(
            label: "third_language".tr(),
            value: _fatherLang3,
            items: _parentLanguages,
            enabled: _editMode,
            itemLabel: (e) => e.parentlang ?? '',
            onChanged: (val) {
              setState(() => _fatherLang3 = val);
            },
          ),
          EditableField(
            label: "other_language".tr(),
            initialValue: _profile?.fatherAutreslang ?? '',
            editMode: _editMode,
          ),

          SectionTitle("mother_info".tr()),
          EditableField(
            label: 'School',
            initialValue: _profile?.motherSchool ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: 'Diploma',
            initialValue: _profile?.motherDiplome ?? '',
            editMode: _editMode,
          ),
          ProfileDropdown<ParentLanguage>(
            label: "mother_tongue".tr(),
            value: _motherLang1,
            items: _parentLanguages,
            enabled: _editMode,
            itemLabel: (e) => e.parentlang ?? '',
            onChanged: (val) {
              setState(() => _motherLang1 = val);
            },
          ),
          ProfileDropdown<ParentLanguage>(
            label: "second_language".tr(),
            value: _motherLang2,
            items: _parentLanguages,
            enabled: _editMode,
            itemLabel: (e) => e.parentlang ?? '',
            onChanged: (val) {
              setState(() => _motherLang2 = val);
            },
          ),
          ProfileDropdown<ParentLanguage>(
            label: "third_language".tr(),
            value: _motherLang3,
            items: _parentLanguages,
            enabled: _editMode,
            itemLabel: (e) => e.parentlang ?? '',
            onChanged: (val) {
              setState(() => _motherLang3 = val);
            },
          ),
          EditableField(
            label: "other_language".tr(),
            initialValue: _profile?.motherAutreslang ?? '',
            editMode: _editMode,
          ),
        ]);

      /// ---------- WORK ----------
      case ProfileSection.work:
        return _section("work".tr(), [
          SectionTitle("father_info".tr()),
          ProfileDropdown<jobDomain>(
            label: "area_of_work".tr(),
            value: _selectedFatherDomain,
            items: _jobDomains,
            enabled: _editMode,
            itemLabel: (d) => d.jobdomainEn ?? d.jobdomain ?? '',
            onChanged: (val) {
              setState(() => _selectedFatherDomain = val);
            },
          ),
          EditableField(
            label: "profession".tr(),
            initialValue: _profile?.fatherProfession ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "company_name".tr(),
            initialValue: _profile?.fatherCompany ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "workplace".tr(),
            initialValue: _profile?.fatherWorkplace ?? '',
            editMode: _editMode,
          ),

          SectionTitle("mother_info".tr()),
          ProfileDropdown<jobDomain>(
            label: "area_of_work".tr(),
            value: _selectedMotherDomain,
            items: _jobDomains,
            enabled: _editMode,
            itemLabel: (d) => d.jobdomainEn ?? d.jobdomain ?? '',
            onChanged: (val) {
              setState(() => _selectedMotherDomain = val);
            },
          ),
          EditableField(
            label: "profession".tr(),
            initialValue: _profile?.motherProfession ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "company_name".tr(),
            initialValue: _profile?.motherCompany ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "workplace".tr(),
            initialValue: _profile?.motherWorkplace ?? '',
            editMode: _editMode,
          ),
        ]);

      /// ---------- CONTACT ----------
      case ProfileSection.contact:
        return _section("contact".tr(), [
          SectionTitle("father_info".tr()),
          EditableField(
            label: "email".tr(),
            initialValue: _profile?.fatherEmail ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "home_tel".tr(),
            initialValue: _profile?.fatherHometel ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "cell_phone".tr(),
            initialValue: _profile?.fatherMobile ?? '',
            editMode: _editMode,
          ),

          SectionTitle("mother_info".tr()),
          EditableField(
            label: "email".tr(),
            initialValue: _profile?.motherEmail ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "home_tel".tr(),
            initialValue: _profile?.motherEmail ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "cell_phone".tr(),
            initialValue: _profile?.motherMobile ?? '',
            editMode: _editMode,
          ),

          SectionTitle("responsable_info".tr()),
          EditableField(
            label: "email".tr(),
            initialValue: _profile?.contactEmail ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "cell_phone".tr(),
            initialValue: _profile?.contactMobile ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "password".tr(),
            initialValue: _profile?.parentPwd ?? '',
            editMode: _editMode,
          ),
        ]);

      /// ---------- EMERGENCY ----------
      case ProfileSection.emergency:
        return _section("emergency".tr(), [
          SectionTitle("first_person".tr()),
          EditableField(
            label: "name".tr(),
            initialValue: _profile?.urgentName1 ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "relation".tr(),
            initialValue: _profile?.urgentParentrelation1 ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "home_tel".tr(),
            initialValue: _profile?.urgentTel1 ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "cell_phone".tr(),
            initialValue: _profile?.urgentMobile1 ?? '',
            editMode: _editMode,
          ),

          SectionTitle("second_person".tr()),
          EditableField(
            label: "name".tr(),
            initialValue: _profile?.urgentName2 ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "relation".tr(),
            initialValue: _profile?.urgentParentrelation2 ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "home_tel".tr(),
            initialValue: _profile?.urgentTel2 ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "cell_phone".tr(),
            initialValue: _profile?.urgentMobile2 ?? '',
            editMode: _editMode,
          ),

          SectionTitle("third_person".tr()),
          EditableField(
            label: "name".tr(),
            initialValue: _profile?.urgentName3 ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "relation".tr(),
            initialValue: _profile?.urgentParentrelation3 ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "home_tel".tr(),
            initialValue: _profile?.urgentTel3 ?? '',
            editMode: _editMode,
          ),
          EditableField(
            label: "cell_phone".tr(),
            initialValue: _profile?.urgentMobile3 ?? '',
            editMode: _editMode,
          ),
        ]);
    }
  }

  Widget _section(String title, List<Widget> fields) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.h),
          ...fields,
          SizedBox(height: 40.h),
          Center(
            child: ElevatedButton(
              onPressed: _editMode ? () {} : null,
              child: Text("save".tr()),
            ),
          ),
        ],
      ),
    );
  }
}

/* ========================== SUPPORTING WIDGETS ========================== */

class EditableField extends StatefulWidget {
  final String label;
  final String initialValue;
  final bool editMode;
  final bool canEdit; // 👈 NEW

  const EditableField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.editMode,
    this.canEdit = true,
  });

  @override
  State<EditableField> createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditable = widget.editMode && widget.canEdit;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.label,
                style: TextStyle(fontSize: 13.sp, color: Colors.grey),
              ),
              if (!widget.canEdit)
                Padding(
                  padding: EdgeInsets.only(left: 6.w),
                  child: Icon(Icons.lock, size: 14.sp, color: Colors.grey),
                ),
            ],
          ),
          SizedBox(height: 6.h),
          isEditable
              ? TextFormField(
                controller: _controller,
                decoration: const InputDecoration(border: InputBorder.none),
              )
              : Text(
                _controller.text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: widget.canEdit ? Colors.black : Colors.grey.shade600,
                ),
              ),
          const Divider(),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}

enum ProfileSection { general, contact, work, education, emergency }

extension ProfileSectionIcon on ProfileSection {
  IconData get icon {
    switch (this) {
      case ProfileSection.general:
        return Icons.person;
      case ProfileSection.contact:
        return Icons.phone;
      case ProfileSection.work:
        return Icons.work;
      case ProfileSection.education:
        return Icons.school;
      case ProfileSection.emergency:
        return Icons.warning;
    }
  }
}

class ProfileDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final bool enabled;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;

  const ProfileDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.enabled,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
          SizedBox(height: 6.h),
          enabled
              ? DropdownButtonFormField<T>(
                value: value,
                items:
                    items
                        .map(
                          (e) => DropdownMenuItem<T>(
                            value: e,
                            child: Text(itemLabel(e)),
                          ),
                        )
                        .toList(),
                onChanged: onChanged,
                decoration: const InputDecoration(border: InputBorder.none),
              )
              : Text(
                value != null ? itemLabel(value!) : '',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
          const Divider(),
        ],
      ),
    );
  }
}

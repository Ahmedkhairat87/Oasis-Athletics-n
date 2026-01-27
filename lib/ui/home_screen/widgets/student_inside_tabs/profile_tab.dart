// lib/ui/student_inside_tabs/profile_tab.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/core/model/stdLinks/StdFullData.dart';
import '../../../../core/colors_Manager.dart';

// reusable imports
import '../../../../core/reusable_components/profile_tab_conditional_switch.dart';
import '../../../../core/reusable_components/profile_tab_golden_card.dart';
import '../../../../core/reusable_components/profile_tab_labeled_text_field.dart';
import '../../../../core/reusable_components/profile_tab_section_title.dart';
import '../../../../core/reusable_components/profile_tab_read_only_field.dart';

class ProfileTab extends StatefulWidget {
  final StdFullData student; // 👈 البيانات الجاية من API

  const ProfileTab({super.key, required this.student});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

const String _empty = '—';

String _displayText(String? v) {
  final s = (v ?? '').trim();
  if (s.isEmpty || s.toLowerCase() == 'null') return _empty;
  return s;
}

String _displayNum(String? v, {bool treatZeroAsEmpty = false}) {
  final s = (v ?? '').trim();
  if (s.isEmpty || s.toLowerCase() == 'null') return _empty;

  if (treatZeroAsEmpty) {
    final n = num.tryParse(s);
    if (n != null && n == 0) return _empty;
  }
  return s;
}

class _ProfileTabState extends State<ProfileTab> {
  // Student info (kept as controllers as a data source; not used as editable inside student info)
  final _nameController = TextEditingController();
  final _gradeController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _schoolYearController = TextEditingController();
  final _birthDateController = TextEditingController();

  // Contact info controllers (editable)
  final _emailController = TextEditingController();
  final _fatherMobileController = TextEditingController();
  final _motherMobileController = TextEditingController();
  final _contactMobileController = TextEditingController();
  final _fatherAddressController = TextEditingController();
  final _motherAddressController = TextEditingController();

  // Emergency contacts (3)
  final _emergencyName = TextEditingController();
  final _emergencyMobile = TextEditingController();
  final _emergencyRelation = TextEditingController();

  // Medical
  String _bloodGroup = "";
  bool _hasAllergies = false;
  final _allergyDetailsController = TextEditingController();
  bool _pastInjuries = false;
  bool _anySurgery = false;
  final _surgeryDetailsController = TextEditingController();

  // Sports & plan
  final _subscriptionPlanController = TextEditingController();
  final _athleticProgramController = TextEditingController();
  final _primarySportController = TextEditingController();
  final _secondarySportController = TextEditingController();

  // ✅ Blood group list (same UI - just extracted)
  static const List<String> _bloodItems = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  // ✅ Safe bool converter: supports bool/num/string (true/false/1/0/yes/no/y/n)
  bool _toBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is num) return v != 0;

    final s = v.toString().trim().toLowerCase();
    return s == 'true' || s == '1' || s == 'yes' || s == 'y';
  }

  // ✅ Convert any value to a clean string (avoids "null")
  String _toText(dynamic v) {
    if (v == null) return '';
    final s = v.toString();
    if (s.trim().toLowerCase() == 'null') return '';
    return s;
  }

  // ✅ Converts numeric values to a clean string (no "null")
  String _numText(dynamic v) {
    if (v == null) return '';
    if (v is num) {
      // keep as-is; you can format if needed later
      return v.toString();
    }
    final s = v.toString().trim();
    if (s.toLowerCase() == 'null') return '';
    return s;
  }

  // ✅ Dropdown value must be either null OR one of items (otherwise Dropdown throws)
  String? _safeDropdownValue(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return null;
    return _bloodItems.contains(s) ? s : null;
  }

  @override
  void initState() {
    super.initState();

    // Fill read-only info (safe)
    _nameController.text = _toText(widget.student.stdFirstname);
    _gradeController.text = _toText(widget.student.gradeDesc);
    _ageController.text = _numText(widget.student.ageYears);
    _weightController.text = _numText(widget.student.weightKG);
    _heightController.text = _numText(widget.student.heightCM);
    _schoolYearController.text = _toText(widget.student.schoolYear);
    _birthDateController.text = _toText(widget.student.stdBirthdate);

    // Contact info
    _emailController.text = _toText(widget.student.stdEmail);
    _fatherMobileController.text = _toText(widget.student.fatherMobile);
    _motherMobileController.text = _toText(widget.student.motherMobile);
    _contactMobileController.text = _toText(widget.student.contactMobile);
    _fatherAddressController.text = _toText(widget.student.fatherAddress);
    _motherAddressController.text = _toText(widget.student.motherAddress);

    // Medical
    _bloodGroup = _toText(widget.student.groupeblood);

    // ✅ allergies might be String/Bool/Num — handle safely
    final allergiesValue = widget.student.allergies;

    _hasAllergies = _toBool(allergiesValue);

    // If allergies is a text details, show it; otherwise empty
    _allergyDetailsController.text =
        allergiesValue is String ? _toText(allergiesValue) : '';

    // ✅ These fields may NOT exist in your model (or may be String)
    // If they don't exist in StdFullData, just keep them false and don't crash.
    // NOTE: If your StdFullData doesn't contain these, remove/keep as false as below.
    try {
      // ignore: unnecessary_cast
      final dynamic past = (widget.student as dynamic).pastInjuries;
      _pastInjuries = _toBool(past);
    } catch (_) {
      _pastInjuries = false;
    }

    try {
      // ignore: unnecessary_cast
      final dynamic surg = (widget.student as dynamic).anySurgery;
      _anySurgery = _toBool(surg);
    } catch (_) {
      _anySurgery = false;
    }

    try {
      // ignore: unnecessary_cast
      final dynamic surgDetails = (widget.student as dynamic).surgeryDetails;
      _surgeryDetailsController.text =
          surgDetails is String ? _toText(surgDetails) : '';
    } catch (_) {
      _surgeryDetailsController.text = '';
    }

    // Sports (leave as is)
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gradeController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _schoolYearController.dispose();
    _birthDateController.dispose();

    _emailController.dispose();
    _fatherMobileController.dispose();
    _motherMobileController.dispose();
    _contactMobileController.dispose();
    _fatherAddressController.dispose();
    _motherAddressController.dispose();

    _emergencyName.dispose();
    _emergencyMobile.dispose();
    _emergencyRelation.dispose();

    _allergyDetailsController.dispose();
    _surgeryDetailsController.dispose();

    _subscriptionPlanController.dispose();
    _athleticProgramController.dispose();
    _primarySportController.dispose();
    _secondarySportController.dispose();

    super.dispose();
  }

  // multicolor chip helper (visual only, re-themed)
  Widget _goldChip(BuildContext context, String text) {
    final Color primaryBlue =
        Theme.of(context).brightness == Brightness.light
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSky = ColorsManager.accentSky;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999.r),
          gradient: LinearGradient(
            colors: [
              primaryBlue.withOpacity(0.12),
              accentMint.withOpacity(0.18),
              accentSky.withOpacity(0.14),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: primaryBlue.withOpacity(0.7), width: 0.8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }

  // small read-only chips row (age / weight / height)
  Widget _readOnlyChips(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _goldChip(context, _ageController.text),
        _goldChip(context, _weightController.text),
        _goldChip(context, _heightController.text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color primaryBlue =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentPurple = ColorsManager.accentPurple;
    final Color accentCoral = ColorsManager.accentCoral;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.96, end: 1.0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          final double safe = value.clamp(0.0, 1.0);

          return Opacity(
            opacity: safe,
            child: Transform.translate(
              offset: Offset(0, (1 - safe) * 12),
              child: child,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Student information (READ-ONLY)
             SectionTitle('student_information'.tr()),
            _animatedSection(
              delayMs: 0,
              child: GoldCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.95, end: 1.0),
                                duration: const Duration(milliseconds: 260),
                                curve: Curves.easeOutBack,
                                builder: (context, v, child) {
                                  return Transform.scale(
                                    scale: v,
                                    alignment: Alignment.centerLeft,
                                    child: child,
                                  );
                                },
                                child: Text(
                                  _nameController.text,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: primaryBlue,
                                  ),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              ReadOnlyField(
                                label: 'grade'.tr(),
                                value: _gradeController.text,
                                preferredLabelWidth: 88,
                              ),
                              SizedBox(height: 6.h),
                              ReadOnlyField(
                                label: 'school_year'.tr(),
                                value: _schoolYearController.text,
                                preferredLabelWidth: 110,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.more_vert, color: accentPurple),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _readOnlyChips(context),
                    SizedBox(height: 10.h),
                    ReadOnlyField(
                      label: 'birth_date'.tr(),
                      value: _birthDateController.text,
                      preferredLabelWidth: 110,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // 2. Contact information (editable)
             SectionTitle('contact_information'.tr()),
            _animatedSection(
              delayMs: 60,
              child: GoldCard(
                child: Column(
                  children: [
                    LabeledTextField(
                      controller: _emailController,
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            controller: _fatherMobileController,
                            hint: 'father_mobile'.tr(),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: LabeledTextField(
                            controller: _motherMobileController,
                            hint: 'mother_mobile'.tr(),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    LabeledTextField(
                      controller: _contactMobileController,
                      hint: 'contact_mobile'.tr(),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 12.h),
                    Column(crossAxisAlignment: CrossAxisAlignment.start),
                    SizedBox(height: 6.h),
                    LabeledTextField(
                      controller: _fatherAddressController,
                      hint: 'father_address'.tr(),
                    ),
                    SizedBox(height: 8.h),
                    LabeledTextField(
                      controller: _motherAddressController,
                      hint: 'mother_address'.tr(),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // 3. Medical information (editable)
             SectionTitle('medical_information'.tr()),
            _animatedSection(
              delayMs: 120,
              child: GoldCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'blood_group'.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: primaryBlue,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            gradient: LinearGradient(
                              colors: [
                                accentMint.withOpacity(0.18),
                                accentSky.withOpacity(0.16),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              // ✅ safe: must be null or one of items
                              value: _safeDropdownValue(_bloodGroup),
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: primaryBlue,
                              ),
                              items:
                                  _bloodItems
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (v) => setState(() {
                                    _bloodGroup = (v ?? _bloodGroup);
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    ConditionalSwitch(
                      label: 'pAllergies'.tr(),
                      value: _hasAllergies,
                      onChanged: (v) => setState(() => _hasAllergies = v),
                      child: LabeledTextField(
                        controller: _allergyDetailsController,
                        hint: 'allergy_details'.tr(),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    ConditionalSwitch(
                      label: 'pPast_injuries'.tr(),
                      value: _pastInjuries,
                      onChanged: (v) => setState(() => _pastInjuries = v),
                    ),
                    SizedBox(height: 10.h),

                    ConditionalSwitch(
                      label: 'any_surgery'.tr(),
                      value: _anySurgery,
                      onChanged: (v) => setState(() => _anySurgery = v),
                      child: LabeledTextField(
                        controller: _surgeryDetailsController,
                        hint: 'surgery_details'.tr(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // 4. Sports & Plan (editable)
             SectionTitle('sports_plan'.tr()),
            _animatedSection(
              delayMs: 180,
              child: GoldCard(
                child: Column(
                  children: [
                    LabeledTextField(
                      controller: _subscriptionPlanController,
                      hint: 'subscription_plan'.tr(),
                    ),
                    SizedBox(height: 8.h),
                    LabeledTextField(
                      controller: _athleticProgramController,
                      hint: 'athletic_program'.tr(),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            controller: _primarySportController,
                            hint: 'primary_sport'.tr(),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: LabeledTextField(
                            controller: _secondarySportController,
                            hint: 'secondary_sport'.tr(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            _animatedSection(
              delayMs: 220,
              child: Row(
                children: [
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.94, end: 1.0),
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentCoral,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _onSave,
                        child: Text(
                          'Save'.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _animatedSection({required int delayMs, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1.0),
      duration: Duration(milliseconds: 260 + delayMs),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        final double safe = value.clamp(0.0, 1.0);
        return Opacity(
          opacity: safe,
          child: Transform.translate(
            offset: Offset(0, (1 - safe) * 10),
            child: child,
          ),
        );
      },
    );
  }

  void _onSave() {
    final Color snackColor = ColorsManager.accentMint;
    final snack = SnackBar(
      backgroundColor: snackColor,
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8.w),
           Text('profile_saved'.tr(), style: TextStyle(color: Colors.white)),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}

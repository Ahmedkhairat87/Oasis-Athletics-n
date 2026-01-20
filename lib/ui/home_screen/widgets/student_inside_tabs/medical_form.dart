// lib/ui/home_screen/widgets/student_inside_tabs/medical_form.dart
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/colors_Manager.dart';
import '../../../../core/medical_constants.dart';
import '../../../../core/model/stdLinks/medicalFormData/MedicalFormDataResponse.dart';
import '../../../../core/reusable_components/app_background.dart';

// ✅ required for API call
import '../../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../../core/services/stdProfile/medicalForm/StdMedicalFormService.dart';

/// Full medical form implementing the fields requested by the user.
/// Read-only until user taps Edit. Supports Cancel (restore) and Save.
class MedicalForm extends StatefulWidget {
  const MedicalForm({super.key});

  @override
  State<MedicalForm> createState() => _MedicalFormState();
}

class _MedicalFormState extends State<MedicalForm> {
  final _formKey = GlobalKey<FormState>();

  // ✅ NEW (no UI layout change – just state)
  bool _loading = true;
  String? _error;
  MedicalFormDataResponse? _apiData;

  // Basic info
  DateTime? _lastUpdate; // will show last update date/time

  // Edit mode flag
  bool _isEditing = false;

  // Backup storage for cancel
  final Map<String, dynamic> _backup = {};

  // Blood group radio
  String? _bloodGroup;

  // Allergies
  bool _hasAllergies = false;

  // ✅ Will be populated from API lists (PopulateAllergies)
  final Map<String, bool> _knownAllergies = {
    for (var k in MedicalConstants.allergies) k: false,
  };

  final TextEditingController _typeOfAllergyController =
      TextEditingController();
  final TextEditingController _severityController = TextEditingController();
  final TextEditingController _specificTreatmentController =
      TextEditingController();
  final TextEditingController _otherAllergyController = TextEditingController();

  // Chronic conditions
  final TextEditingController _chronicConditionsController =
      TextEditingController();
  final TextEditingController _chronicTreatmentController =
      TextEditingController();
  final TextEditingController _chronicEmergencyController =
      TextEditingController();

  // Past surgeries / hospitalizations
  final TextEditingController _pastSurgeryController = TextEditingController();
  final TextEditingController _hospitalizationReasonController =
      TextEditingController();
  final TextEditingController _hospitalizationDatesController =
      TextEditingController();

  // Family medical history
  final TextEditingController _familyHistoryController =
      TextEditingController();

  // Current medications - dynamic list
  final List<Map<String, TextEditingController>> _medications = [];

  // Immunization
  DateTime? _lastImmunizationDate;
  final TextEditingController _vaccinesReceivedController =
      TextEditingController();

  // Vision & hearing
  final TextEditingController _visionProblemsController =
      TextEditingController();
  DateTime? _lastEyeExam;
  bool _visionProblemNo = false;
  bool _visionProblemYes = false;

  final TextEditingController _hearingProblemsController =
      TextEditingController();
  DateTime? _lastHearingTest;
  bool _hearingProblemNo = false;
  bool _hearingProblemYes = false;

  // Physical activity & sports
  final TextEditingController _activityLimitationsController =
      TextEditingController();
  final TextEditingController _sportsParticipationController =
      TextEditingController();
  final TextEditingController _specialEquipmentController =
      TextEditingController();

  // Mental & behavioral
  final TextEditingController _mentalHistoryController =
      TextEditingController();
  final TextEditingController _diagnosedConditionsController =
      TextEditingController();
  final TextEditingController _therapyMedicationController =
      TextEditingController();
  final TextEditingController _behavioralConcernsController =
      TextEditingController();
  final TextEditingController _supportNeededController =
      TextEditingController();

  // Dietary restrictions
  final TextEditingController _specialDietController = TextEditingController();
  final TextEditingController _foodAllergiesController =
      TextEditingController();

  // Past injuries & surgeries (checkbox lists)
  // ✅ Will be populated from API lists (PopulateInjuries)
  final Map<String, bool> _pastInjuries = {
    for (var k in MedicalConstants.pastInjuryTypes) k: false,
  };
  bool _pastInjuryNone = false;
  bool _pastInjuryYes = false;
  final TextEditingController _pastInjuriesOtherController =
      TextEditingController();

  // ✅ Will be populated from API lists (PopulateSurgeries)
  final Map<String, bool> _surgeries = {
    for (var k in MedicalConstants.surgeryTypes) k: false,
  };
  bool _surgeriesNone = false;
  bool _surgeriesYes = false;
  final TextEditingController _surgeriesOtherController =
      TextEditingController();

  // Date pickers helpers
  Future<void> _pickDate(
    BuildContext context,
    ValueSetter<DateTime?> onPicked, {
    DateTime? initial,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(now.year - 30),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) onPicked(picked);
  }

  // ===================== API Helpers =====================
  bool _toBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is num) return v != 0;
    final s = v.toString().trim().toLowerCase();
    return s == 'true' || s == '1' || s == 'yes' || s == 'y';
  }

  DateTime? _tryParseDate(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'null') return null;
    return DateTime.tryParse(s);
  }

  // ✅ token resolver (عدل الاسم لو عندك مختلف)

  Future<void> loadMedicalForm() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final stdId = studentNotifier.value.stdId.toString();

    final data = await StdMedicalFormService.getMedicalForm(
      //token: token,
      stdId: studentNotifier.value.stdId.toString(),
    );

    if (!mounted) return;

    if (data == null) {
      setState(() {
        _loading = false;
        _error = 'Failed to load medical form.';
      });
      return;
    }

    setState(() {
      _apiData = data;
      _loading = false;
    });

    _assignApiToUi(data);
  }

  /// ✅ Put API data into the SAME variables/controllers that UI reads
  void _assignApiToUi(MedicalFormDataResponse data) {
    final form =
    (data.stdMedicalFormData != null &&
        data.stdMedicalFormData!.isNotEmpty)
        ? data.stdMedicalFormData!.first
        : null;

    if (form == null) return;

    setState(() {
      _bloodGroup = form.bloodGroupName;

      _hasAllergies = form.hasAllergies ?? false;
      _typeOfAllergyController.text = form.allergyType ?? '';
      _severityController.text = form.allergySeverity ?? '';
      _specificTreatmentController.text = form.allergyTreatment ?? '';
      _otherAllergyController.text = form.allergyOther ?? '';

      _chronicConditionsController.text = form.chronicConditions ?? '';
      _chronicTreatmentController.text = form.treatmentPlan ?? '';
      _chronicEmergencyController.text = form.emergencyProtocols ?? '';

      _pastSurgeryController.text = form.surgeryTypeDate ?? '';
      _hospitalizationReasonController.text =
          form.hospitalizationReason ?? '';
      _hospitalizationDatesController.text =
          form.hospitalizationDates ?? '';

      _familyHistoryController.text = form.familyHistory ?? '';

      _vaccinesReceivedController.text = form.vaccinesReceived ?? '';

      _visionProblemsController.text = form.visionProblems ?? '';
      _hearingProblemsController.text =
      (form.hearingProblems == true) ? 'Yes' : 'No';

      _activityLimitationsController.text =
          form.physicalLimitations ?? '';
      _sportsParticipationController.text =
          form.sportsLimitations ?? '';
      _specialEquipmentController.text =
          form.specialEquipment ?? '';

      _mentalHistoryController.text =
          form.mentalHealthHistory ?? '';
      _diagnosedConditionsController.text =
          form.diagnosedConditions ?? '';
      _therapyMedicationController.text =
          form.medicationOrTherapy ?? '';
      _behavioralConcernsController.text =
          form.behavioralConcerns ?? '';
      _supportNeededController.text =
          form.supportNeeded ?? '';

      _specialDietController.text = form.specialDiet ?? '';
      _foodAllergiesController.text = form.foodAllergies ?? '';

      _lastUpdate = DateTime.tryParse(form.createdAt ?? '');
    });
  }
  // ===================== original lifecycle =====================
  @override
  void initState() {
    super.initState();
    // init with one medication row by default (as before)
    _addMedicationRow();
    // load from API
    loadMedicalForm();
  }

  @override
  void dispose() {
    _typeOfAllergyController.dispose();
    _severityController.dispose();
    _specificTreatmentController.dispose();
    _otherAllergyController.dispose();
    _chronicConditionsController.dispose();
    _chronicTreatmentController.dispose();
    _chronicEmergencyController.dispose();
    _pastSurgeryController.dispose();
    _hospitalizationReasonController.dispose();
    _hospitalizationDatesController.dispose();
    _familyHistoryController.dispose();
    _vaccinesReceivedController.dispose();
    _visionProblemsController.dispose();
    _hearingProblemsController.dispose();
    _activityLimitationsController.dispose();
    _sportsParticipationController.dispose();
    _specialEquipmentController.dispose();
    _mentalHistoryController.dispose();
    _diagnosedConditionsController.dispose();
    _therapyMedicationController.dispose();
    _behavioralConcernsController.dispose();
    _supportNeededController.dispose();
    _specialDietController.dispose();
    _foodAllergiesController.dispose();
    _pastInjuriesOtherController.dispose();
    _surgeriesOtherController.dispose();
    for (final row in _medications) {
      row['name']?.dispose();
      row['dosage']?.dispose();
      row['freq']?.dispose();
    }
    super.dispose();
  }

  void _addMedicationRow() {
    setState(() {
      _medications.add({
        'name': TextEditingController(),
        'dosage': TextEditingController(),
        'freq': TextEditingController(),
      });
    });
  }

  void _removeMedicationRow(int index) {
    setState(() {
      _medications[index]['name']?.dispose();
      _medications[index]['dosage']?.dispose();
      _medications[index]['freq']?.dispose();
      _medications.removeAt(index);
    });
  }

  // ------------------- BACKUP & RESTORE -------------------
  void _backupValues() {
    _backup.clear();
    _backup['lastUpdate'] = _lastUpdate?.toIso8601String();
    _backup['bloodGroup'] = _bloodGroup;
    _backup['hasAllergies'] = _hasAllergies;
    _backup['knownAllergies'] = Map<String, bool>.from(_knownAllergies);
    _backup['typeOfAllergy'] = _typeOfAllergyController.text;
    _backup['severity'] = _severityController.text;
    _backup['specificTreatment'] = _specificTreatmentController.text;
    _backup['otherAllergy'] = _otherAllergyController.text;

    _backup['chronicConditions'] = _chronicConditionsController.text;
    _backup['chronicTreatment'] = _chronicTreatmentController.text;
    _backup['chronicEmergency'] = _chronicEmergencyController.text;

    _backup['pastSurgery'] = _pastSurgeryController.text;
    _backup['hospitalizationReason'] = _hospitalizationReasonController.text;
    _backup['hospitalizationDates'] = _hospitalizationDatesController.text;

    _backup['familyHistory'] = _familyHistoryController.text;

    _backup['medications'] =
        _medications
            .map(
              (m) => {
                'name': (m['name'] as TextEditingController).text,
                'dosage': (m['dosage'] as TextEditingController).text,
                'freq': (m['freq'] as TextEditingController).text,
              },
            )
            .toList();

    _backup['lastImmunizationDate'] = _lastImmunizationDate?.toIso8601String();
    _backup['vaccinesReceived'] = _vaccinesReceivedController.text;

    _backup['visionProblems'] = _visionProblemsController.text;
    _backup['lastEyeExam'] = _lastEyeExam?.toIso8601String();
    _backup['visionProblemNo'] = _visionProblemNo;
    _backup['visionProblemYes'] = _visionProblemYes;

    _backup['hearingProblems'] = _hearingProblemsController.text;
    _backup['lastHearingTest'] = _lastHearingTest?.toIso8601String();
    _backup['hearingProblemNo'] = _hearingProblemNo;
    _backup['hearingProblemYes'] = _hearingProblemYes;

    _backup['activityLimitations'] = _activityLimitationsController.text;
    _backup['sportsParticipation'] = _sportsParticipationController.text;
    _backup['specialEquipment'] = _specialEquipmentController.text;

    _backup['mentalHistory'] = _mentalHistoryController.text;
    _backup['diagnosedConditions'] = _diagnosedConditionsController.text;
    _backup['therapyMedication'] = _therapyMedicationController.text;
    _backup['behavioralConcerns'] = _behavioralConcernsController.text;
    _backup['supportNeeded'] = _supportNeededController.text;

    _backup['specialDiet'] = _specialDietController.text;
    _backup['foodAllergies'] = _foodAllergiesController.text;

    _backup['pastInjuryNone'] = _pastInjuryNone;
    _backup['pastInjuryYes'] = _pastInjuryYes;
    _backup['pastInjuries'] = Map<String, bool>.from(_pastInjuries);
    _backup['pastInjuriesOther'] = _pastInjuriesOtherController.text;

    _backup['surgeriesNone'] = _surgeriesNone;
    _backup['surgeriesYes'] = _surgeriesYes;
    _backup['surgeries'] = Map<String, bool>.from(_surgeries);
    _backup['surgeriesOther'] = _surgeriesOtherController.text;
  }

  void _restoreBackup() {
    setState(() {
      _lastUpdate =
          _backup['lastUpdate'] != null
              ? DateTime.tryParse(_backup['lastUpdate'])
              : null;
      _bloodGroup = _backup['bloodGroup'];
      _hasAllergies = _backup['hasAllergies'] ?? false;

      final known =
          (_backup['knownAllergies'] as Map?)?.cast<String, bool>() ?? {};
      _knownAllergies.clear();
      for (var k in MedicalConstants.allergies) {
        _knownAllergies[k] = known[k] ?? false;
      }

      _typeOfAllergyController.text = _backup['typeOfAllergy'] ?? '';
      _severityController.text = _backup['severity'] ?? '';
      _specificTreatmentController.text = _backup['specificTreatment'] ?? '';
      _otherAllergyController.text = _backup['otherAllergy'] ?? '';

      _chronicConditionsController.text = _backup['chronicConditions'] ?? '';
      _chronicTreatmentController.text = _backup['chronicTreatment'] ?? '';
      _chronicEmergencyController.text = _backup['chronicEmergency'] ?? '';

      _pastSurgeryController.text = _backup['pastSurgery'] ?? '';
      _hospitalizationReasonController.text =
          _backup['hospitalizationReason'] ?? '';
      _hospitalizationDatesController.text =
          _backup['hospitalizationDates'] ?? '';

      _familyHistoryController.text = _backup['familyHistory'] ?? '';

      final meds = (_backup['medications'] as List?)?.cast<Map>() ?? [];
      for (final row in _medications) {
        row['name']?.dispose();
        row['dosage']?.dispose();
        row['freq']?.dispose();
      }
      _medications.clear();
      for (final m in meds) {
        _medications.add({
          'name': TextEditingController(text: m['name'] ?? ''),
          'dosage': TextEditingController(text: m['dosage'] ?? ''),
          'freq': TextEditingController(text: m['freq'] ?? ''),
        });
      }
      if (_medications.isEmpty) _addMedicationRow();

      _lastImmunizationDate =
          _backup['lastImmunizationDate'] != null
              ? DateTime.tryParse(_backup['lastImmunizationDate'])
              : null;
      _vaccinesReceivedController.text = _backup['vaccinesReceived'] ?? '';

      _visionProblemsController.text = _backup['visionProblems'] ?? '';
      _lastEyeExam =
          _backup['lastEyeExam'] != null
              ? DateTime.tryParse(_backup['lastEyeExam'])
              : null;
      _visionProblemNo = _backup['visionProblemNo'] ?? false;
      _visionProblemYes = _backup['visionProblemYes'] ?? false;

      _hearingProblemsController.text = _backup['hearingProblems'] ?? '';
      _lastHearingTest =
          _backup['lastHearingTest'] != null
              ? DateTime.tryParse(_backup['lastHearingTest'])
              : null;
      _hearingProblemNo = _backup['hearingProblemNo'] ?? false;
      _hearingProblemYes = _backup['hearingProblemYes'] ?? false;

      _activityLimitationsController.text =
          _backup['activityLimitations'] ?? '';
      _sportsParticipationController.text =
          _backup['sportsParticipation'] ?? '';
      _specialEquipmentController.text = _backup['specialEquipment'] ?? '';

      _mentalHistoryController.text = _backup['mentalHistory'] ?? '';
      _diagnosedConditionsController.text =
          _backup['diagnosedConditions'] ?? '';
      _therapyMedicationController.text = _backup['therapyMedication'] ?? '';
      _behavioralConcernsController.text = _backup['behavioralConcerns'] ?? '';
      _supportNeededController.text = _backup['supportNeeded'] ?? '';

      _specialDietController.text = _backup['specialDiet'] ?? '';
      _foodAllergiesController.text = _backup['foodAllergies'] ?? '';

      _pastInjuryNone = _backup['pastInjuryNone'] ?? false;
      _pastInjuryYes = _backup['pastInjuryYes'] ?? false;
      final pastMap =
          (_backup['pastInjuries'] as Map?)?.cast<String, bool>() ?? {};
      _pastInjuries.clear();
      for (var k in MedicalConstants.pastInjuryTypes) {
        _pastInjuries[k] = pastMap[k] ?? false;
      }
      _pastInjuriesOtherController.text = _backup['pastInjuriesOther'] ?? '';

      _surgeriesNone = _backup['surgeriesNone'] ?? false;
      _surgeriesYes = _backup['surgeriesYes'] ?? false;
      final surgMap =
          (_backup['surgeries'] as Map?)?.cast<String, bool>() ?? {};
      _surgeries.clear();
      for (var k in MedicalConstants.surgeryTypes) {
        _surgeries[k] = surgMap[k] ?? false;
      }
      _surgeriesOtherController.text = _backup['surgeriesOther'] ?? '';
    });
  }

  void _enterEditMode() {
    _backupValues();
    setState(() => _isEditing = true);
  }

  void _cancelEditMode() {
    _restoreBackup();
    setState(() => _isEditing = false);
  }

  void _saveProfile() {
    _saveData();
    setState(() => _isEditing = false);
  }

  void _saveData() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete required fields'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final meds =
        _medications
            .map(
              (m) => {
                'medication': m['name']?.text.trim(),
                'dosage': m['dosage']?.text.trim(),
                'frequency': m['freq']?.text.trim(),
              },
            )
            .toList();

    final data = {
      'lastUpdate': DateTime.now().toIso8601String(),
      'bloodGroup': _bloodGroup,
      'hasAllergies': _hasAllergies,
      'knownAllergies':
          _knownAllergies.entries
              .where((e) => e.value)
              .map((e) => e.key)
              .toList(),
      'typeOfAllergy': _typeOfAllergyController.text.trim(),
      'severity': _severityController.text.trim(),
      'specificTreatment': _specificTreatmentController.text.trim(),
      'otherAllergy': _otherAllergyController.text.trim(),
      'chronicConditions': _chronicConditionsController.text.trim(),
      'chronicTreatmentPlan': _chronicTreatmentController.text.trim(),
      'chronicEmergencyProtocols': _chronicEmergencyController.text.trim(),
      'pastSurgeries': _pastSurgeryController.text.trim(),
      'reasonHospitalization': _hospitalizationReasonController.text.trim(),
      'hospitalizationDates': _hospitalizationDatesController.text.trim(),
      'familyMedicalHistory': _familyHistoryController.text.trim(),
      'currentMedications': meds,
      'lastImmunizationDate': _lastImmunizationDate?.toIso8601String(),
      'vaccinesReceived': _vaccinesReceivedController.text.trim(),
      'visionProblems': _visionProblemsController.text.trim(),
      'lastEyeExam': _lastEyeExam?.toIso8601String(),
      'visionProblemYes': _visionProblemYes,
      'visionProblemNo': _visionProblemNo,
      'hearingProblems': _hearingProblemsController.text.trim(),
      'lastHearingTest': _lastHearingTest?.toIso8601String(),
      'hearingProblemYes': _hearingProblemYes,
      'hearingProblemNo': _hearingProblemNo,
      'activityLimitations': _activityLimitationsController.text.trim(),
      'sportsParticipationLimitations':
          _sportsParticipationController.text.trim(),
      'specialEquipment': _specialEquipmentController.text.trim(),
      'mentalHistory': _mentalHistoryController.text.trim(),
      'diagnosedConditions': _diagnosedConditionsController.text.trim(),
      'therapyOrMedication': _therapyMedicationController.text.trim(),
      'behavioralConcerns': _behavioralConcernsController.text.trim(),
      'supportNeeded': _supportNeededController.text.trim(),
      'specialDiet': _specialDietController.text.trim(),
      'foodAllergies': _foodAllergiesController.text.trim(),
      'pastInjuryNone': _pastInjuryNone,
      'pastInjuryYes': _pastInjuryYes,
      'pastInjuries':
          _pastInjuries.entries
              .where((e) => e.value)
              .map((e) => e.key)
              .toList(),
      'pastInjuriesOther': _pastInjuriesOtherController.text.trim(),
      'surgeriesNone': _surgeriesNone,
      'surgeriesYes': _surgeriesYes,
      'surgeries':
          _surgeries.entries.where((e) => e.value).map((e) => e.key).toList(),
      'surgeriesOther': _surgeriesOtherController.text.trim(),
    };

    setState(() {
      _lastUpdate = DateTime.now();
    });

    // TODO: hook this to API/local DB
    // ignore: avoid_print
    print('Medical form saved -> payload:\n$data');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medical form saved successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // helper widget builders to keep the build readable:
  Widget _sectionHeader(String title, {String? subtitle}) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
            ),
        ],
      ),
    );
  }

  Widget _smallHint(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
      ),
    );
  }

  Widget _bloodGroupRadios(Color primary) {
    final groups = MedicalConstants.bloodGroups;
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children:
          groups.map((g) {
            final selected = _bloodGroup == g;
            return ChoiceChip(
              label: Text(
                g,
                style: TextStyle(color: selected ? Colors.white : Colors.black),
              ),
              selected: selected,
              onSelected:
                  _isEditing ? (_) => setState(() => _bloodGroup = g) : null,
              selectedColor: primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            );
          }).toList(),
    );
  }

  Widget _checkboxListFromMap(Map<String, bool> items, {bool enabled = true}) {
    return Column(
      children:
          items.keys.map((k) {
            return CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(k, style: TextStyle(fontSize: 13.sp)),
              value: items[k],
              activeColor: ColorsManager.accentMint,
              onChanged:
                  enabled ? (v) => setState(() => items[k] = v ?? false) : null,
            );
          }).toList(),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
      fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.98),
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
    );
  }

  Widget _sectionCard(Widget child, {EdgeInsets? padding}) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color start =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
    final Color end =
        isLight
            ? ColorsManager.primaryGradientEnd
            : ColorsManager.primaryGradientEndDark;

    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [start.withOpacity(0.06), end.withOpacity(0.03)],
        ),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      child: child,
    );
  }

  // wrapper to disable interaction when not editing
  Widget _editableWrapper({required Widget child}) {
    return AbsorbPointer(
      absorbing: !_isEditing,
      child: Opacity(opacity: _isEditing ? 1.0 : 0.98, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color primaryStart =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
    final Color primaryEnd =
        isLight
            ? ColorsManager.primaryGradientEnd
            : ColorsManager.primaryGradientEndDark;

    final lastUpdateDisplay =
        _lastUpdate != null
            ? DateFormat.yMd().add_jms().format(_lastUpdate!)
            : '—';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Child Medical History',
          style: TextStyle(color: Colors.black),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withOpacity(0.85)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.black87),
            onPressed: _isEditing ? _saveProfile : null,
            tooltip: 'Save form',
          ),
        ],
      ),
      body: AppBackground(
        useAppBarBlur: false,
        child: SafeArea(
          top: false,
          bottom: true,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withOpacity(0.86),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.03),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // header row: last update + edit controls
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Last update :',
                                        style: TextStyle(fontSize: 11.sp),
                                      ),
                                      Text(
                                        lastUpdateDisplay,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                if (!_isEditing)
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: ColorsManager.accentPurple,
                                    ),
                                    tooltip: 'Edit',
                                    onPressed: _enterEditMode,
                                  )
                                else ...[
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.redAccent,
                                    ),
                                    tooltip: 'Cancel',
                                    onPressed: _cancelEditMode,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.check,
                                      color: ColorsManager.accentMint,
                                    ),
                                    tooltip: 'Save',
                                    onPressed: _saveProfile,
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 12.h),

                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Blood group
                                    _sectionHeader('Blood Group'),
                                    _editableWrapper(
                                      child: _sectionCard(
                                        _bloodGroupRadios(primaryStart),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 10.h,
                                        ),
                                      ),
                                    ),

                                    // Allergies
                                    _sectionHeader('1. Allergies'),
                                    _editableWrapper(
                                      child: _sectionCard(
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Does the child have allergies?',
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                ChoiceChip(
                                                  label: const Text('No'),
                                                  selected: !_hasAllergies,
                                                  onSelected:
                                                      !_isEditing
                                                          ? null
                                                          : (_) => setState(
                                                            () =>
                                                                _hasAllergies =
                                                                    false,
                                                          ),
                                                  selectedColor:
                                                      ColorsManager.accentMint,
                                                  backgroundColor:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.surface,
                                                ),
                                                SizedBox(width: 8.w),
                                                ChoiceChip(
                                                  label: const Text('Yes'),
                                                  selected: _hasAllergies,
                                                  onSelected:
                                                      !_isEditing
                                                          ? null
                                                          : (_) => setState(
                                                            () =>
                                                                _hasAllergies =
                                                                    true,
                                                          ),
                                                  selectedColor:
                                                      ColorsManager.accentCoral,
                                                  backgroundColor:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.surface,
                                                ),
                                              ],
                                            ),
                                            if (_hasAllergies) ...[
                                              SizedBox(height: 8.h),
                                              Text(
                                                'Known Allergies (select any):',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              _checkboxListFromMap(
                                                _knownAllergies,
                                                enabled: _isEditing,
                                              ),
                                              SizedBox(height: 8.h),
                                              TextFormField(
                                                controller:
                                                    _typeOfAllergyController,
                                                decoration: _inputDecoration(
                                                  'Type of Allergy',
                                                ),
                                              ),
                                              SizedBox(height: 8.h),
                                              TextFormField(
                                                controller: _severityController,
                                                decoration: _inputDecoration(
                                                  'Severity',
                                                ),
                                              ),
                                              SizedBox(height: 8.h),
                                              TextFormField(
                                                controller:
                                                    _specificTreatmentController,
                                                decoration: _inputDecoration(
                                                  'Specific Treatment or Medication',
                                                ),
                                                maxLines: 2,
                                              ),
                                              SizedBox(height: 8.h),
                                              TextFormField(
                                                controller:
                                                    _otherAllergyController,
                                                decoration: _inputDecoration(
                                                  'If other (describe)',
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Chronic conditions
                                    _sectionHeader('2. Chronic Conditions'),
                                    _editableWrapper(
                                      child: _sectionCard(
                                        Column(
                                          children: [
                                            TextFormField(
                                              controller:
                                                  _chronicConditionsController,
                                              decoration: _inputDecoration(
                                                'Condition(s)',
                                              ),
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 8.h),
                                            TextFormField(
                                              controller:
                                                  _chronicTreatmentController,
                                              decoration: _inputDecoration(
                                                'Treatment / Management Plan',
                                              ),
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 8.h),
                                            TextFormField(
                                              controller:
                                                  _chronicEmergencyController,
                                              decoration: _inputDecoration(
                                                'Emergency Protocols (if any)',
                                              ),
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Past surgeries / hospitalization
                                    _sectionHeader(
                                      '3. Past Surgeries / Procedures',
                                    ),
                                    _editableWrapper(
                                      child: _sectionCard(
                                        Column(
                                          children: [
                                            TextFormField(
                                              controller:
                                                  _pastSurgeryController,
                                              decoration: _inputDecoration(
                                                'Surgery Type & Date',
                                              ),
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 8.h),
                                            TextFormField(
                                              controller:
                                                  _hospitalizationReasonController,
                                              decoration: _inputDecoration(
                                                'Reason for Hospitalization',
                                              ),
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 8.h),
                                            TextFormField(
                                              controller:
                                                  _hospitalizationDatesController,
                                              decoration: _inputDecoration(
                                                'Date(s)',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Family medical history
                                    _sectionHeader('4. Family Medical History'),
                                    _editableWrapper(
                                      child: _sectionCard(
                                        TextFormField(
                                          controller: _familyHistoryController,
                                          decoration: _inputDecoration(
                                            'Relevant Family Medical History',
                                          ),
                                          maxLines: 3,
                                        ),
                                      ),
                                    ),

                                    // Current medications dynamic rows
                                    _sectionHeader('5. Current Medications'),
                                    _editableWrapper(
                                      child: _sectionCard(
                                        Column(
                                          children: [
                                            _smallHint(
                                              'Add medications the child is taking (Medication / Dosage / Frequency)',
                                            ),
                                            for (
                                              var i = 0;
                                              i < _medications.length;
                                              i++
                                            )
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: 8.h,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: TextFormField(
                                                        controller:
                                                            _medications[i]['name'],
                                                        decoration:
                                                            _inputDecoration(
                                                              'Medication',
                                                            ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Expanded(
                                                      flex: 3,
                                                      child: TextFormField(
                                                        controller:
                                                            _medications[i]['dosage'],
                                                        decoration:
                                                            _inputDecoration(
                                                              'Dosage',
                                                            ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Expanded(
                                                      flex: 3,
                                                      child: TextFormField(
                                                        controller:
                                                            _medications[i]['freq'],
                                                        decoration:
                                                            _inputDecoration(
                                                              'Frequency',
                                                            ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons
                                                                .delete_outline,
                                                          ),
                                                          onPressed:
                                                              _isEditing &&
                                                                      _medications
                                                                              .length >
                                                                          1
                                                                  ? () =>
                                                                      _removeMedicationRow(
                                                                        i,
                                                                      )
                                                                  : null,
                                                          tooltip: 'Remove',
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: TextButton.icon(
                                                onPressed:
                                                    _isEditing
                                                        ? _addMedicationRow
                                                        : null,
                                                icon: const Icon(Icons.add),
                                                label: const Text(
                                                  'Add medication',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Immunization record
                                    _sectionHeader('6. Immunization Record'),
                                    _editableWrapper(
                                      child: _sectionCard(
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap:
                                                        _isEditing
                                                            ? () => _pickDate(
                                                              context,
                                                              (d) => setState(
                                                                () =>
                                                                    _lastImmunizationDate =
                                                                        d,
                                                              ),
                                                              initial:
                                                                  _lastImmunizationDate,
                                                            )
                                                            : null,
                                                    child: InputDecorator(
                                                      decoration: _inputDecoration(
                                                        'Date of Last Immunization',
                                                      ),
                                                      child: Text(
                                                        _lastImmunizationDate !=
                                                                null
                                                            ? DateFormat.yMMMd()
                                                                .format(
                                                                  _lastImmunizationDate!,
                                                                )
                                                            : 'Select date',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.h),
                                            TextFormField(
                                              controller:
                                                  _vaccinesReceivedController,
                                              decoration: _inputDecoration(
                                                'Vaccines Received',
                                              ),
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Vision & Hearing
                                    _sectionHeader('7. Vision & Hearing'),
                                    _editableWrapper(
                                      child: _sectionCard(
                                        Column(
                                          children: [
                                            TextFormField(
                                              controller:
                                                  _visionProblemsController,
                                              decoration: _inputDecoration(
                                                'Vision Problems',
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap:
                                                        _isEditing
                                                            ? () => _pickDate(
                                                              context,
                                                              (d) => setState(
                                                                () =>
                                                                    _lastEyeExam =
                                                                        d,
                                                              ),
                                                              initial:
                                                                  _lastEyeExam,
                                                            )
                                                            : null,
                                                    child: InputDecorator(
                                                      decoration:
                                                          _inputDecoration(
                                                            'Last Eye Exam Date',
                                                          ),
                                                      child: Text(
                                                        _lastEyeExam != null
                                                            ? DateFormat.yMMMd()
                                                                .format(
                                                                  _lastEyeExam!,
                                                                )
                                                            : 'dd/mm/yyyy',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                ToggleButtons(
                                                  isSelected: [
                                                    _visionProblemNo,
                                                    _visionProblemYes,
                                                  ],
                                                  onPressed:
                                                      !_isEditing
                                                          ? null
                                                          : (idx) {
                                                            setState(() {
                                                              if (idx == 0) {
                                                                _visionProblemNo =
                                                                    true;
                                                                _visionProblemYes =
                                                                    false;
                                                              } else {
                                                                _visionProblemYes =
                                                                    true;
                                                                _visionProblemNo =
                                                                    false;
                                                              }
                                                            });
                                                          },
                                                  children: const [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                          ),
                                                      child: Text('No'),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                          ),
                                                      child: Text('Yes'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.h),
                                            TextFormField(
                                              controller:
                                                  _hearingProblemsController,
                                              decoration: _inputDecoration(
                                                'Hearing Problems',
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap:
                                                        _isEditing
                                                            ? () => _pickDate(
                                                              context,
                                                              (d) => setState(
                                                                () =>
                                                                    _lastHearingTest =
                                                                        d,
                                                              ),
                                                              initial:
                                                                  _lastHearingTest,
                                                            )
                                                            : null,
                                                    child: InputDecorator(
                                                      decoration: _inputDecoration(
                                                        'Last Hearing Test Date',
                                                      ),
                                                      child: Text(
                                                        _lastHearingTest != null
                                                            ? DateFormat.yMMMd()
                                                                .format(
                                                                  _lastHearingTest!,
                                                                )
                                                            : 'dd/mm/yyyy',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                ToggleButtons(
                                                  isSelected: [
                                                    _hearingProblemNo,
                                                    _hearingProblemYes,
                                                  ],
                                                  onPressed:
                                                      !_isEditing
                                                          ? null
                                                          : (idx) {
                                                            setState(() {
                                                              if (idx == 0) {
                                                                _hearingProblemNo =
                                                                    true;
                                                                _hearingProblemYes =
                                                                    false;
                                                              } else {
                                                                _hearingProblemYes =
                                                                    true;
                                                                _hearingProblemNo =
                                                                    false;
                                                              }
                                                            });
                                                          },
                                                  children: const [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                          ),
                                                      child: Text('No'),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                          ),
                                                      child: Text('Yes'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Physical activity & sports
                                    _sectionHeader(
                                      '8. Physical Activity & Sports',
                                    ),
                                    _editableWrapper(
                                      child: _sectionCard(
                                        Column(
                                          children: [
                                            TextFormField(
                                              controller:
                                                  _activityLimitationsController,
                                              decoration: _inputDecoration(
                                                'Limitations on Physical Activity',
                                              ),
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 8.h),
                                            TextFormField(
                                              controller:
                                                  _sportsParticipationController,
                                              decoration: _inputDecoration(
                                                'Sports Participation (limitations)',
                                              ),
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 8.h),
                                            TextFormField(
                                              controller:
                                                  _specialEquipmentController,
                                              decoration: _inputDecoration(
                                                'Special Equipment Needed',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Mental & Behavioral
                                    _sectionHeader(
                                      '9. Mental & Behavioral Health',
                                    ),
                                    _editableWrapper(
                                      child: _sectionCard(
                                        Column(
                                          children: [
                                            TextFormField(
                                              controller:
                                                  _mentalHistoryController,
                                              decoration: _inputDecoration(
                                                'Mental Health History',
                                              ),
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 8.h),
                                            TextFormField(
                                              controller:
                                                  _diagnosedConditionsController,
                                              decoration: _inputDecoration(
                                                'Diagnosed Conditions',
                                              ),
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 8.h),
                                            TextFormField(
                                              controller:
                                                  _therapyMedicationController,
                                              decoration: _inputDecoration(
                                                'Medication or Therapy',
                                              ),
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 8.h),
                                            TextFormField(
                                              controller:
                                                  _behavioralConcernsController,
                                              decoration: _inputDecoration(
                                                'Behavioral Concerns',
                                              ),
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 8.h),
                                            TextFormField(
                                              controller:
                                                  _supportNeededController,
                                              decoration: _inputDecoration(
                                                'Support Needed',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Dietary restrictions
                                    _sectionHeader('10. Dietary Restrictions'),
                                    _editableWrapper(
                                      child: _sectionCard(
                                        Column(
                                          children: [
                                            TextFormField(
                                              controller:
                                                  _specialDietController,
                                              decoration: _inputDecoration(
                                                'Any Special Diet / Nutritional Needs',
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            TextFormField(
                                              controller:
                                                  _foodAllergiesController,
                                              decoration: _inputDecoration(
                                                'Food Allergies or Sensitivities',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Past injuries
                                    _sectionHeader('11. Past Injuries'),
                                    _editableWrapper(
                                      child: _sectionCard(
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                ChoiceChip(
                                                  label: const Text('No'),
                                                  selected: _pastInjuryNone,
                                                  onSelected:
                                                      !_isEditing
                                                          ? null
                                                          : (_) => setState(() {
                                                            _pastInjuryNone =
                                                                !_pastInjuryNone;
                                                            if (_pastInjuryNone) {
                                                              _pastInjuryYes =
                                                                  false;
                                                              for (final k
                                                                  in _pastInjuries
                                                                      .keys) {
                                                                _pastInjuries[k] =
                                                                    false;
                                                              }
                                                            }
                                                          }),
                                                ),
                                                SizedBox(width: 8.w),
                                                ChoiceChip(
                                                  label: const Text('Yes'),
                                                  selected: _pastInjuryYes,
                                                  onSelected:
                                                      !_isEditing
                                                          ? null
                                                          : (_) => setState(() {
                                                            _pastInjuryYes =
                                                                !_pastInjuryYes;
                                                            if (_pastInjuryYes)
                                                              _pastInjuryNone =
                                                                  false;
                                                          }),
                                                ),
                                              ],
                                            ),
                                            if (_pastInjuryYes) ...[
                                              SizedBox(height: 8.h),
                                              Column(
                                                children:
                                                    _pastInjuries.keys
                                                        .map(
                                                          (
                                                            k,
                                                          ) => CheckboxListTile(
                                                            dense: true,
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            title: Text(k),
                                                            value:
                                                                _pastInjuries[k],
                                                            onChanged:
                                                                !_isEditing
                                                                    ? null
                                                                    : (
                                                                      v,
                                                                    ) => setState(
                                                                      () =>
                                                                          _pastInjuries[k] =
                                                                              v ??
                                                                              false,
                                                                    ),
                                                          ),
                                                        )
                                                        .toList(),
                                              ),
                                              TextFormField(
                                                controller:
                                                    _pastInjuriesOtherController,
                                                decoration: _inputDecoration(
                                                  'If other',
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Surgeries
                                    _sectionHeader('12. Surgeries'),
                                    _editableWrapper(
                                      child: _sectionCard(
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                ChoiceChip(
                                                  label: const Text('No'),
                                                  selected: _surgeriesNone,
                                                  onSelected:
                                                      !_isEditing
                                                          ? null
                                                          : (_) => setState(() {
                                                            _surgeriesNone =
                                                                !_surgeriesNone;
                                                            if (_surgeriesNone) {
                                                              _surgeriesYes =
                                                                  false;
                                                              for (final k
                                                                  in _surgeries
                                                                      .keys) {
                                                                _surgeries[k] =
                                                                    false;
                                                              }
                                                            }
                                                          }),
                                                ),
                                                SizedBox(width: 8.w),
                                                ChoiceChip(
                                                  label: const Text('Yes'),
                                                  selected: _surgeriesYes,
                                                  onSelected:
                                                      !_isEditing
                                                          ? null
                                                          : (_) => setState(() {
                                                            _surgeriesYes =
                                                                !_surgeriesYes;
                                                            if (_surgeriesYes)
                                                              _surgeriesNone =
                                                                  false;
                                                          }),
                                                ),
                                              ],
                                            ),
                                            if (_surgeriesYes) ...[
                                              SizedBox(height: 8.h),
                                              Column(
                                                children:
                                                    _surgeries.keys
                                                        .map(
                                                          (
                                                            k,
                                                          ) => CheckboxListTile(
                                                            dense: true,
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            title: Text(k),
                                                            value:
                                                                _surgeries[k],
                                                            onChanged:
                                                                !_isEditing
                                                                    ? null
                                                                    : (
                                                                      v,
                                                                    ) => setState(
                                                                      () =>
                                                                          _surgeries[k] =
                                                                              v ??
                                                                              false,
                                                                    ),
                                                          ),
                                                        )
                                                        .toList(),
                                              ),
                                              TextFormField(
                                                controller:
                                                    _surgeriesOtherController,
                                                decoration: _inputDecoration(
                                                  'If other',
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 16.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 14.h,
                                              ),
                                              side: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              backgroundColor:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.surface,
                                            ),
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(fontSize: 14.sp),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 14.h,
                                              ),
                                              backgroundColor:
                                                  _isEditing
                                                      ? ColorsManager.accentMint
                                                      : Colors.grey.shade400,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              elevation: 2,
                                            ),
                                            onPressed:
                                                _isEditing
                                                    ? _saveProfile
                                                    : null,
                                            child: Text(
                                              'Save',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 24.h),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ✅ Loading overlay (doesn't change form UI)
              if (_loading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.03),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),

              // ✅ Error overlay (doesn't change form UI)
              if (!_loading && _error != null)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.03),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: loadMedicalForm,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

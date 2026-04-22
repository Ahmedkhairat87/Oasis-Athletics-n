import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../../core/medical_constants.dart';
import '../../../../../../../core/model/stdLinks/medicalFormData/MedicalFormDataResponse.dart';
import '../../../../../../../core/model/stdLinks/medicalFormData/Medications.dart';
import '../../../../../../../core/model/stdLinks/medicalFormData/StdMedicalFormData.dart';
import '../../../../../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../../../../../core/services/stdProfile/medicalForm/StdMedicalFormService.dart';
import '../../../../../../../core/services/stdProfile/medicalForm/StdMedicalFormUpdateService.dart';


class MedicalFormState extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  bool loading = true;
  String? error;
  bool isEditing = false;

  DateTime? lastUpdate;
  MedicalFormDataResponse? apiData;

  String? bloodGroup;
  List<String> bloodOptions = [];
  bool hasAllergies = false;
  List<Medications> medicationModels = [];

  Map<String, bool> knownAllergies = {
    for (var k in MedicalConstants.allergies) k: false,
  };

  String? allergySeverity; // for dropdown

  void setAllergySeverity(String? v) {
    allergySeverity = v;
    severityController.text = v ?? '';
    notifyListeners();
  }




  void _applySelectionsToMap(Map<String, bool> map, dynamic selected) {
    final selectedSet = <String>{};

    if (selected == null) {
      map.updateAll((k, v) => false);
      return;
    }

    if (selected is List) {
      selectedSet.addAll(
        selected.map((e) => _s(e)).where((x) => x.isNotEmpty),
      );
    } else {
      final parts = _s(selected).split(RegExp(r'[,;|]'));
      selectedSet.addAll(parts.map((e) => _s(e)).where((x) => x.isNotEmpty));
    }

    // optional: case-insensitive matching
    final selectedLower = selectedSet.map((e) => e.toLowerCase()).toSet();

    map.updateAll((k, v) {
      final key = _s(k);
      if (key.isEmpty) return false;

      // exact match first (best for backend)
      if (selectedSet.contains(key)) return true;

      // fallback: case-insensitive match
      return selectedLower.contains(key.toLowerCase());
    });
  }


  void _printPayload(Map<String, dynamic> payload) {
    debugPrint('📤 MEDICAL FORM PAYLOAD START ==================');

    payload.forEach((key, value) {
      debugPrint('🔑 $key : $value');
    });

    debugPrint('📤 MEDICAL FORM PAYLOAD END ====================');
  }




  String _s(dynamic v) => (v ?? '').toString().trim();

  String _bool01(bool v) => v ? "1" : "0";

  String _dateIso(DateTime? d) => d == null ? "" : d.toIso8601String();

  String _joinSelected(Map<String, bool> map) {
    final keys = map.entries
        .where((e) => e.value == true)
        .map((e) => e.key.trim())
        .where((x) => x.isNotEmpty)
        .toList();
    return keys.join(',');
  }

  int? _bloodGroupIdFromSelection() {
    final name = _s(bloodGroup);
    if (name.isEmpty) return null;

    // First try matching API options list (if you want ID from API you need ID in model)
    // Since you only have names, fallback to constants mapping:
    final idx = MedicalConstants.bloodGroups.indexOf(name);
    if (idx >= 0) return idx + 1;

    // Also try matching case-insensitive
    final idx2 = MedicalConstants.bloodGroups.indexWhere(
          (e) => e.toLowerCase().trim() == name.toLowerCase().trim(),
    );
    if (idx2 >= 0) return idx2 + 1;

    return null;
  }


  final typeOfAllergyController = TextEditingController();
  final severityController = TextEditingController();
  final specificTreatmentController = TextEditingController();
  final otherAllergyController = TextEditingController();

  final chronicConditionsController = TextEditingController();
  final chronicTreatmentController = TextEditingController();
  final chronicEmergencyController = TextEditingController();

  final pastSurgeryController = TextEditingController();
  final hospitalizationReasonController = TextEditingController();
  final hospitalizationDatesController = TextEditingController();

  final familyHistoryController = TextEditingController();

  final List<Map<String, TextEditingController>> medications = [];

  DateTime? lastImmunizationDate;
  final vaccinesReceivedController = TextEditingController();

  final visionProblemsController = TextEditingController();
  DateTime? lastEyeExam;
  bool visionProblemNo = false;
  bool visionProblemYes = false;

  DateTime? lastHearingTest;
  bool hearingProblemNo = false;
  bool hearingProblemYes = false;

  final activityLimitationsController = TextEditingController();
  final sportsParticipationController = TextEditingController();
  final specialEquipmentController = TextEditingController();

  final mentalHistoryController = TextEditingController();
  final diagnosedConditionsController = TextEditingController();
  final therapyMedicationController = TextEditingController();
  final behavioralConcernsController = TextEditingController();
  final supportNeededController = TextEditingController();

  final specialDietController = TextEditingController();
  final foodAllergiesController = TextEditingController();

  final Map<String, bool> pastInjuries = {
    for (var k in MedicalConstants.pastInjuryTypes) k: false,
  };
  bool pastInjuryNone = false;
  bool pastInjuryYes = false;
  final pastInjuriesOtherController = TextEditingController();

  final Map<String, bool> surgeries = {
    for (var k in MedicalConstants.surgeryTypes) k: false,
  };
  bool surgeriesNone = false;
  bool surgeriesYes = false;
  final surgeriesOtherController = TextEditingController();

  MedicalFormState() {
    addMedicationRow();
    loadMedicalForm();
  }

  String get lastUpdateDisplay =>
      lastUpdate != null ? DateFormat.yMd().add_jms().format(lastUpdate!) : '—';

  Future<void> loadMedicalForm() async {
    loading = true;
    error = null;
    notifyListeners();

    final data = await StdMedicalFormService.getMedicalForm(
      stdId: studentNotifier.value.stdId.toString(),
    );

    if (data == null) {
      error = 'Failed to load medical form.';
      loading = false;
      notifyListeners();
      return;
    }

    apiData = data;
    loading = false;
    assignApiToUi(data);
    notifyListeners();
  }

  void assignApiToUi(MedicalFormDataResponse data) {
    final list = data.stdMedicalFormData ?? [];

    StdMedicalFormData? form;
    for (final e in list) {
      if (e.historyID != null || e.studentID != null || e.bloodGroupID != null) {
        form = e;
        break;
      }
    }

    form ??= list.isNotEmpty ? list.first : null;

    if (form == null) return;

    // ✅ Blood group options coming from API
    bloodOptions = (data.bloodGroups ?? [])
        .map((e) => _s(e.bloodGroupName))
        .where((x) => x.isNotEmpty)
        .toList();

    final bgId = form.bloodGroupID?.toInt();
    final bgName = _s(form.bloodGroupName);

    if (bgName.isNotEmpty) {
      bloodGroup = bgName;
    } else if (bgId != null &&
        bgId > 0 &&
        bgId <= MedicalConstants.bloodGroups.length) {
      bloodGroup = MedicalConstants.bloodGroups[bgId - 1];
    }

// ✅ build allergies checklist options from API PopulateAllergies
    final apiAllergyKeys = (data.populateAllergies ?? [])
        .map((e) => _s(e.column1))
        .where((x) => x.isNotEmpty)
        .toList();

// remove duplicates but keep order
    final seen = <String>{};
    final unique = <String>[];
    for (final k in apiAllergyKeys) {
      if (seen.add(k)) unique.add(k);
    }

    if (unique.isNotEmpty) {
      knownAllergies = {for (final k in unique) k: false};
    }

    hasAllergies = form.hasAllergies ?? false;

// ✅ controllers
    typeOfAllergyController.text = _s(form.allergyType);
    specificTreatmentController.text = _s(form.allergyTreatment);
    otherAllergyController.text = _s(form.allergyOther);

// ✅ dropdown value
    final sev = _s(form.allergySeverity);
    allergySeverity = sev.isNotEmpty ? sev : null;
    severityController.text = allergySeverity ?? '';

// ✅ apply selected checkboxes AFTER rebuilding knownAllergies
    _applySelectionsToMap(knownAllergies, form.selectedAllergies);

    chronicConditionsController.text = form.chronicConditions ?? '';
    chronicTreatmentController.text = form.treatmentPlan ?? '';
    chronicEmergencyController.text = form.emergencyProtocols ?? '';

    pastSurgeryController.text = form.surgeryTypeDate ?? '';
    hospitalizationReasonController.text = form.hospitalizationReason ?? '';
    hospitalizationDatesController.text = form.hospitalizationDates ?? '';

    familyHistoryController.text = form.familyHistory ?? '';
    vaccinesReceivedController.text = form.vaccinesReceived ?? '';

    visionProblemsController.text = form.visionProblems ?? '';
    final hearingBool = form.hearingProblems ?? false;
    hearingProblemYes = hearingBool;
    hearingProblemNo = !hearingBool;

    lastHearingTest = DateTime.tryParse(form.lastHearingTestDate ?? '');

    activityLimitationsController.text = form.physicalLimitations ?? '';
    sportsParticipationController.text = form.sportsLimitations ?? '';
    specialEquipmentController.text = form.specialEquipment ?? '';

    mentalHistoryController.text = form.mentalHealthHistory ?? '';
    diagnosedConditionsController.text = form.diagnosedConditions ?? '';
    therapyMedicationController.text = form.medicationOrTherapy ?? '';
    behavioralConcernsController.text = form.behavioralConcerns ?? '';
    supportNeededController.text = form.supportNeeded ?? '';

    specialDietController.text = form.specialDiet ?? '';
    foodAllergiesController.text = form.foodAllergies ?? '';

    lastUpdate = DateTime.tryParse(form.createdAt ?? '');
    lastImmunizationDate = DateTime.tryParse(form.lastImmunizationDate ?? '');
    lastEyeExam = DateTime.tryParse(form.lastEyeExamDate ?? '');

    // Injuries
    _applySelectionsToMap(pastInjuries, form.selectedInjuries);
    pastInjuriesOtherController.text = form.injuriesOther ?? '';

    final hasInj = pastInjuries.values.any((v) => v) ||
        pastInjuriesOtherController.text.trim().isNotEmpty;
    pastInjuryYes = hasInj;
    pastInjuryNone = !hasInj;

// Surgeries
    _applySelectionsToMap(surgeries, form.selectedSurgeries);
    surgeriesOtherController.text = form.surgeriesOther ?? '';

    final hasSurg = surgeries.values.any((v) => v) ||
        surgeriesOtherController.text.trim().isNotEmpty;
    surgeriesYes = hasSurg;
    surgeriesNone = !hasSurg;

// ===================== MEDICATIONS (from API) =====================
// ✅ Medications list from API (already parsed in response)
    medicationModels = data.medications ?? [];

// Build controllers for edit mode from models
    _buildMedicationControllersFromModels();

    medicationModels = data.medications ?? [];
    _buildMedicationControllersFromModels();

    /// always keep at least 1 row
    if (medications.isEmpty) {
      addMedicationRow();
    }
  }

  void addMedicationRow() {
    medications.add({
      'name': TextEditingController(),
      'dosage': TextEditingController(),
      'freq': TextEditingController(),
    });
    notifyListeners();
  }

  void removeMedicationRow(int index) {
    medications[index].values.forEach((c) => c.dispose());
    medications.removeAt(index);
    notifyListeners();
  }

  void enterEditMode() {
    isEditing = true;
    notifyListeners();
  }

  void cancelEditMode() {
    isEditing = false;
    notifyListeners();
  }

  void saveProfile() {
    isEditing = false;
    lastUpdate = DateTime.now();
    notifyListeners();
  }

  void togglePastInjuryNone() {
    pastInjuryNone = !pastInjuryNone;
    if (pastInjuryNone) {
      pastInjuryYes = false;
      pastInjuries.updateAll((key, value) => false);
    }
    notifyListeners();
  }

  void togglePastInjuryYes() {
    pastInjuryYes = !pastInjuryYes;
    if (pastInjuryYes) pastInjuryNone = false;
    notifyListeners();
  }

  void setPastInjury(String key, bool value) {
    pastInjuries[key] = value;
    notifyListeners();
  }

  void toggleSurgeryNone() {
    surgeriesNone = !surgeriesNone;
    if (surgeriesNone) {
      surgeriesYes = false;
      surgeries.updateAll((key, value) => false);
    }
    notifyListeners();
  }

  void toggleSurgeryYes() {
    surgeriesYes = !surgeriesYes;
    if (surgeriesYes) surgeriesNone = false;
    notifyListeners();
  }

  void setSurgery(String key, bool value) {
    surgeries[key] = value;
    notifyListeners();
  }


  // ===================== DATE PICKER =====================
  Future<void> pickDate(
      BuildContext context,
      ValueChanged<DateTime?> onPicked, {
        DateTime? initial,
      }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(now.year - 30),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      onPicked(picked);
      notifyListeners();
    }
  }



  void _buildMedicationControllersFromModels() {
    // clear old controllers safely
    for (final row in medications) {
      for (final c in row.values) {
        c.dispose();
      }
    }
    medications.clear();

    if (medicationModels.isEmpty) {
      addMedicationRow(); // at least one row
      return;
    }

    for (final m in medicationModels) {
      medications.add({
        'name': TextEditingController(text: (m.medicationName ?? '').trim()),
        'dosage': TextEditingController(text: (m.dosage ?? '').trim()),
        'freq': TextEditingController(text: (m.frequency ?? '').trim()),
      });
    }
  }
///Medications
  void syncMedicationModelsFromControllers() {
    // call this before sending update to API later
    medicationModels = medications.map((row) {
      String v(TextEditingController? c) => (c?.text ?? '').trim();
      return Medications(
        medicationName: v(row['name']),
        dosage: v(row['dosage']),
        frequency: v(row['freq']),
      );
    }).where((m) {
      // keep rows that contain something
      return (m.medicationName ?? '').trim().isNotEmpty ||
          (m.dosage ?? '').trim().isNotEmpty ||
          (m.frequency ?? '').trim().isNotEmpty;
    }).toList();
  }
// ===================== VISION TOGGLE =====================
  void toggleVision(int index) {
    if (index == 0) {
      visionProblemNo = true;
      visionProblemYes = false;
    } else {
      visionProblemYes = true;
      visionProblemNo = false;
    }
    notifyListeners();
  }

// ===================== HEARING TOGGLE =====================
  void toggleHearing(int index) {
    if (index == 0) {
      hearingProblemNo = true;
      hearingProblemYes = false;
    } else {
      hearingProblemYes = true;
      hearingProblemNo = false;
    }
    notifyListeners();
  }

  // ===================== SIMPLE STATE UPDATERS =====================

  void setBloodGroup(String value) {
    bloodGroup = value;
    notifyListeners();
  }

  void setHasAllergies(bool value) {
    hasAllergies = value;

    if (!hasAllergies) {
      typeOfAllergyController.clear();
      specificTreatmentController.clear();
      otherAllergyController.clear();
      allergySeverity = null;
      severityController.clear();
      knownAllergies.updateAll((k, v) => false);
    }

    notifyListeners();
  }

  void toggleKnownAllergy(String key, bool value) {
    knownAllergies[key] = value;
    notifyListeners();
  }


  @override
  void dispose() {
    typeOfAllergyController.dispose();
    severityController.dispose();
    specificTreatmentController.dispose();
    otherAllergyController.dispose();
    chronicConditionsController.dispose();
    chronicTreatmentController.dispose();
    chronicEmergencyController.dispose();
    pastSurgeryController.dispose();
    hospitalizationReasonController.dispose();
    hospitalizationDatesController.dispose();
    familyHistoryController.dispose();
    vaccinesReceivedController.dispose();
    visionProblemsController.dispose();
    activityLimitationsController.dispose();
    sportsParticipationController.dispose();
    specialEquipmentController.dispose();
    mentalHistoryController.dispose();
    diagnosedConditionsController.dispose();
    therapyMedicationController.dispose();
    behavioralConcernsController.dispose();
    supportNeededController.dispose();
    specialDietController.dispose();
    foodAllergiesController.dispose();
    pastInjuriesOtherController.dispose();
    surgeriesOtherController.dispose();
    for (final row in medications) {
      row.values.forEach((c) => c.dispose());
    }
    super.dispose();
  }


// add this import at top (adjust path based on your project)

  Future<bool> saveMedicalForm() async {
    // If you validate fields:
    // if (!(formKey.currentState?.validate() ?? false)) return false;

    loading = true;
    error = null;
    notifyListeners();

    final stdId = studentNotifier.value.stdId.toString();

    final bloodGroupId = _bloodGroupIdFromSelection();

    final payload = <String, dynamic>{
      // IMPORTANT: API doc fields
      "BloodGroupID": bloodGroupId?.toString() ?? "",
      "HasAllergies": _bool01(hasAllergies),
      "AllergyType": _s(typeOfAllergyController.text),
      "AllergySeverity": _s(allergySeverity ?? severityController.text),
      "AllergyTreatment": _s(specificTreatmentController.text),
      "AllergyOther": _s(otherAllergyController.text),

      "ChronicConditions": _s(chronicConditionsController.text),
      "TreatmentPlan": _s(chronicTreatmentController.text),
      "EmergencyProtocols": _s(chronicEmergencyController.text),

      "SurgeryTypeDate": _s(pastSurgeryController.text),
      "HospitalizationReason": _s(hospitalizationReasonController.text),
      "HospitalizationDates": _s(hospitalizationDatesController.text),

      "FamilyHistory": _s(familyHistoryController.text),

      "LastImmunizationDate": _dateIso(lastImmunizationDate),
      "VaccinesReceived": _s(vaccinesReceivedController.text),

      "VisionProblems": _s(visionProblemsController.text),
      "LastEyeExamDate": _dateIso(lastEyeExam),

      "HearingProblems": _bool01(hearingProblemYes),
      "HearingAid": "0", // if you add UI later, wire it here
      "LastHearingTestDate": _dateIso(lastHearingTest),

      "PhysicalLimitations": _s(activityLimitationsController.text),
      "SportsLimitations": _s(sportsParticipationController.text),
      "SpecialEquipment": _s(specialEquipmentController.text),

      "MentalHealthHistory": _s(mentalHistoryController.text),
      "DiagnosedConditions": _s(diagnosedConditionsController.text),
      "MedicationOrTherapy": _s(therapyMedicationController.text),
      "BehavioralConcerns": _s(behavioralConcernsController.text),
      "SupportNeeded": _s(supportNeededController.text),

      "SpecialDiet": _s(specialDietController.text),
      "FoodAllergies": _s(foodAllergiesController.text),

      "InjuriesOther": _s(pastInjuriesOtherController.text),
      "SurgeriesOther": _s(surgeriesOtherController.text),

      "SelectedAllergies": _joinSelected(knownAllergies),
      "SelectedInjuries": _joinSelected(pastInjuries),
      "SelectedSurgeries": _joinSelected(surgeries),
    };

    /// ✅ PRINT EVERYTHING
    _printPayload(payload);

    final ok = await StdMedicalFormUpdateService.updateMedicalForm(
      stdId: stdId,
      payload: payload,
    );

    loading = false;

    if (!ok) {
      error = 'Failed to save medical form.';
      notifyListeners();
      return false;
    }






    // success
    isEditing = false;
    lastUpdate = DateTime.now();
    notifyListeners();
    return true;
  }






}
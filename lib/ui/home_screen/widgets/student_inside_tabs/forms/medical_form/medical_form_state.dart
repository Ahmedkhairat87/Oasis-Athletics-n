import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/medical_constants.dart';
import '../../../../../../core/model/stdLinks/medicalFormData/MedicalFormDataResponse.dart';
import '../../../../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../../../../core/services/stdProfile/medicalForm/StdMedicalFormService.dart';


class MedicalFormState extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  bool loading = true;
  String? error;
  bool isEditing = false;

  DateTime? lastUpdate;
  MedicalFormDataResponse? apiData;

  String? bloodGroup;
  bool hasAllergies = false;

  final Map<String, bool> knownAllergies = {
    for (var k in MedicalConstants.allergies) k: false,
  };

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

  final hearingProblemsController = TextEditingController();
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
    final form =
    data.stdMedicalFormData?.isNotEmpty == true
        ? data.stdMedicalFormData!.first
        : null;

    if (form == null) return;

    bloodGroup = form.bloodGroupName;
    hasAllergies = form.hasAllergies ?? false;

    typeOfAllergyController.text = form.allergyType ?? '';
    severityController.text = form.allergySeverity ?? '';
    specificTreatmentController.text = form.allergyTreatment ?? '';
    otherAllergyController.text = form.allergyOther ?? '';

    chronicConditionsController.text = form.chronicConditions ?? '';
    chronicTreatmentController.text = form.treatmentPlan ?? '';
    chronicEmergencyController.text = form.emergencyProtocols ?? '';

    pastSurgeryController.text = form.surgeryTypeDate ?? '';
    hospitalizationReasonController.text = form.hospitalizationReason ?? '';
    hospitalizationDatesController.text = form.hospitalizationDates ?? '';

    familyHistoryController.text = form.familyHistory ?? '';
    vaccinesReceivedController.text = form.vaccinesReceived ?? '';

    visionProblemsController.text = form.visionProblems ?? '';
    hearingProblemsController.text = form.hearingProblems == true ? 'Yes' : 'No';

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
    hearingProblemsController.dispose();
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
}
// lib/core/model/stdLinks/medicalFormData/BloodGroups.dart

class BloodGroups {
  BloodGroups({
    this.historyID,
    this.studentID,
    this.bloodGroupID,
    this.hasAllergies,
    this.allergyType,
    this.allergySeverity,
    this.allergyTreatment,
    this.allergyOther,
    this.chronicConditions,
    this.treatmentPlan,
    this.emergencyProtocols,
    this.surgeryTypeDate,
    this.hospitalizationReason,
    this.hospitalizationDates,
    this.familyHistory,
    this.lastImmunizationDate,
    this.vaccinesReceived,
    this.visionProblems,
    this.lastEyeExamDate,
    this.hearingProblems,
    this.hearingAid,
    this.lastHearingTestDate,
    this.physicalLimitations,
    this.sportsLimitations,
    this.specialEquipment,
    this.mentalHealthHistory,
    this.diagnosedConditions,
    this.medicationOrTherapy,
    this.behavioralConcerns,
    this.supportNeeded,
    this.specialDiet,
    this.foodAllergies,
    this.injuriesOther,
    this.surgeriesOther,
    this.createdAt,
    this.selectedAllergies,
    this.selectedInjuries,
    this.selectedSurgeries,
    this.bloodGroupName,
  });

  num? historyID;
  num? studentID;
  num? bloodGroupID;

  dynamic hasAllergies; // server may return bool or 0/1
  String? allergyType;
  String? allergySeverity;
  String? allergyTreatment;
  String? allergyOther;

  String? chronicConditions;
  String? treatmentPlan;
  String? emergencyProtocols;

  String? surgeryTypeDate;
  String? hospitalizationReason;
  String? hospitalizationDates;

  String? familyHistory;

  String? lastImmunizationDate;
  String? vaccinesReceived;

  String? visionProblems;
  dynamic lastEyeExamDate;

  dynamic hearingProblems; // may be bool or 0/1
  dynamic hearingAid; // may be bool or 0/1
  dynamic lastHearingTestDate;

  String? physicalLimitations;
  String? sportsLimitations;
  String? specialEquipment;

  String? mentalHealthHistory;
  String? diagnosedConditions;
  String? medicationOrTherapy;
  String? behavioralConcerns;
  String? supportNeeded;

  String? specialDiet;
  String? foodAllergies;

  String? injuriesOther;
  String? surgeriesOther;

  String? createdAt;

  dynamic selectedAllergies; // may be List or String
  dynamic selectedInjuries; // may be List or String
  dynamic selectedSurgeries; // may be List or String

  String? bloodGroupName;

  factory BloodGroups.fromJson(dynamic json) {
    return BloodGroups(
      historyID: json['HistoryID'],
      studentID: json['StudentID'],
      bloodGroupID: json['BloodGroupID'],
      hasAllergies: json['HasAllergies'],
      allergyType: json['AllergyType']?.toString(),
      allergySeverity: json['AllergySeverity']?.toString(),
      allergyTreatment: json['AllergyTreatment']?.toString(),
      allergyOther: json['AllergyOther']?.toString(),
      chronicConditions: json['ChronicConditions']?.toString(),
      treatmentPlan: json['TreatmentPlan']?.toString(),
      emergencyProtocols: json['EmergencyProtocols']?.toString(),
      surgeryTypeDate: json['SurgeryTypeDate']?.toString(),
      hospitalizationReason: json['HospitalizationReason']?.toString(),
      hospitalizationDates: json['HospitalizationDates']?.toString(),
      familyHistory: json['FamilyHistory']?.toString(),
      lastImmunizationDate: json['LastImmunizationDate']?.toString(),
      vaccinesReceived: json['VaccinesReceived']?.toString(),
      visionProblems: json['VisionProblems']?.toString(),
      lastEyeExamDate: json['LastEyeExamDate'],
      hearingProblems: json['HearingProblems'],
      hearingAid: json['HearingAid'],
      lastHearingTestDate: json['LastHearingTestDate'],
      physicalLimitations: json['PhysicalLimitations']?.toString(),
      sportsLimitations: json['SportsLimitations']?.toString(),
      specialEquipment: json['SpecialEquipment']?.toString(),
      mentalHealthHistory: json['MentalHealthHistory']?.toString(),
      diagnosedConditions: json['DiagnosedConditions']?.toString(),
      medicationOrTherapy: json['MedicationOrTherapy']?.toString(),
      behavioralConcerns: json['BehavioralConcerns']?.toString(),
      supportNeeded: json['SupportNeeded']?.toString(),
      specialDiet: json['SpecialDiet']?.toString(),
      foodAllergies: json['FoodAllergies']?.toString(),
      injuriesOther: json['InjuriesOther']?.toString(),
      surgeriesOther: json['SurgeriesOther']?.toString(),
      createdAt: json['CreatedAt']?.toString(),
      selectedAllergies: json['SelectedAllergies'],
      selectedInjuries: json['SelectedInjuries'],
      selectedSurgeries: json['SelectedSurgeries'],
      bloodGroupName: json['BloodGroupName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['HistoryID'] = historyID;
    map['StudentID'] = studentID;
    map['BloodGroupID'] = bloodGroupID;
    map['HasAllergies'] = hasAllergies;
    map['AllergyType'] = allergyType;
    map['AllergySeverity'] = allergySeverity;
    map['AllergyTreatment'] = allergyTreatment;
    map['AllergyOther'] = allergyOther;
    map['ChronicConditions'] = chronicConditions;
    map['TreatmentPlan'] = treatmentPlan;
    map['EmergencyProtocols'] = emergencyProtocols;
    map['SurgeryTypeDate'] = surgeryTypeDate;
    map['HospitalizationReason'] = hospitalizationReason;
    map['HospitalizationDates'] = hospitalizationDates;
    map['FamilyHistory'] = familyHistory;
    map['LastImmunizationDate'] = lastImmunizationDate;
    map['VaccinesReceived'] = vaccinesReceived;
    map['VisionProblems'] = visionProblems;
    map['LastEyeExamDate'] = lastEyeExamDate;
    map['HearingProblems'] = hearingProblems;
    map['HearingAid'] = hearingAid;
    map['LastHearingTestDate'] = lastHearingTestDate;
    map['PhysicalLimitations'] = physicalLimitations;
    map['SportsLimitations'] = sportsLimitations;
    map['SpecialEquipment'] = specialEquipment;
    map['MentalHealthHistory'] = mentalHealthHistory;
    map['DiagnosedConditions'] = diagnosedConditions;
    map['MedicationOrTherapy'] = medicationOrTherapy;
    map['BehavioralConcerns'] = behavioralConcerns;
    map['SupportNeeded'] = supportNeeded;
    map['SpecialDiet'] = specialDiet;
    map['FoodAllergies'] = foodAllergies;
    map['InjuriesOther'] = injuriesOther;
    map['SurgeriesOther'] = surgeriesOther;
    map['CreatedAt'] = createdAt;
    map['SelectedAllergies'] = selectedAllergies;
    map['SelectedInjuries'] = selectedInjuries;
    map['SelectedSurgeries'] = selectedSurgeries;
    map['BloodGroupName'] = bloodGroupName;
    return map;
  }
}

// lib/core/model/stdLinks/medicalFormData/MedicalFormDataResponse.dart

import 'BloodGroups.dart';
import 'PopulateAllergies.dart';
import 'PopulateInjuries.dart';
import 'PopulateSurgeries.dart';
import 'StdMedicalFormData.dart';
import 'Medications.dart';

class MedicalFormDataResponse {
  MedicalFormDataResponse({
    this.stdMedicalFormData,
    this.medications,
    this.bloodGroups,
    this.populateAllergies,
    this.populateInjuries,
    this.populateSurgeries,
  });

  List<StdMedicalFormData>? stdMedicalFormData;
  List<Medications>? medications;
  List<BloodGroups>? bloodGroups;
  List<PopulateAllergies>? populateAllergies;
  List<PopulateInjuries>? populateInjuries;
  List<PopulateSurgeries>? populateSurgeries;

  factory MedicalFormDataResponse.fromJson(dynamic json) {
    final data = MedicalFormDataResponse();

    // stdMedicalFormData can be: List or "" or null
    final smd = json?['stdMedicalFormData'];
    if (smd is List) {
      data.stdMedicalFormData =
          smd.map((v) => StdMedicalFormData.fromJson(v)).toList();
    } else {
      data.stdMedicalFormData = [];
    }

    // Medications can be: List or "" or null
    final meds = json?['Medications'];
    if (meds is List) {
      data.medications = meds.map((v) => Medications.fromJson(v)).toList();
    } else {
      data.medications = [];
    }

    // BloodGroups: List or null
    final bg = json?['BloodGroups'];
    if (bg is List) {
      data.bloodGroups = bg.map((v) => BloodGroups.fromJson(v)).toList();
    } else {
      data.bloodGroups = [];
    }

    // PopulateAllergies: List or null
    final pa = json?['PopulateAllergies'];
    if (pa is List) {
      data.populateAllergies =
          pa.map((v) => PopulateAllergies.fromJson(v)).toList();
    } else {
      data.populateAllergies = [];
    }

    // PopulateInjuries: List or null
    final pi = json?['PopulateInjuries'];
    if (pi is List) {
      data.populateInjuries =
          pi.map((v) => PopulateInjuries.fromJson(v)).toList();
    } else {
      data.populateInjuries = [];
    }

    // PopulateSurgeries: List or null
    final ps = json?['PopulateSurgeries'];
    if (ps is List) {
      data.populateSurgeries =
          ps.map((v) => PopulateSurgeries.fromJson(v)).toList();
    } else {
      data.populateSurgeries = [];
    }

    return data;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['stdMedicalFormData'] =
        (stdMedicalFormData ?? []).map((v) => v.toJson()).toList();

    map['Medications'] = (medications ?? []).map((v) => v.toJson()).toList();

    map['BloodGroups'] = (bloodGroups ?? []).map((v) => v.toJson()).toList();

    map['PopulateAllergies'] =
        (populateAllergies ?? []).map((v) => v.toJson()).toList();

    map['PopulateInjuries'] =
        (populateInjuries ?? []).map((v) => v.toJson()).toList();

    map['PopulateSurgeries'] =
        (populateSurgeries ?? []).map((v) => v.toJson()).toList();

    return map;
  }
}

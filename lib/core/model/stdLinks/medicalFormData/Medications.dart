// lib/core/model/stdLinks/medicalFormData/Medications.dart

class Medications {
  Medications({this.medicationName, this.dosage, this.frequency});

  String? medicationName;
  String? dosage;
  String? frequency;

  factory Medications.fromJson(dynamic json) {
    return Medications(
      medicationName: json['MedicationName']?.toString(),
      dosage: json['Dosage']?.toString(),
      frequency: json['Frequency']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MedicationName'] = medicationName;
    map['Dosage'] = dosage;
    map['Frequency'] = frequency;
    return map;
  }
}

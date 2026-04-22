import 'StdDoctorReports.dart';
import 'StdDoctorPhysiotherapist.dart';
import 'StdDoctorinbody.dart';
import 'StdDoctorDiet.dart';

class MedicalTabReportsResponse {
  MedicalTabReportsResponse({
    this.stdDoctorReports,
    this.stdDoctorPhysiotherapist,
    this.stdDoctorinbody,
    this.stdDoctorDiet,
  });

  MedicalTabReportsResponse.fromJson(dynamic json) {
    stdDoctorReports = _parseList<StdDoctorReports>(
      json['stdDoctorReports'],
          (v) => StdDoctorReports.fromJson(v),
    );

    stdDoctorPhysiotherapist = _parseList<StdDoctorPhysiotherapist>(
      json['stdDoctorPhysiotherapist'],
          (v) => StdDoctorPhysiotherapist.fromJson(v),
    );

    stdDoctorinbody = _parseList<StdDoctorinbody>(
      json['stdDoctorinbody'],
          (v) => StdDoctorinbody.fromJson(v),
    );

    stdDoctorDiet = _parseList<StdDoctorDiet>(
      json['stdDoctorDiet'],
          (v) => StdDoctorDiet.fromJson(v),
    );
  }

  List<StdDoctorReports>? stdDoctorReports;
  List<StdDoctorPhysiotherapist>? stdDoctorPhysiotherapist;
  List<StdDoctorinbody>? stdDoctorinbody;
  List<StdDoctorDiet>? stdDoctorDiet;

  static List<T> _parseList<T>(
      dynamic value,
      T Function(Map<String, dynamic>) fromJson,
      ) {
    if (value == null) return [];

    if (value is List) {
      return value
          .whereType<Map<String, dynamic>>()
          .map(fromJson)
          .toList();
    }

    if (value is String && value.trim().isEmpty) {
      return [];
    }

    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'stdDoctorReports': stdDoctorReports?.map((v) => v.toJson()).toList() ?? [],
      'stdDoctorPhysiotherapist':
      stdDoctorPhysiotherapist?.map((v) => v.toJson()).toList() ?? [],
      'stdDoctorinbody': stdDoctorinbody?.map((v) => v.toJson()).toList() ?? [],
      'stdDoctorDiet': stdDoctorDiet?.map((v) => v.toJson()).toList() ?? [],
    };
  }
}
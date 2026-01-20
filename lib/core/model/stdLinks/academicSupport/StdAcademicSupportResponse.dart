import 'StdReports.dart';
import 'StdSubjectData.dart';
import 'StdSubjectDetailsData.dart';

class StdAcademicSupportResponse {
  StdAcademicSupportResponse({
    this.stdReports,
    this.stdSubjectData,
    this.stdSubjectDetailsData,
  });

  StdAcademicSupportResponse.fromJson(dynamic json) {
    if (json['stdReports'] != null) {
      stdReports = [];
      json['stdReports'].forEach((v) {
        stdReports?.add(StdReports.fromJson(v));
      });
    }
    if (json['stdSubjectData'] != null) {
      stdSubjectData = [];
      json['stdSubjectData'].forEach((v) {
        stdSubjectData?.add(StdSubjectData.fromJson(v));
      });
    }
    if (json['stdSubjectDetailsData'] != null) {
      stdSubjectDetailsData = [];
      json['stdSubjectDetailsData'].forEach((v) {
        stdSubjectDetailsData?.add(StdSubjectDetailsData.fromJson(v));
      });
    }
  }
  List<StdReports>? stdReports;
  List<StdSubjectData>? stdSubjectData;
  List<StdSubjectDetailsData>? stdSubjectDetailsData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (stdReports != null) {
      map['stdReports'] = stdReports?.map((v) => v.toJson()).toList();
    }
    if (stdSubjectData != null) {
      map['stdSubjectData'] = stdSubjectData?.map((v) => v.toJson()).toList();
    }
    if (stdSubjectDetailsData != null) {
      map['stdSubjectDetailsData'] =
          stdSubjectDetailsData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

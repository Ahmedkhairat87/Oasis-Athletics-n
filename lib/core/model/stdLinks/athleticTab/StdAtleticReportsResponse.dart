import 'StdAthleticsReports.dart';

class StdAtleticReportsResponse {
  StdAtleticReportsResponse({
      this.stdAthleticsReports,});

  StdAtleticReportsResponse.fromJson(dynamic json) {
    if (json['stdAthleticsReports'] != null) {
      stdAthleticsReports = [];
      json['stdAthleticsReports'].forEach((v) {
        stdAthleticsReports?.add(StdAthleticsReports.fromJson(v));
      });
    }
  }
  List<StdAthleticsReports>? stdAthleticsReports;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (stdAthleticsReports != null) {
      map['stdAthleticsReports'] = stdAthleticsReports?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
import 'AcademicLinks.dart';

class StdSchoolAcademicLinks {
  StdSchoolAcademicLinks({this.academicLinks});

  StdSchoolAcademicLinks.fromJson(dynamic json) {
    if (json['AcademicLinks'] != null) {
      academicLinks = [];
      json['AcademicLinks'].forEach((v) {
        academicLinks?.add(AcademicLinks.fromJson(v));
      });
    }
  }
  List<AcademicLinks>? academicLinks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (academicLinks != null) {
      map['AcademicLinks'] = academicLinks?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

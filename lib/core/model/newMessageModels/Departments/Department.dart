import 'DepartmentEmployee.dart';

class Department {
  Department({this.toDepartment});

  Department.fromJson(dynamic json) {
    if (json['toDepartment'] != null) {
      toDepartment = [];
      json['toDepartment'].forEach((v) {
        toDepartment?.add(DepartmentEmployee.fromJson(v));
      });
    }
  }
  List<DepartmentEmployee>? toDepartment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (toDepartment != null) {
      map['toDepartment'] = toDepartment?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

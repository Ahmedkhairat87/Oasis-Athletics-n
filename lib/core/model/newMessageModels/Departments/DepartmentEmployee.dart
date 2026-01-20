class DepartmentEmployee {
  DepartmentEmployee({
    this.matDesc,
    this.matNo,
    this.empNo,
    this.departmentId,
    this.empMatValue,
  });

  DepartmentEmployee.fromJson(dynamic json) {
    matDesc = json['mat_desc'];
    matNo = json['mat_no'];
    empNo = json['emp_no'];
    departmentId = json['DepartmentId'];
    empMatValue = json['emp_mat_value'];
  }
  String? matDesc;
  num? matNo;
  num? empNo;
  num? departmentId;
  String? empMatValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mat_desc'] = matDesc;
    map['mat_no'] = matNo;
    map['emp_no'] = empNo;
    map['DepartmentId'] = departmentId;
    map['emp_mat_value'] = empMatValue;
    return map;
  }
}

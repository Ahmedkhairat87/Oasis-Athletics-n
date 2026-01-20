class ToDepartment {
  final String matDesc;
  final int matNo;
  final int empNo;
  final int departmentID;
  final String empMatValue;

  ToDepartment({
    required this.matDesc,
    required this.matNo,
    required this.empNo,
    required this.departmentID,
    required this.empMatValue,
  });

  factory ToDepartment.fromJson(Map<String, dynamic> json) {
    return ToDepartment(
      matDesc: json['mat_desc'],
      matNo: json['mat_no'],
      empNo: json['emp_no'],
      departmentID: json['departmentID'],
      empMatValue: json['emp_mat_value'],
    );
  }
}

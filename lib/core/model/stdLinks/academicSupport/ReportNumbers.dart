class ReportNumbers {
  ReportNumbers({
      this.reportNo, 
      this.reportDesc,});

  ReportNumbers.fromJson(dynamic json) {
    reportNo = json['ReportNo'];
    reportDesc = json['reportDesc'];
  }
  num? reportNo;
  String? reportDesc;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ReportNo'] = reportNo;
    map['reportDesc'] = reportDesc;
    return map;
  }

}
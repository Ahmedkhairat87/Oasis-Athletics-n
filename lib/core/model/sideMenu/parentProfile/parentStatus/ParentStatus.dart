class ParentStatus {
  ParentStatus({this.serNo, this.parentstatus, this.parentstatusEn});

  ParentStatus.fromJson(dynamic json) {
    serNo = json['ser_no'];
    parentstatus = json['parentstatus'];
    parentstatusEn = json['parentstatus_en'];
  }
  num? serNo;
  String? parentstatus;
  String? parentstatusEn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ser_no'] = serNo;
    map['parentstatus'] = parentstatus;
    map['parentstatus_en'] = parentstatusEn;
    return map;
  }
}

class SentResponse {
  SentResponse({
      this.taSer, 
      this.empName, 
      this.matNo, 
      this.column1, 
      this.matDesc, 
      this.subject, 
      this.editDate, 
      this.viewedIMG, 
      this.body,});

  SentResponse.fromJson(dynamic json) {
    taSer = json['taSer'];
    empName = json['emp_name'];
    matNo = json['matNo'];
    column1 = json['Column1'];
    matDesc = json['mat_desc'];
    subject = json['subject'];
    editDate = json['editDate'];
    viewedIMG = json['viewedIMG'];
    body = json['body'];
  }
  num? taSer;
  String? empName;
  num? matNo;
  String? column1;
  String? matDesc;
  String? subject;
  String? editDate;
  num? viewedIMG;
  String? body;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['taSer'] = taSer;
    map['emp_name'] = empName;
    map['matNo'] = matNo;
    map['Column1'] = column1;
    map['mat_desc'] = matDesc;
    map['subject'] = subject;
    map['editDate'] = editDate;
    map['viewedIMG'] = viewedIMG;
    map['body'] = body;
    return map;
  }

}
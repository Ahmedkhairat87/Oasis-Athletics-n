class StdSubjectDetailsData {
  StdSubjectDetailsData({
      this.attendanceId, 
      this.attendanceDate, 
      this.abs, 
      this.timeSlot, 
      this.timeSlotName, 
      this.devoir, 
      this.travail, 
      this.comment, 
      this.empNo, 
      this.empName, 
      this.matNo, 
      this.subjectNameFR, 
      this.ifAppearforparent, 
      this.currentDate,});

  StdSubjectDetailsData.fromJson(dynamic json) {
    attendanceId = json['attendance_id'];
    attendanceDate = json['attendance_date'];
    abs = json['ABS'];
    timeSlot = json['TimeSlot'];
    timeSlotName = json['TimeSlot_name'];
    devoir = json['Devoir'];
    travail = json['Travail'];
    comment = json['comment'];
    empNo = json['emp_no'];
    empName = json['emp_name'];
    matNo = json['mat_no'];
    subjectNameFR = json['SubjectNameFR'];
    ifAppearforparent = json['if_appearforparent'];
    currentDate = json['CurrentDate'];
  }
  num? attendanceId;
  String? attendanceDate;
  String? abs;
  String? timeSlot;
  String? timeSlotName;
  String? devoir;
  String? travail;
  String? comment;
  num? empNo;
  String? empName;
  num? matNo;
  String? subjectNameFR;
  num? ifAppearforparent;
  String? currentDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['attendance_id'] = attendanceId;
    map['attendance_date'] = attendanceDate;
    map['ABS'] = abs;
    map['TimeSlot'] = timeSlot;
    map['TimeSlot_name'] = timeSlotName;
    map['Devoir'] = devoir;
    map['Travail'] = travail;
    map['comment'] = comment;
    map['emp_no'] = empNo;
    map['emp_name'] = empName;
    map['mat_no'] = matNo;
    map['SubjectNameFR'] = subjectNameFR;
    map['if_appearforparent'] = ifAppearforparent;
    map['CurrentDate'] = currentDate;
    return map;
  }

}
class StdDoctorReports {
  StdDoctorReports({
    this.updateType,
    this.ReportID,
    this.uploadID,
    this.studentID,
    this.uploadDate,
    this.filePath,
    this.doctorComments,
    this.readflag,
    this.who,
  });

  StdDoctorReports.fromJson(dynamic json) {
    updateType = _toNum(json['updateType']);
    ReportID = _toNum(json['ReportID']);
    uploadID = _toNum(json['UploadID']);
    studentID = _toNum(json['StudentID']);
    uploadDate = _toText(json['UploadDate']);
    filePath = _toText(json['FilePath']);
    doctorComments = _toText(json['DoctorComments']);
    readflag = _toNum(json['readflag']);
    who = _toText(json['who']);
  }
  num? updateType;
  num? ReportID;
  num? uploadID;
  num? studentID;
  String? uploadDate;
  String? filePath;
  String? doctorComments;
  num? readflag;
  String? who;

  Map<String, dynamic> toJson() {
    return {
      'updateType': updateType,
      'ReportID' : ReportID,
      'UploadID': uploadID,
      'StudentID': studentID,
      'UploadDate': uploadDate,
      'FilePath': filePath,
      'DoctorComments': doctorComments,
      'readflag': readflag,
      'who': who,
    };
  }
}

String _toText(dynamic v) {
  if (v == null) return '';
  if (v is String) return v;
  return v.toString();
}

num? _toNum(dynamic v) {
  if (v == null) return null;
  if (v is num) return v;
  return num.tryParse(v.toString());
}
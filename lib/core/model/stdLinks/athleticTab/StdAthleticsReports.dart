class StdAthleticsReports {
  StdAthleticsReports({
    this.reportType,
    this.uploadDate,
    this.filePath,
    this.parentRead,
    this.readedDate,
  });

  StdAthleticsReports.fromJson(dynamic json) {
    reportType = json['ReportType'];
    uploadDate = json['UploadDate'];
    filePath = json['FilePath'];
    parentRead = json['Parent_read'];
    readedDate = json['Readed_date'];
  }
  String? reportType;
  String? uploadDate;
  String? filePath;
  num? parentRead;
  String? readedDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ReportType'] = reportType;
    map['UploadDate'] = uploadDate;
    map['FilePath'] = filePath;
    map['Parent_read'] = parentRead;
    map['Readed_date'] = readedDate;
    return map;
  }
}

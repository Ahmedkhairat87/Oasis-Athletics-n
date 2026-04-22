// class StdAthleticsReports {
//   StdAthleticsReports({
//     this.updateType,
//     this.ReportID,
//     this.reportType,
//     this.uploadDate,
//     this.filePath,
//     this.parentRead,
//     this.readedDate,
//   });
//
//   StdAthleticsReports.fromJson(dynamic json) {
//     updateType = json['updateType'];
//     ReportID = json['ReportID'];
//     reportType = json['ReportType'];
//     uploadDate = json['UploadDate'];
//     filePath = json['FilePath'];
//     parentRead = json['Parent_read'];
//     readedDate = json['Readed_date'];
//   }
//   String? updateType;
//   String? ReportID;
//   String? reportType;
//   String? uploadDate;
//   String? filePath;
//   num? parentRead;
//   dynamic readedDate;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['updateType'] = updateType;
//     map['ReportID'] = ReportID;
//     map['ReportType'] = reportType;
//     map['UploadDate'] = uploadDate;
//     map['FilePath'] = filePath;
//     map['Parent_read'] = parentRead;
//     map['Readed_date'] = readedDate;
//     return map;
//   }
// }

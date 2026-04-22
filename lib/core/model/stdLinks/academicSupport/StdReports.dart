class StdReports {
  StdReports({
      this.stdId, 
      this.nom, 
      this.gradeId, 
      this.gradeDesc, 
      this.className, 
      this.schoolYear, 
      this.purposeDescE, 
      this.stdPicture, 
      this.schoolTask, 
      this.extraTask, 
      this.presentCount, 
      this.absentCount,});

  StdReports.fromJson(dynamic json) {
    stdId = json['std_id'];
    nom = json['nom'];
    gradeId = json['grade_id'];
    gradeDesc = json['grade_desc'];
    className = json['class_name'];
    schoolYear = json['school_year'];
    purposeDescE = json['purpose_desc_e'];
    stdPicture = json['std_picture'];
    schoolTask = json['SchoolTask'];
    extraTask = json['ExtraTask'];
    presentCount = json['PresentCount'];
    absentCount = json['AbsentCount'];
  }
  num? stdId;
  String? nom;
  num? gradeId;
  String? gradeDesc;
  String? className;
  String? schoolYear;
  String? purposeDescE;
  String? stdPicture;
  num? schoolTask;
  num? extraTask;
  num? presentCount;
  num? absentCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['std_id'] = stdId;
    map['nom'] = nom;
    map['grade_id'] = gradeId;
    map['grade_desc'] = gradeDesc;
    map['class_name'] = className;
    map['school_year'] = schoolYear;
    map['purpose_desc_e'] = purposeDescE;
    map['std_picture'] = stdPicture;
    map['SchoolTask'] = schoolTask;
    map['ExtraTask'] = extraTask;
    map['PresentCount'] = presentCount;
    map['AbsentCount'] = absentCount;
    return map;
  }

}
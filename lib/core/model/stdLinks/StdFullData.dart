class StdFullData {
  StdFullData({
    this.stdId,
    this.stdFirstname,
    this.fatherFullname,
    this.gradeDesc,
    this.className,
    this.stdPicture,
    this.photoYY,
    this.purposeDescE,
    this.schadname,
    this.measurementID,
    this.measurementDate,
    this.heightCM,
    this.weightKG,
    this.recordedBy,
    this.recordedType,
    this.recordedByName,
    this.notes,
    this.groupeblood,
    this.schoolYear,
    this.stdBirthdate,
    this.stdEmail,
    this.fatherMobile,
    this.motherMobile,
    this.contactMobile,
    this.fatherAddress,
    this.motherAddress,
    this.urgentM1,
    this.urgentP1,
    this.urgentParentrelation1,
    this.urgentM2,
    this.urgentP2,
    this.urgentParentrelation2,
    this.urgentM3,
    this.urgentP3,
    this.urgentParentrelation3,
    this.allergies,
    this.ageYears,
    this.ageMonths,
    this.serNo,
    this.empNo,
    this.schoolemail,
    this.empName,
    this.empMobile,
    this.stdIdStatus,
    this.editdate,
    this.empPic,
    this.stdEmail1,
    this.studentPwd,
  });

  StdFullData.fromJson(dynamic json) {
    stdId = json['std_id'];
    stdFirstname = json['std_firstname'];
    fatherFullname = json['father_fullname'];
    gradeDesc = json['grade_desc'];
    className = json['class_name'];
    stdPicture = json['std_picture'];
    photoYY = json['photoYY'];
    purposeDescE = json['purpose_desc_e'];
    schadname = json['schadname'];
    measurementID = json['MeasurementID'];
    measurementDate = json['MeasurementDate'];
    heightCM = json['HeightCM'];
    weightKG = json['WeightKG'];
    recordedBy = json['RecordedBy'];
    recordedType = json['Recorded_type'];
    recordedByName = json['RecordedByName'];
    notes = json['Notes'];
    groupeblood = json['groupeblood'];
    schoolYear = json['school_year'];
    stdBirthdate = json['std_birthdate'];
    stdEmail = json['std_email'];
    fatherMobile = json['father_mobile'];
    motherMobile = json['mother_mobile'];
    contactMobile = json['contact_mobile'];
    fatherAddress = json['father_address'];
    motherAddress = json['mother_address'];
    urgentM1 = json['urgentM1'];
    urgentP1 = json['urgentP1'];
    urgentParentrelation1 = json['urgent_parentrelation1'];
    urgentM2 = json['urgentM2'];
    urgentP2 = json['urgentP2'];
    urgentParentrelation2 = json['urgent_parentrelation2'];
    urgentM3 = json['urgentM3'];
    urgentP3 = json['urgentP3'];
    urgentParentrelation3 = json['urgent_parentrelation3'];
    allergies = json['Allergies'];
    ageYears = json['age_years'];
    ageMonths = json['age_months'];
    serNo = json['Ser_no'];
    empNo = json['emp_no'];
    schoolemail = json['schoolemail'];
    empName = json['emp_name'];
    empMobile = json['emp_mobile'];
    stdIdStatus = json['std_id_status'];
    editdate = json['editdate'];
    empPic = json['emp_pic'];
    stdEmail1 = json['std_email1'];
    studentPwd = json['student_pwd'];
  }
  num? stdId;
  String? stdFirstname;
  String? fatherFullname;
  String? gradeDesc;
  String? className;
  String? stdPicture;
  String? photoYY;
  String? purposeDescE;
  String? schadname;
  dynamic measurementID;
  dynamic measurementDate;
  dynamic heightCM;
  dynamic weightKG;
  dynamic recordedBy;
  String? recordedType;
  String? recordedByName;
  dynamic notes;
  String? groupeblood;
  String? schoolYear;
  String? stdBirthdate;
  String? stdEmail;
  String? fatherMobile;
  String? motherMobile;
  String? contactMobile;
  String? fatherAddress;
  String? motherAddress;
  String? urgentM1;
  String? urgentP1;
  String? urgentParentrelation1;
  String? urgentM2;
  String? urgentP2;
  String? urgentParentrelation2;
  String? urgentM3;
  String? urgentP3;
  String? urgentParentrelation3;
  dynamic allergies;
  num? ageYears;
  num? ageMonths;
  num? serNo;
  num? empNo;
  dynamic schoolemail;
  dynamic empName;
  String? empMobile;
  num? stdIdStatus;
  String? editdate;
  dynamic empPic;
  String? stdEmail1;
  String? studentPwd;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['std_id'] = stdId;
    map['std_firstname'] = stdFirstname;
    map['father_fullname'] = fatherFullname;
    map['grade_desc'] = gradeDesc;
    map['class_name'] = className;
    map['std_picture'] = stdPicture;
    map['photoYY'] = photoYY;
    map['purpose_desc_e'] = purposeDescE;
    map['schadname'] = schadname;
    map['MeasurementID'] = measurementID;
    map['MeasurementDate'] = measurementDate;
    map['HeightCM'] = heightCM;
    map['WeightKG'] = weightKG;
    map['RecordedBy'] = recordedBy;
    map['Recorded_type'] = recordedType;
    map['RecordedByName'] = recordedByName;
    map['Notes'] = notes;
    map['groupeblood'] = groupeblood;
    map['school_year'] = schoolYear;
    map['std_birthdate'] = stdBirthdate;
    map['std_email'] = stdEmail;
    map['father_mobile'] = fatherMobile;
    map['mother_mobile'] = motherMobile;
    map['contact_mobile'] = contactMobile;
    map['father_address'] = fatherAddress;
    map['mother_address'] = motherAddress;
    map['urgentM1'] = urgentM1;
    map['urgentP1'] = urgentP1;
    map['urgent_parentrelation1'] = urgentParentrelation1;
    map['urgentM2'] = urgentM2;
    map['urgentP2'] = urgentP2;
    map['urgent_parentrelation2'] = urgentParentrelation2;
    map['urgentM3'] = urgentM3;
    map['urgentP3'] = urgentP3;
    map['urgent_parentrelation3'] = urgentParentrelation3;
    map['Allergies'] = allergies;
    map['age_years'] = ageYears;
    map['age_months'] = ageMonths;
    map['Ser_no'] = serNo;
    map['emp_no'] = empNo;
    map['schoolemail'] = schoolemail;
    map['emp_name'] = empName;
    map['emp_mobile'] = empMobile;
    map['std_id_status'] = stdIdStatus;
    map['editdate'] = editdate;
    map['emp_pic'] = empPic;
    map['std_email1'] = stdEmail1;
    map['student_pwd'] = studentPwd;
    return map;
  }
}

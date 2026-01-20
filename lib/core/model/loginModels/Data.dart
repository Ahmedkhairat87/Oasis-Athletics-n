class Data {
  Data({
    this.fatherId,
    this.fatherFullname,
    this.fatherFullnameA,
    this.fatherTuteur,
    this.fatherAddress,
    this.fatherHometel,
    this.fatherMobile,
    this.fatherProfession,
    this.fatherDomain,
    this.fatherCompany,
    this.fatherWorkplace,
    this.fatherSchool,
    this.fatherDiplome,
    this.father1lang,
    this.father2lang,
    this.father3lang,
    this.fatherAutreslang,
    this.fatherEmail,
    this.motherFullname,
    this.motherAddress,
    this.motherTuteur,
    this.motherHometel,
    this.motherMobile,
    this.motherProfession,
    this.motherDomain,
    this.motherCompany,
    this.motherWorkplace,
    this.motherSchool,
    this.motherDiplome,
    this.mother1lang,
    this.mother2lang,
    this.mother3lang,
    this.motherAutreslang,
    this.motherEmail,
    this.ifOtherparent,
    this.otherParentname,
    this.parentStatus,
    this.remark,
    this.editDate,
    this.barCode,
    this.mailingLanguage,
    this.contactEmail,
    this.printFlag,
    this.parentPwd,
    this.contactMobile,
    this.parentSMS,
    this.urgentName1,
    this.urgentParentrelation1,
    this.urgentTel1,
    this.urgentMobile1,
    this.urgentName2,
    this.urgentParentrelation2,
    this.urgentTel2,
    this.urgentMobile2,
    this.urgentName3,
    this.urgentParentrelation3,
    this.urgentTel3,
    this.urgentMobile3,
    this.modifyStatus,
    this.modifyDate,
    this.modifyStatus2,
    this.modifyDate2,
    this.accountStatus,
    this.appAccountStatus,
    this.appSer,
    this.schoolRegulationsApprovStatus,
    this.schoolRegulationsApprovStatusDate,
  });

  Data.fromJson(dynamic json) {
    fatherId = json['father_id'];
    fatherFullname = json['father_fullname'];
    fatherFullnameA = json['father_fullname_a'];
    fatherTuteur = json['father_tuteur'];
    fatherAddress = json['father_address'];
    fatherHometel = json['father_hometel'];
    fatherMobile = json['father_mobile'];
    fatherProfession = json['father_profession'];
    fatherDomain = json['father_domain'];
    fatherCompany = json['father_company'];
    fatherWorkplace = json['father_workplace'];
    fatherSchool = json['father_school'];
    fatherDiplome = json['father_diplome'];
    father1lang = json['father_1lang'];
    father2lang = json['father_2lang'];
    father3lang = json['father_3lang'];
    fatherAutreslang = json['father_autreslang'];
    fatherEmail = json['father_email'];
    motherFullname = json['mother_fullname'];
    motherAddress = json['mother_address'];
    motherTuteur = json['mother_tuteur'];
    motherHometel = json['mother_hometel'];
    motherMobile = json['mother_mobile'];
    motherProfession = json['mother_profession'];
    motherDomain = json['mother_domain'];
    motherCompany = json['mother_company'];
    motherWorkplace = json['mother_workplace'];
    motherSchool = json['mother_school'];
    motherDiplome = json['mother_diplome'];
    mother1lang = json['mother_1lang'];
    mother2lang = json['mother_2lang'];
    mother3lang = json['mother_3lang'];
    motherAutreslang = json['mother_autreslang'];
    motherEmail = json['mother_email'];
    ifOtherparent = json['if_otherparent'];
    otherParentname = json['other_parentname'];
    parentStatus = json['parent_status'];
    remark = json['remark'];
    editDate = json['edit_date'];
    barCode = json['bar_code'];
    mailingLanguage = json['mailing_language'];
    contactEmail = json['contact_email'];
    printFlag = json['print_flag'];
    parentPwd = json['parent_pwd'];
    contactMobile = json['contact_mobile'];
    parentSMS = json['parent_SMS'];
    urgentName1 = json['urgent_name1'];
    urgentParentrelation1 = json['urgent_parentrelation1'];
    urgentTel1 = json['urgent_tel1'];
    urgentMobile1 = json['urgent_mobile1'];
    urgentName2 = json['urgent_name2'];
    urgentParentrelation2 = json['urgent_parentrelation2'];
    urgentTel2 = json['urgent_tel2'];
    urgentMobile2 = json['urgent_mobile2'];
    urgentName3 = json['urgent_name3'];
    urgentParentrelation3 = json['urgent_parentrelation3'];
    urgentTel3 = json['urgent_tel3'];
    urgentMobile3 = json['urgent_mobile3'];
    modifyStatus = json['Modify_status'];
    modifyDate = json['Modify_date'];
    modifyStatus2 = json['Modify_status2'];
    modifyDate2 = json['Modify_date2'];
    accountStatus = json['account_status'];
    appAccountStatus = json['AppAccountStatus'];
    appSer = json['app_ser'];
    schoolRegulationsApprovStatus = json['schoolRegulationsApprovStatus'];
    schoolRegulationsApprovStatusDate =
        json['schoolRegulationsApprovStatusDate'];
  }
  num? fatherId;
  String? fatherFullname;
  dynamic fatherFullnameA;
  String? fatherTuteur;
  String? fatherAddress;
  String? fatherHometel;
  String? fatherMobile;
  String? fatherProfession;
  num? fatherDomain;
  String? fatherCompany;
  String? fatherWorkplace;
  String? fatherSchool;
  String? fatherDiplome;
  String? father1lang;
  String? father2lang;
  String? father3lang;
  String? fatherAutreslang;
  String? fatherEmail;
  String? motherFullname;
  String? motherAddress;
  String? motherTuteur;
  String? motherHometel;
  String? motherMobile;
  String? motherProfession;
  num? motherDomain;
  String? motherCompany;
  String? motherWorkplace;
  String? motherSchool;
  String? motherDiplome;
  String? mother1lang;
  String? mother2lang;
  String? mother3lang;
  String? motherAutreslang;
  String? motherEmail;
  num? ifOtherparent;
  dynamic otherParentname;
  String? parentStatus;
  dynamic remark;
  String? editDate;
  String? barCode;
  num? mailingLanguage;
  String? contactEmail;
  num? printFlag;
  String? parentPwd;
  String? contactMobile;
  dynamic parentSMS;
  String? urgentName1;
  String? urgentParentrelation1;
  String? urgentTel1;
  String? urgentMobile1;
  String? urgentName2;
  String? urgentParentrelation2;
  String? urgentTel2;
  String? urgentMobile2;
  String? urgentName3;
  String? urgentParentrelation3;
  String? urgentTel3;
  String? urgentMobile3;
  num? modifyStatus;
  String? modifyDate;
  num? modifyStatus2;
  String? modifyDate2;
  num? accountStatus;
  num? appAccountStatus;
  dynamic appSer;
  num? schoolRegulationsApprovStatus;
  String? schoolRegulationsApprovStatusDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['father_id'] = fatherId;
    map['father_fullname'] = fatherFullname;
    map['father_fullname_a'] = fatherFullnameA;
    map['father_tuteur'] = fatherTuteur;
    map['father_address'] = fatherAddress;
    map['father_hometel'] = fatherHometel;
    map['father_mobile'] = fatherMobile;
    map['father_profession'] = fatherProfession;
    map['father_domain'] = fatherDomain;
    map['father_company'] = fatherCompany;
    map['father_workplace'] = fatherWorkplace;
    map['father_school'] = fatherSchool;
    map['father_diplome'] = fatherDiplome;
    map['father_1lang'] = father1lang;
    map['father_2lang'] = father2lang;
    map['father_3lang'] = father3lang;
    map['father_autreslang'] = fatherAutreslang;
    map['father_email'] = fatherEmail;
    map['mother_fullname'] = motherFullname;
    map['mother_address'] = motherAddress;
    map['mother_tuteur'] = motherTuteur;
    map['mother_hometel'] = motherHometel;
    map['mother_mobile'] = motherMobile;
    map['mother_profession'] = motherProfession;
    map['mother_domain'] = motherDomain;
    map['mother_company'] = motherCompany;
    map['mother_workplace'] = motherWorkplace;
    map['mother_school'] = motherSchool;
    map['mother_diplome'] = motherDiplome;
    map['mother_1lang'] = mother1lang;
    map['mother_2lang'] = mother2lang;
    map['mother_3lang'] = mother3lang;
    map['mother_autreslang'] = motherAutreslang;
    map['mother_email'] = motherEmail;
    map['if_otherparent'] = ifOtherparent;
    map['other_parentname'] = otherParentname;
    map['parent_status'] = parentStatus;
    map['remark'] = remark;
    map['edit_date'] = editDate;
    map['bar_code'] = barCode;
    map['mailing_language'] = mailingLanguage;
    map['contact_email'] = contactEmail;
    map['print_flag'] = printFlag;
    map['parent_pwd'] = parentPwd;
    map['contact_mobile'] = contactMobile;
    map['parent_SMS'] = parentSMS;
    map['urgent_name1'] = urgentName1;
    map['urgent_parentrelation1'] = urgentParentrelation1;
    map['urgent_tel1'] = urgentTel1;
    map['urgent_mobile1'] = urgentMobile1;
    map['urgent_name2'] = urgentName2;
    map['urgent_parentrelation2'] = urgentParentrelation2;
    map['urgent_tel2'] = urgentTel2;
    map['urgent_mobile2'] = urgentMobile2;
    map['urgent_name3'] = urgentName3;
    map['urgent_parentrelation3'] = urgentParentrelation3;
    map['urgent_tel3'] = urgentTel3;
    map['urgent_mobile3'] = urgentMobile3;
    map['Modify_status'] = modifyStatus;
    map['Modify_date'] = modifyDate;
    map['Modify_status2'] = modifyStatus2;
    map['Modify_date2'] = modifyDate2;
    map['account_status'] = accountStatus;
    map['AppAccountStatus'] = appAccountStatus;
    map['app_ser'] = appSer;
    map['schoolRegulationsApprovStatus'] = schoolRegulationsApprovStatus;
    map['schoolRegulationsApprovStatusDate'] =
        schoolRegulationsApprovStatusDate;
    return map;
  }
}

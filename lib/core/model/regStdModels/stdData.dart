class stdData {
  stdData({
    this.stdId,
    this.stdFirstname,
    this.stdPicture,
    this.currentGrade,
    this.currentClasse,
    this.stdPayment,
    this.genNote,
    this.accountStatus,
    this.appAccountStatus,
    this.attStatus,
    this.attDesc,
    this.attDescEn,
    this.attSession,
    this.ifDelegate,
    this.busFlag,
    this.stdEmail,
    this.studentPwd,
    this.balance,
    this.oasisAthleticFlag,
    this.oasisAthleticPlan,
    this.oasisAthleticPrgPlan,
  });

  stdData.fromJson(dynamic json) {
    stdId = json['std_id'];
    stdFirstname = json['std_firstname'];
    stdPicture = json['std_picture'];
    currentGrade = json['current_grade'];
    currentClasse = json['current_classe'];
    stdPayment = json['stdPayment'];
    genNote = json['genNote'];
    accountStatus = json['account_status'];
    appAccountStatus = json['AppAccountStatus'];
    attStatus = json['attStatus'];
    attDesc = json['attDesc'];
    attDescEn = json['attDescEn'];
    attSession = json['attSession'];
    ifDelegate = json['ifDelegate'];
    busFlag = json['BusFlag'];
    stdEmail = json['std_email'];
    studentPwd = json['student_pwd'];
    balance = json['Balance'];
    oasisAthleticFlag = json['OasisAthleticFlag'];
    oasisAthleticPlan = json['OasisAthleticPlan'];
    oasisAthleticPrgPlan = json['OasisAthleticPrgPlan'];
  }
  num? stdId;
  String? stdFirstname;
  String? stdPicture;
  num? currentGrade;
  num? currentClasse;
  String? stdPayment;
  String? genNote;
  num? accountStatus;
  num? appAccountStatus;
  num? attStatus;
  num? attDesc;
  num? attDescEn;
  num? attSession;
  num? ifDelegate;
  String? busFlag;
  dynamic stdEmail;
  String? studentPwd;
  String? balance;
  num? oasisAthleticFlag;
  num? oasisAthleticPlan;
  num? oasisAthleticPrgPlan;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['std_id'] = stdId;
    map['std_firstname'] = stdFirstname;
    map['std_picture'] = stdPicture;
    map['current_grade'] = currentGrade;
    map['current_classe'] = currentClasse;
    map['stdPayment'] = stdPayment;
    map['genNote'] = genNote;
    map['account_status'] = accountStatus;
    map['AppAccountStatus'] = appAccountStatus;
    map['attStatus'] = attStatus;
    map['attDesc'] = attDesc;
    map['attDescEn'] = attDescEn;
    map['attSession'] = attSession;
    map['ifDelegate'] = ifDelegate;
    map['BusFlag'] = busFlag;
    map['std_email'] = stdEmail;
    map['student_pwd'] = studentPwd;
    map['Balance'] = balance;
    map['OasisAthleticFlag'] = oasisAthleticFlag;
    map['OasisAthleticPlan'] = oasisAthleticPlan;
    map['OasisAthleticPrgPlan'] = oasisAthleticPrgPlan;
    return map;
  }
}

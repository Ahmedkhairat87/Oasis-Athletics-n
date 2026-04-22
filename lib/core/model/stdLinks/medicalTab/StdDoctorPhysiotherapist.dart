class StdDoctorPhysiotherapist {
  StdDoctorPhysiotherapist({
    this.updateType,
    this.ReportID,
    this.recordID,
    this.studentID,
    this.dateOfVisit,
    this.presentingComplaint,
    this.initialDiagnosis,
    this.scansNeeded,
    this.treatmentOnSpot,
    this.physioRehabPlan,
    this.homeExerciseProgram,
    this.exerciseVideoPath,
    this.exerciseLinks,
    this.returnToPlay,
    this.followUpDate,
    this.createdAt,
    this.homeCareOption,
    this.homeCareOtherText,
    this.readflag,
  });

  StdDoctorPhysiotherapist.fromJson(dynamic json) {
    updateType = _toNum(json['updateType']);
    ReportID = _toNum(json['ReportID']);
    recordID = _toNum(json['RecordID']);
    studentID = _toNum(json['StudentID']);
    dateOfVisit = _toText(json['DateOfVisit']);
    presentingComplaint = _toText(json['PresentingComplaint']);
    initialDiagnosis = _toText(json['InitialDiagnosis']);
    scansNeeded = _toText(json['ScansNeeded']);
    treatmentOnSpot = _toText(json['TreatmentOnSpot']);
    physioRehabPlan = _toText(json['PhysioRehabPlan']);
    homeExerciseProgram = _toText(json['HomeExerciseProgram']);
    exerciseVideoPath = _toText(json['ExerciseVideoPath']);
    exerciseLinks = _toText(json['ExerciseLinks']);
    returnToPlay = _toText(json['ReturnToPlay']);
    followUpDate = _toText(json['FollowUpDate']);
    createdAt = _toText(json['CreatedAt']);
    homeCareOption = _toText(json['HomeCareOption']);
    homeCareOtherText = _toText(json['HomeCareOtherText']);
    readflag = _toNum(json['readflag']);
  }

  num? updateType;
  num? ReportID;
  num? recordID;
  num? studentID;
  String? dateOfVisit;
  String? presentingComplaint;
  String? initialDiagnosis;
  String? scansNeeded;
  String? treatmentOnSpot;
  String? physioRehabPlan;
  String? homeExerciseProgram;
  String? exerciseVideoPath;
  String? exerciseLinks;
  String? returnToPlay;
  String? followUpDate;
  String? createdAt;
  String? homeCareOption;
  String? homeCareOtherText;
  num? readflag;

  Map<String, dynamic> toJson() {
    return {
      'updateType': updateType,
      'ReportID' : ReportID,
      'RecordID': recordID,
      'StudentID': studentID,
      'DateOfVisit': dateOfVisit,
      'PresentingComplaint': presentingComplaint,
      'InitialDiagnosis': initialDiagnosis,
      'ScansNeeded': scansNeeded,
      'TreatmentOnSpot': treatmentOnSpot,
      'PhysioRehabPlan': physioRehabPlan,
      'HomeExerciseProgram': homeExerciseProgram,
      'ExerciseVideoPath': exerciseVideoPath,
      'ExerciseLinks': exerciseLinks,
      'ReturnToPlay': returnToPlay,
      'FollowUpDate': followUpDate,
      'CreatedAt': createdAt,
      'HomeCareOption': homeCareOption,
      'HomeCareOtherText': homeCareOtherText,
      'readflag': readflag,
    };
  }

  static String _toText(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  static num? _toNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    return num.tryParse(value.toString());
  }
}
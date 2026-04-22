class StdDoctorinbody {
  StdDoctorinbody({
    this.trackingID,
    this.studentID,
    this.inbodyPath,
    this.notes,
    this.createdAt,
  });

  StdDoctorinbody.fromJson(dynamic json) {
    trackingID = _toNum(json['TrackingID']);
    studentID = _toNum(json['StudentID']);
    inbodyPath = _toText(json['inbody_path']);
    notes = _toText(json['Notes']);
    createdAt = _toText(json['CreatedAt']);
  }

  num? trackingID;
  num? studentID;
  String? inbodyPath;
  String? notes;
  String? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'TrackingID': trackingID,
      'StudentID': studentID,
      'inbody_path': inbodyPath,
      'Notes': notes,
      'CreatedAt': createdAt,
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
class StdSubjectData {
  StdSubjectData({
      this.subjectName, 
      this.autonomie, 
      this.organisation, 
      this.expression, 
      this.participation, 
      this.commentaire, 
      this.reportDate,});

  StdSubjectData.fromJson(dynamic json) {
    subjectName = json['SubjectName'];
    autonomie = json['Autonomie'];
    organisation = json['Organisation'];
    expression = json['Expression'];
    participation = json['Participation'];
    commentaire = json['Commentaire'];
    reportDate = json['ReportDate'];
  }
  String? subjectName;
  String? autonomie;
  String? organisation;
  String? expression;
  String? participation;
  String? commentaire;
  String? reportDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SubjectName'] = subjectName;
    map['Autonomie'] = autonomie;
    map['Organisation'] = organisation;
    map['Expression'] = expression;
    map['Participation'] = participation;
    map['Commentaire'] = commentaire;
    map['ReportDate'] = reportDate;
    return map;
  }

}
class StdSports {
  StdSports({this.studentSport, this.sport});

  StdSports.fromJson(dynamic json) {
    studentSport = json['Student Sport'];
    sport = json['Sport'];
  }
  String? studentSport;
  String? sport;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Student Sport'] = studentSport;
    map['Sport'] = sport;
    return map;
  }
}

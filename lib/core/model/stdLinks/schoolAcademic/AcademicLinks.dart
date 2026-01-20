class AcademicLinks {
  AcademicLinks({
    this.sublinkId,
    this.stdId,
    this.sublinkDescE,
    this.sublinkUrlnameE,
    this.sublinkDescF,
    this.sublinkUrlnameF,
    this.appSegues,
    this.unreadFlag,
  });

  AcademicLinks.fromJson(dynamic json) {
    sublinkId = json['sublink_id'];
    stdId = json['std_id'];
    sublinkDescE = json['sublink_desc_e'];
    sublinkUrlnameE = json['sublink_urlname_e'];
    sublinkDescF = json['sublink_desc_f'];
    sublinkUrlnameF = json['sublink_urlname_f'];
    appSegues = json['AppSegues'];
    unreadFlag = json['unreadFlag'];
  }
  num? sublinkId;
  num? stdId;
  String? sublinkDescE;
  String? sublinkUrlnameE;
  String? sublinkDescF;
  String? sublinkUrlnameF;
  String? appSegues;
  num? unreadFlag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sublink_id'] = sublinkId;
    map['std_id'] = stdId;
    map['sublink_desc_e'] = sublinkDescE;
    map['sublink_urlname_e'] = sublinkUrlnameE;
    map['sublink_desc_f'] = sublinkDescF;
    map['sublink_urlname_f'] = sublinkUrlnameF;
    map['AppSegues'] = appSegues;
    map['unreadFlag'] = unreadFlag;
    return map;
  }
}

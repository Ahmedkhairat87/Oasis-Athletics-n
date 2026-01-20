class ParentLanguage {
  ParentLanguage({this.serno, this.parentlang});

  ParentLanguage.fromJson(dynamic json) {
    serno = json['serno'];
    parentlang = json['parentlang'];
  }
  num? serno;
  String? parentlang;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serno'] = serno;
    map['parentlang'] = parentlang;
    return map;
  }
}

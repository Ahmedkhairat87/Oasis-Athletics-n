class PopulateAllergies {
  PopulateAllergies({this.column1});

  PopulateAllergies.fromJson(dynamic json) {
    column1 = json['Column1'];
  }
  String? column1;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Column1'] = column1;
    return map;
  }
}

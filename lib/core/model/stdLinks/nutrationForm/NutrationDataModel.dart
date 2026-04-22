import 'NutrationGeneral.dart';

class NutrationDataModel {
  NutrationDataModel({
      this.nutrationGeneral,});

  NutrationDataModel.fromJson(dynamic json) {
    if (json['Nutration_General'] != null) {
      nutrationGeneral = [];
      json['Nutration_General'].forEach((v) {
        nutrationGeneral?.add(NutrationGeneral.fromJson(v));
      });
    }
  }
  List<NutrationGeneral>? nutrationGeneral;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (nutrationGeneral != null) {
      map['Nutration_General'] = nutrationGeneral?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
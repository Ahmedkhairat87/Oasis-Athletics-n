import 'package:oasisathletic/core/model/sideMenu/parentProfile/profileMainData/parentProfileData.dart';

class ParentProfileDataResponse {
  ParentProfileDataResponse({this.data});

  ParentProfileDataResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(parentProfileData.fromJson(v));
      });
    }
  }
  List<parentProfileData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

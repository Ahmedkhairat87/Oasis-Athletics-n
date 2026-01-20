import 'ParentLanguage.dart';

class ParentLanguageResponse {
  ParentLanguageResponse({this.data});

  ParentLanguageResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ParentLanguage.fromJson(v));
      });
    }
  }
  List<ParentLanguage>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

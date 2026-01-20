import 'ParentStatus.dart';

class ParentStatusResponse {
  ParentStatusResponse({this.data});

  ParentStatusResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ParentStatus.fromJson(v));
      });
    }
  }
  List<ParentStatus>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

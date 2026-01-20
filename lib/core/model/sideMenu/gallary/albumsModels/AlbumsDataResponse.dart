import 'albumData.dart';

class AlbumsDataResponse {
  AlbumsDataResponse({this.requestedCount, this.data});

  AlbumsDataResponse.fromJson(dynamic json) {
    requestedCount = json['requestedCount'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(albumData.fromJson(v));
      });
    }
  }
  String? requestedCount;
  List<albumData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['requestedCount'] = requestedCount;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

import 'PhotoData.dart';

class AlbumPhotosResponse {
  AlbumPhotosResponse({this.data});

  AlbumPhotosResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PhotoData.fromJson(v));
      });
    }
  }
  List<PhotoData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

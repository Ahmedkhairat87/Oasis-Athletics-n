import 'StdMainLinks.dart';
import 'StdFullData.dart';
import 'StdSports.dart';

class StdLinks {
  StdLinks({this.stdMainLinks, this.stdFullData, this.stdSports});

  StdLinks.fromJson(dynamic json) {
    if (json['stdMainLinks'] != null) {
      stdMainLinks = [];
      json['stdMainLinks'].forEach((v) {
        stdMainLinks?.add(StdMainLinks.fromJson(v));
      });
    }
    if (json['stdFullData'] != null) {
      stdFullData = [];
      json['stdFullData'].forEach((v) {
        stdFullData?.add(StdFullData.fromJson(v));
      });
    }
    if (json['stdSports'] != null) {
      stdSports = [];
      json['stdSports'].forEach((v) {
        stdSports?.add(StdSports.fromJson(v));
      });
    }
  }
  List<StdMainLinks>? stdMainLinks;
  List<StdFullData>? stdFullData;
  List<StdSports>? stdSports;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (stdMainLinks != null) {
      map['stdMainLinks'] = stdMainLinks?.map((v) => v.toJson()).toList();
    }
    if (stdFullData != null) {
      map['stdFullData'] = stdFullData?.map((v) => v.toJson()).toList();
    }
    if (stdSports != null) {
      map['stdSports'] = stdSports?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

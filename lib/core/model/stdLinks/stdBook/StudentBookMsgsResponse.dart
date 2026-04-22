
import 'InboxResponse.dart';
import 'SentResponse.dart';

class StudentBookMsgsResponse {
  StudentBookMsgsResponse({
      this.data, 
      this.data2,});

  StudentBookMsgsResponse.fromJson(dynamic json) {
    if (json['Data'] != null) {
      data = [];
      json['Data'].forEach((v) {
        data?.add(InboxResponse.fromJson(v));
      });
    }
    if (json['Data2'] != null) {
      data2 = [];
      json['Data2'].forEach((v) {
        data2?.add(SentResponse.fromJson(v));
      });
    }
  }
  List<InboxResponse>? data;
  List<SentResponse>? data2;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['Data'] = data?.map((v) => v.toJson()).toList();
    }
    if (data2 != null) {
      map['Data2'] = data2?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
import 'Data.dart';

class LoginResponse {
  LoginResponse({
    this.token,
    this.data,
    this.intStatus,
    this.natStatus,
    this.pQStatus,
    this.unReadedCount,
  });

  LoginResponse.fromJson(dynamic json) {
    token = json['token'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    intStatus = json['IntStatus'];
    natStatus = json['NatStatus'];
    pQStatus = json['PQStatus'];
    unReadedCount = json['UnReadedCount'];
  }
  String? token;
  List<Data>? data;
  num? intStatus;
  num? natStatus;
  num? pQStatus;
  num? unReadedCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['IntStatus'] = intStatus;
    map['NatStatus'] = natStatus;
    map['PQStatus'] = pQStatus;
    map['UnReadedCount'] = unReadedCount;
    return map;
  }
}

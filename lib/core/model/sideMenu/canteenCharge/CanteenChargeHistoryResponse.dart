import 'StdChargs.dart';

class CanteenChargeHistoryResponse {
  CanteenChargeHistoryResponse({this.stdChargs});

  CanteenChargeHistoryResponse.fromJson(dynamic json) {
    if (json['StdChargs'] != null) {
      stdChargs = [];
      json['StdChargs'].forEach((v) {
        stdChargs?.add(StdChargs.fromJson(v));
      });
    }
  }
  List<StdChargs>? stdChargs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (stdChargs != null) {
      map['StdChargs'] = stdChargs?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

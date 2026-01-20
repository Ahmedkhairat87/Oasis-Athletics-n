import 'ChargsAmounts.dart';

class ChargeAmountsResponse {
  ChargeAmountsResponse({this.chargsAmounts});

  ChargeAmountsResponse.fromJson(dynamic json) {
    if (json['chargsAmounts'] != null) {
      chargsAmounts = [];
      json['chargsAmounts'].forEach((v) {
        chargsAmounts?.add(ChargsAmounts.fromJson(v));
      });
    }
  }
  List<ChargsAmounts>? chargsAmounts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (chargsAmounts != null) {
      map['chargsAmounts'] = chargsAmounts?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class AccData {
  AccData({this.accSer, this.accAmount});

  AccData.fromJson(dynamic json) {
    accSer = json['acc_ser'];
    accAmount = json['accAmount'];
  }
  num? accSer;
  num? accAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['acc_ser'] = accSer;
    map['accAmount'] = accAmount;
    return map;
  }
}

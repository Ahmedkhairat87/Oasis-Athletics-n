class ToCategory {
  ToCategory({
    this.msgCategNo,
    this.msgCategDesc,
    this.oADFlag,
    this.normalFlag,
  });

  ToCategory.fromJson(dynamic json) {
    msgCategNo = json['msgCategNo'];
    msgCategDesc = json['msgCategDesc'];
    oADFlag = json['OADFlag'];
    normalFlag = json['NormalFlag'];
  }
  num? msgCategNo;
  String? msgCategDesc;
  num? oADFlag;
  num? normalFlag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msgCategNo'] = msgCategNo;
    map['msgCategDesc'] = msgCategDesc;
    map['OADFlag'] = oADFlag;
    map['NormalFlag'] = normalFlag;
    return map;
  }
}

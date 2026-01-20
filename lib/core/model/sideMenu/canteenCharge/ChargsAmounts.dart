class ChargsAmounts {
  ChargsAmounts({this.serNo, this.amount, this.accNo, this.status});

  ChargsAmounts.fromJson(dynamic json) {
    serNo = json['serNo'];
    amount = json['amount'];
    accNo = json['accNo'];
    status = json['status'];
  }
  num? serNo;
  num? amount;
  num? accNo;
  num? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serNo'] = serNo;
    map['amount'] = amount;
    map['accNo'] = accNo;
    map['status'] = status;
    return map;
  }
}

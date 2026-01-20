class StdChargs {
  StdChargs({
    this.serNo,
    this.chargeDate,
    this.amount,
    this.amountStatus,
    this.sort,
  });

  StdChargs.fromJson(dynamic json) {
    serNo = json['ser_no'];
    chargeDate = json['chargeDate'];
    amount = json['amount'];
    amountStatus = json['amountStatus'];
    sort = json['Sort'];
  }
  num? serNo;
  String? chargeDate;
  num? amount;
  String? amountStatus;
  String? sort;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ser_no'] = serNo;
    map['chargeDate'] = chargeDate;
    map['amount'] = amount;
    map['amountStatus'] = amountStatus;
    map['Sort'] = sort;
    return map;
  }
}

class CanteenPaymentLinkResponse {
  CanteenPaymentLinkResponse({this.url});

  CanteenPaymentLinkResponse.fromJson(dynamic json) {
    url = json['URL'];
  }
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['URL'] = url;
    return map;
  }
}

class albumData {
  albumData({this.eventSer, this.eventName, this.count});

  albumData.fromJson(dynamic json) {
    eventSer = json['eventSer'];
    eventName = json['eventName'];
    count = json['Count'];
  }
  num? eventSer;
  String? eventName;
  num? count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['eventSer'] = eventSer;
    map['eventName'] = eventName;
    map['Count'] = count;
    return map;
  }
}

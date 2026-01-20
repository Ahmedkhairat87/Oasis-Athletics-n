class RemovePhotoResponse {
  RemovePhotoResponse({this.requestedCount, this.requestedStatus});

  RemovePhotoResponse.fromJson(dynamic json) {
    requestedCount = json['requestedCount'];
    requestedStatus = json['requestedStatus'];
  }
  String? requestedCount;
  String? requestedStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['requestedCount'] = requestedCount;
    map['requestedStatus'] = requestedStatus;
    return map;
  }
}

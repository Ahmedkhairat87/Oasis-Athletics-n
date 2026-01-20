class DeliveredPhotosDt {
  DeliveredPhotosDt({
    this.serNo,
    this.eventSer,
    this.sphoto,
    this.sphotoX,
    this.editedDate,
    this.reqDate,
    this.btnTxt,
    this.btnCommand,
    this.photoSerNo,
    this.reqStatus,
  });

  DeliveredPhotosDt.fromJson(dynamic json) {
    serNo = json['serNo'];
    eventSer = json['eventSer'];
    sphoto = json['Sphoto'];
    sphotoX = json['SphotoX'];
    editedDate = json['editedDate'];
    reqDate = json['ReqDate'];
    btnTxt = json['btnTxt'];
    btnCommand = json['btnCommand'];
    photoSerNo = json['photoSerNo'];
    reqStatus = json['ReqStatus'];
  }
  num? serNo;
  num? eventSer;
  String? sphoto;
  String? sphotoX;
  String? editedDate;
  String? reqDate;
  String? btnTxt;
  String? btnCommand;
  num? photoSerNo;
  num? reqStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serNo'] = serNo;
    map['eventSer'] = eventSer;
    map['Sphoto'] = sphoto;
    map['SphotoX'] = sphotoX;
    map['editedDate'] = editedDate;
    map['ReqDate'] = reqDate;
    map['btnTxt'] = btnTxt;
    map['btnCommand'] = btnCommand;
    map['photoSerNo'] = photoSerNo;
    map['ReqStatus'] = reqStatus;
    return map;
  }
}

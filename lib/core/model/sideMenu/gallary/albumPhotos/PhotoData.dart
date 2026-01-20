class PhotoData {
  num? serNo;
  num? eventSer;
  String? sphoto;
  String? editedDate;
  String? btnTxt;

  /// ⚠️ kept ONLY to avoid breaking API parsing
  /// ❌ DO NOT use in UI or logic
  String? sphotoX;
  String? btnCommand;

  PhotoData({
    this.serNo,
    this.eventSer,
    this.sphoto,
    this.editedDate,
    this.btnTxt,
    this.sphotoX,
    this.btnCommand,
  });

  PhotoData.fromJson(dynamic json) {
    serNo = json['serNo'];
    eventSer = json['eventSer'];
    sphoto = json['Sphoto'];
    editedDate = json['editedDate'];
    btnTxt = json['btnTxt'];

    // kept for backward compatibility
    sphotoX = json['SphotoX'];
    btnCommand = json['btnCommand'];
  }

  /// ✅ required only if some response uses toJson()
  Map<String, dynamic> toJson() {
    return {
      'serNo': serNo,
      'eventSer': eventSer,
      'Sphoto': sphoto,
      'editedDate': editedDate,
      'btnTxt': btnTxt,
    };
  }

  /// =======================
  /// LOCAL UI HELPERS (SAFE)
  /// =======================

  bool get isRequested =>
      btnTxt?.toLowerCase().contains('request') == true ||
      btnTxt?.toLowerCase().contains('requested') == true;

  void markRequested() {
    btnTxt = 'Requested';
  }
}

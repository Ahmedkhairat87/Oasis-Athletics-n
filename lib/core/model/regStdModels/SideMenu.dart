class SideMenu {
  SideMenu({
    this.serNo,
    this.lnkNameEn,
    this.lnkNameFr,
    this.lnkPhotoEn,
    this.lnkPhotoFr,
    this.appNav,
    this.appStory,
    this.lnkURLEn,
    this.lnkURLFr,
    this.sort,
    this.startDate,
    this.endDate,
    this.status,
    this.column1,
  });

  SideMenu.fromJson(dynamic json) {
    serNo = json['serNo'];
    lnkNameEn = json['lnkNameEn'];
    lnkNameFr = json['lnkNameFr'];
    lnkPhotoEn = json['lnkPhotoEn'];
    lnkPhotoFr = json['lnkPhotoFr'];
    appNav = json['AppNav'];
    appStory = json['AppStory'];
    lnkURLEn = json['lnkURLEn'];
    lnkURLFr = json['lnkURLFr'];
    sort = json['sort'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    status = json['status'];
    column1 = json['Column1'];
  }
  num? serNo;
  String? lnkNameEn;
  String? lnkNameFr;
  String? lnkPhotoEn;
  String? lnkPhotoFr;
  String? appNav;
  String? appStory;
  dynamic lnkURLEn;
  dynamic lnkURLFr;
  num? sort;
  dynamic startDate;
  dynamic endDate;
  num? status;
  dynamic column1;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serNo'] = serNo;
    map['lnkNameEn'] = lnkNameEn;
    map['lnkNameFr'] = lnkNameFr;
    map['lnkPhotoEn'] = lnkPhotoEn;
    map['lnkPhotoFr'] = lnkPhotoFr;
    map['AppNav'] = appNav;
    map['AppStory'] = appStory;
    map['lnkURLEn'] = lnkURLEn;
    map['lnkURLFr'] = lnkURLFr;
    map['sort'] = sort;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['status'] = status;
    map['Column1'] = column1;
    return map;
  }
}

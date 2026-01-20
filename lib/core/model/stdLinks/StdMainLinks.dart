class StdMainLinks {
  StdMainLinks({
    this.serNo,
    this.linkCateg,
    this.linkCss,
    this.linkIcon,
    this.linkName,
    this.linkUrl,
  });

  StdMainLinks.fromJson(dynamic json) {
    serNo = json['serNo'];
    linkCateg = json['linkCateg'];
    linkCss = json['linkCss'];
    linkIcon = json['linkIcon'];
    linkName = json['linkName'];
    linkUrl = json['linkUrl'];
  }
  num? serNo;
  num? linkCateg;
  String? linkCss;
  String? linkIcon;
  String? linkName;
  String? linkUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serNo'] = serNo;
    map['linkCateg'] = linkCateg;
    map['linkCss'] = linkCss;
    map['linkIcon'] = linkIcon;
    map['linkName'] = linkName;
    map['linkUrl'] = linkUrl;
    return map;
  }
}

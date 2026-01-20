import 'stdData.dart';
import 'SideMenu.dart';

class RegStdResponse {
  RegStdResponse({
    this.data,
    this.unReadedCount,
    this.urgentUpdateIOS,
    this.urgentUpdateAndroid,
    this.androidVersion,
    this.iosVersion,
    this.sideMenu,
    this.sideBusLink,
    this.sideBusLinkStatus,
    this.sideBusLinkMSG,
    this.sideUNILink,
    this.sideUNILinkStatus,
    this.sideUNILinkMSG,
    this.requiredFlag,
    this.requiredURL,
  });

  RegStdResponse.fromJson(dynamic json) {
    if (json['Data'] != null) {
      data = [];
      json['Data'].forEach((v) {
        data?.add(stdData.fromJson(v));
      });
    }
    unReadedCount = json['UnReadedCount'];
    urgentUpdateIOS = json['urgentUpdateIOS'];
    urgentUpdateAndroid = json['urgentUpdateAndroid'];
    androidVersion = json['androidVersion'];
    iosVersion = json['iosVersion'];
    if (json['SideMenu'] != null) {
      sideMenu = [];
      json['SideMenu'].forEach((v) {
        sideMenu?.add(SideMenu.fromJson(v));
      });
    }
    sideBusLink = json['sideBusLink'];
    sideBusLinkStatus = json['sideBusLinkStatus'];
    sideBusLinkMSG = json['sideBusLinkMSG'];
    sideUNILink = json['sideUNILink'];
    sideUNILinkStatus = json['sideUNILinkStatus'];
    sideUNILinkMSG = json['sideUNILinkMSG'];
    requiredFlag = json['requiredFlag'];
    requiredURL = json['requiredURL'];
  }
  List<stdData>? data;
  num? unReadedCount;
  num? urgentUpdateIOS;
  num? urgentUpdateAndroid;
  String? androidVersion;
  String? iosVersion;
  List<SideMenu>? sideMenu;
  String? sideBusLink;
  String? sideBusLinkStatus;
  String? sideBusLinkMSG;
  String? sideUNILink;
  String? sideUNILinkStatus;
  String? sideUNILinkMSG;
  String? requiredFlag;
  String? requiredURL;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['Data'] = data?.map((v) => v.toJson()).toList();
    }
    map['UnReadedCount'] = unReadedCount;
    map['urgentUpdateIOS'] = urgentUpdateIOS;
    map['urgentUpdateAndroid'] = urgentUpdateAndroid;
    map['androidVersion'] = androidVersion;
    map['iosVersion'] = iosVersion;
    if (sideMenu != null) {
      map['SideMenu'] = sideMenu?.map((v) => v.toJson()).toList();
    }
    map['sideBusLink'] = sideBusLink;
    map['sideBusLinkStatus'] = sideBusLinkStatus;
    map['sideBusLinkMSG'] = sideBusLinkMSG;
    map['sideUNILink'] = sideUNILink;
    map['sideUNILinkStatus'] = sideUNILinkStatus;
    map['sideUNILinkMSG'] = sideUNILinkMSG;
    map['requiredFlag'] = requiredFlag;
    map['requiredURL'] = requiredURL;
    return map;
  }
}

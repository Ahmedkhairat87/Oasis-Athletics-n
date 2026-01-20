import 'CartPhotoData.dart';
import 'DeliveredPhotosDt.dart';
import 'AccData.dart';

class CartPhotosResponse {
  CartPhotosResponse({
    this.data,
    this.deliveredPhotosDT,
    this.accData,
    this.btn1Status,
    this.btn1Txt,
    this.merchantReferenceId,
  });

  CartPhotosResponse.fromJson(dynamic json) {
    /// CART DATA
    if (json['data'] is List) {
      data =
          (json['data'] as List).map((e) => CartPhotoData.fromJson(e)).toList();
    } else {
      data = []; // ✅ API returned "" or null
    }

    /// HISTORY DATA
    if (json['deliveredPhotosDT'] is List) {
      deliveredPhotosDT =
          (json['deliveredPhotosDT'] as List)
              .map((e) => DeliveredPhotosDt.fromJson(e))
              .toList();
    } else {
      deliveredPhotosDT = [];
    }

    /// ACCOUNT DATA
    if (json['AccData'] is List) {
      accData =
          (json['AccData'] as List).map((e) => AccData.fromJson(e)).toList();
    } else {
      accData = [];
    }

    btn1Status = json['btn1Status'];
    btn1Txt = json['btn1Txt'];
    merchantReferenceId = json['merchantReferenceId'];
  }

  List<CartPhotoData>? data;
  List<DeliveredPhotosDt>? deliveredPhotosDT;
  List<AccData>? accData;
  bool? btn1Status;
  String? btn1Txt;
  String? merchantReferenceId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (deliveredPhotosDT != null) {
      map['deliveredPhotosDT'] =
          deliveredPhotosDT?.map((v) => v.toJson()).toList();
    }
    if (accData != null) {
      map['AccData'] = accData?.map((v) => v.toJson()).toList();
    }
    map['btn1Status'] = btn1Status;
    map['btn1Txt'] = btn1Txt;
    map['merchantReferenceId'] = merchantReferenceId;
    return map;
  }
}

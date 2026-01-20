import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Utilities/apiResponseHelper.dart';
import '../../../../apiControl/apiManager.dart';
import '../../../../apiControl/apiServiceProvider.dart';
import '../../../../model/sideMenu/canteenCharge/CanteenChargeHistoryResponse.dart';
import '../../../../model/sideMenu/canteenCharge/CanteenPaymentLinkResponse.dart';
import '../../../../model/sideMenu/canteenCharge/ChargeAmountsResponse.dart';
import '../../../../model/sideMenu/canteenCharge/ChargsAmounts.dart';
import '../../../../model/sideMenu/canteenCharge/StdChargs.dart';

class CanteenService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// =====================
  /// GET CHARGE AMOUNTS
  /// =====================
  static Future<List<ChargsAmounts>> getChargeAmounts() async {
    final token = await _getToken();
    if (token == null) return [];

    final response = await APIServices().apiRequest(APIManager.getAmountList, {
      "token": token,
    });

    final json = ApiResponseHelper.normalize(response);
    return ChargeAmountsResponse.fromJson(json).chargsAmounts ?? [];
  }

  /// =====================
  /// GET HISTORY
  /// =====================
  static Future<List<StdChargs>> getHistory(int stdId) async {
    final token = await _getToken();
    if (token == null) return [];

    final response = await APIServices().apiRequest(APIManager.paymentHistory, {
      "token": token,
      "stdID": stdId,
    });

    final json = ApiResponseHelper.normalize(response);
    return CanteenChargeHistoryResponse.fromJson(json).stdChargs ?? [];
  }

  /// =====================
  /// CREATE PAYMENT LINK
  /// =====================
  static Future<String?> createPaymentLink({
    required int stdId,
    required num accNo,
    required num amount,
  }) async {
    final token = await _getToken();
    if (token == null) return null;

    final response = await APIServices().apiRequest(
      APIManager.paymentLinkGeneration,
      {"token": token, "stdID": stdId, "accNo": accNo, "amount": amount},
    );

    final json = ApiResponseHelper.normalize(response);
    return CanteenPaymentLinkResponse.fromJson(json).url;
  }
}

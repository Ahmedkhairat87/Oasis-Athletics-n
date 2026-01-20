import 'package:oasisathletic/core/model/newMessageModels/mainCategories/Categories.dart';

import '../../../apiControl/apiManager.dart';
import '../../../apiControl/apiServiceProvider.dart';

class GetDepartmentsService {
  static Future<Categories> GetDepartmentsResponse({
    required String token,
    required String selectedStd,
  }) async {
    final params = {"token": token, "selectedStd": selectedStd};

    print("API Params: $params");

    final response = await APIServices().apiRequest(
      APIManager.getDepartments,
      params,
    );

    print("✅ Full Departments Response: $response");

    if (response["success"] == true &&
        response["data"] != null &&
        response["data"]["toTypes"] != null &&
        response["data"]["toDepartment"] != null) {
      return Categories.fromJson(response["data"]); // ✅ لازم تدخل data فقط
    } else {
      throw Exception("❌ Invalid departments response structure");
    }
  }
}

// class GetDepartmentsService {
//   static Future<Categories> GetDepartmentsResponse({
//     required String token,
//     required String selectedStd,
//   }) async {
//     final params = {
//       "token": token,
//       "selectedStd": selectedStd,
//     };
//
//     print("API Params: $params");
//
//     final response = await APIServices().apiRequest(
//       APIManager.getDepartments,
//       params,
//     );
//
//     print("✅ Full Departments Response: $response");
//
//     // ✅✅✅ الشرط الصحيح
//     if (response["toTypes"] != null) {
//       return Categories.fromJson(response);
//     } else {
//       throw Exception("❌ toTypes not found in response");
//     }
//   }
// }

import 'package:oasisathletic/core/model/newMessageModels/Departments/Department.dart';
import '../../../apiControl/apiManager.dart';
import '../../../apiControl/apiServiceProvider.dart';

class GetEmpsService {
  static Future<Department> GetEmployeeResponse({
    required String token,
    required String selectedStd,
    required String toCategNo,
  }) async {
    final params = {
      "token": token,
      "selectedStd": selectedStd,
      "toCategNo": toCategNo,
    };

    print("✅ EMP API Params: $params");

    final response = await APIServices().apiRequest(
      APIManager.getDepartmentsEmps,
      params,
    );

    print("✅ Full Employees Response: $response");

    // ✅✅✅ التصحيح الحقيقي هنا
    if (response["success"] == true &&
        response["data"] != null &&
        response["data"]["toDepartment"] != null) {
      return Department.fromJson(response["data"]);
    } else {
      throw Exception(response["message"] ?? "Employees fetch failed");
    }
  }
}

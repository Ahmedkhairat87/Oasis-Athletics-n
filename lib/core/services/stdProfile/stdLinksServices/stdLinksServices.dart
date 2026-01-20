import 'package:dio/dio.dart';

import '../../../apiControl/apiManager.dart';
import '../../../model/stdLinks/StdLinks.dart';

class StudentLinksService {
  static final Dio _dio = Dio();

  static Future<StdLinks?> getStudentLinks({
    required String token,
    required String stdId,
  }) async {
    try {
      final url = APIManager.getStdLinks;
      final response = await _dio.post(
        url,
        data: {"token": token, "stdID": stdId},
      );

      print(response.data);

      if (response.data == null || response.data is! Map) {
        return null;
      }

      final data = StdLinks.fromJson(response.data);

      return data;
    } catch (e, st) {
      print("EXCEPTION IN API:");
      print(e);
      print(st);
      return null;
    }
  }
}

import 'dart:io';
import 'package:dio/dio.dart';

import '../../../../apiControl/apiManager.dart';

class SendMessageService {
  static Future<Response> sendMessageWithAttachments({
    required String token,
    required String empNo,
    required String matNo,
    required String forGrade,
    required String fromStdId,
    required String noteSubject,
    required String body,
    required String toType,
    required List<File> attachments,
  }) async {
    final dio = Dio();

    List<MultipartFile> files = [];
    for (var file in attachments) {
      files.add(
        await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      );
    }

    print("✅ Sending Message With Attachments...");
    print("token: $token");
    print("emp_no: $empNo");
    print("mat_no: $matNo");
    print("For_grade: $forGrade");
    print("from_Std_id: $fromStdId");
    print("note_subject: $noteSubject");
    print("body: $body");
    print("toType: $toType");
    print("Attachments count: ${attachments.length}");
    for (var file in attachments) {
      print(" - File: ${file.path}, size: ${file.lengthSync()} bytes");
    }

    // ✅ تجهيز الـ FormData
    final formData = FormData.fromMap({
      "token": token,
      "emp_no": empNo,
      "mat_no": matNo,
      "For_grade": forGrade,
      "from_Std_id": fromStdId,
      "note_subject": noteSubject,
      "body": body,
      "toType": toType,
      "files": files,
    });

    print("✅ Sending Message With Attachments...");

    final response = await dio.post(
      APIManager.SendMSGWithATTNew,
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    );

    print("✅ Send Message Response: ${response.data}");
    return response;
  }
}

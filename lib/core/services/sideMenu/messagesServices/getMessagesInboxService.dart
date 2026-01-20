import '../../../apiControl/apiManager.dart';
import '../../../apiControl/apiServiceProvider.dart';
import '../../../model/msgsModels/MsgsInboxResponse.dart';

class GetMessagesInboxService {
  static Future<MsgsInboxResponse> getMsgsInbox({required String token}) async {
    final params = {"token": token};

    print("API Params: $params");

    final response = await APIServices().apiRequest(
      APIManager.messagesInbox,
      params,
    );

    if (response["success"] == true && response["data"] != null) {
      // Parse response to model
      return MsgsInboxResponse.fromJson(response["data"]);
    } else {
      throw Exception(response["message"] ?? "Messages fetch failed");
    }
  }
}

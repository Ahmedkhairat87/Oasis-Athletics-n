import 'Inbox.dart';
import 'Sent.dart';

class MsgsInboxResponse {
  MsgsInboxResponse({this.inbox, this.sent, this.unReadedCount});

  MsgsInboxResponse.fromJson(dynamic json) {
    if (json['INBOX'] != null) {
      inbox = [];
      json['INBOX'].forEach((v) {
        inbox?.add(Inbox.fromJson(v));
      });
    }
    if (json['SENT'] != null) {
      sent = [];
      json['SENT'].forEach((v) {
        sent?.add(Sent.fromJson(v));
      });
    }
    unReadedCount = json['UnReadedCount'];
  }
  List<Inbox>? inbox;
  List<Sent>? sent;
  num? unReadedCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (inbox != null) {
      map['INBOX'] = inbox?.map((v) => v.toJson()).toList();
    }
    if (sent != null) {
      map['SENT'] = sent?.map((v) => v.toJson()).toList();
    }
    map['UnReadedCount'] = unReadedCount;
    return map;
  }
}

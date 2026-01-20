import 'BaseMessage.dart';
import 'Inbox.dart';
import 'Sent.dart';

class MessageMapper {
  static BaseMessage fromInbox(Inbox inbox) {
    return BaseMessage(
      studentNom: inbox.studentNom ?? "",
      message: inbox.noteBody ?? "",
      empName: inbox.empName ?? "",
      noteSubject: inbox.noteSubject ?? "",
      actualEditdate: inbox.actualEditdate ?? "",
      enDesc: inbox.enDesc ?? "",
      replyStatus: inbox.replyStatus?.toInt() ?? 0,
      noteBodyReply: inbox.noteBodyReply,

      // ✅ Original Attachments
      noteFile: inbox.noteFile,
      noteFile2: inbox.noteFile2,
      noteFile3: inbox.noteFile3,
      noteFile4: inbox.noteFile4,
      noteFile5: inbox.noteFile5,

      // ✅ Reply Attachments
      noteFileReply: inbox.noteFileReply,
      noteFile2Reply: inbox.noteFile2Reply,
      noteFile3Reply: inbox.noteFile3Reply,
      noteFile4Reply: inbox.noteFile4Reply,
      noteFile5Reply: inbox.noteFile5Reply,
      viewedFlag: inbox.viewedFlag,
    );
  }

  static BaseMessage fromSent(Sent sent) {
    return BaseMessage(
      studentNom: sent.studentNom ?? "",
      message: sent.noteBody ?? "",
      empName: sent.empName ?? "",
      noteSubject: sent.noteSubject ?? "",
      actualEditdate: sent.actualEditdate ?? "",
      enDesc: sent.enDesc ?? "",
      replyStatus: sent.replyStatus?.toInt() ?? 0,
      noteBodyReply: sent.noteBodyReply,

      // ✅ Original Attachments
      noteFile: sent.noteFile,
      noteFile2: sent.noteFile2,
      noteFile3: sent.noteFile3,
      noteFile4: sent.noteFile4,
      noteFile5: sent.noteFile5,

      // ✅ Reply Attachments
      noteFileReply: sent.noteFileReply,
      noteFile2Reply: sent.noteFile2Reply,
      noteFile3Reply: sent.noteFile3Reply,
      noteFile4Reply: sent.noteFile4Reply,
      noteFile5Reply: sent.noteFile5Reply,

      viewedFlag: sent.viewedFlag,
    );
  }
}

import 'BaseMessage.dart';

List<String> getOriginalAttachments(BaseMessage msg) {
  return [
    msg.noteFile,
    msg.noteFile2,
    msg.noteFile3,
    msg.noteFile4,
    msg.noteFile5,
  ].where((file) => file != null && file.isNotEmpty).cast<String>().toList();
}

List<String> getReplyAttachments(BaseMessage msg) {
  return [
    msg.noteFileReply,
    msg.noteFile2Reply,
    msg.noteFile3Reply,
    msg.noteFile4Reply,
    msg.noteFile5Reply,
  ].where((file) => file != null && file.isNotEmpty).cast<String>().toList();
}

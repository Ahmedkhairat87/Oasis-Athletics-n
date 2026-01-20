class BaseMessage {
  // ✅ Basic Info
  final String studentNom;
  final String message; // Body of original message
  final String empName;
  final String noteSubject;
  final String actualEditdate;
  final String enDesc;

  // ✅ Reply Info
  final int replyStatus; // 0 = no reply | 1 = replied
  final String? noteBodyReply;

  // ✅ Original Attachments
  final String? noteFile;
  final String? noteFile2;
  final String? noteFile3;
  final String? noteFile4;
  final String? noteFile5;

  // ✅ Reply Attachments
  final String? noteFileReply;
  final String? noteFile2Reply;
  final String? noteFile3Reply;
  final String? noteFile4Reply;
  final String? noteFile5Reply;

  final String? viewedFlag;

  BaseMessage({
    required this.studentNom,
    required this.message,
    required this.empName,
    required this.noteSubject,
    required this.actualEditdate,
    required this.enDesc,

    // ✅ New Fields
    required this.replyStatus,
    this.noteBodyReply,

    // ✅ Original Attachments
    this.noteFile,
    this.noteFile2,
    this.noteFile3,
    this.noteFile4,
    this.noteFile5,

    // ✅ Reply Attachments
    this.noteFileReply,
    this.noteFile2Reply,
    this.noteFile3Reply,
    this.noteFile4Reply,
    this.noteFile5Reply,

    this.viewedFlag,
  });
}

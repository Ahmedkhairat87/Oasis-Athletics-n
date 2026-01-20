class Sent {
  Sent({
    this.msgSer,
    this.toType,
    this.fromType,
    this.empNo,
    this.enDesc,
    this.profNom,
    this.studentNom,
    this.gradeDesc,
    this.noteSubject,
    this.noteBody,
    this.replyStatus,
    this.viewedFlag,
    this.actualEditdate,
    this.empName,
    this.noteFile,
    this.noteFile2,
    this.noteFile3,
    this.noteFile4,
    this.noteFile5,
    this.noteBodyReply,
    this.noteFileReply,
    this.noteFile2Reply,
    this.noteFile3Reply,
    this.noteFile4Reply,
    this.noteFile5Reply,
  });

  Sent.fromJson(dynamic json) {
    msgSer = json['msg_ser'];
    toType = json['to_type'];
    fromType = json['from_type'];
    empNo = json['emp_no'];
    enDesc = json['EnDesc'];
    profNom = json['Prof_nom'];
    studentNom = json['student_nom'];
    gradeDesc = json['grade_desc'];
    noteSubject = json['note_subject'];
    noteBody = json['note_body'];
    replyStatus = json['reply_status'];
    viewedFlag = json['viewed_flag'];
    actualEditdate = json['actual_editdate'];
    empName = json['emp_name'];
    noteFile = json['note_file'];
    noteFile2 = json['note_file2'];
    noteFile3 = json['note_file3'];
    noteFile4 = json['note_file4'];
    noteFile5 = json['note_file5'];
    noteBodyReply = json['note_body_Reply'];
    noteFileReply = json['note_file_Reply'];
    noteFile2Reply = json['note_file2_Reply'];
    noteFile3Reply = json['note_file3_Reply'];
    noteFile4Reply = json['note_file4_Reply'];
    noteFile5Reply = json['note_file5_Reply'];
  }
  num? msgSer;
  num? toType;
  num? fromType;
  num? empNo;
  String? enDesc;
  String? profNom;
  String? studentNom;
  String? gradeDesc;
  String? noteSubject;
  String? noteBody;
  num? replyStatus;
  String? viewedFlag;
  String? actualEditdate;
  String? empName;
  String? noteFile;
  String? noteFile2;
  String? noteFile3;
  String? noteFile4;
  String? noteFile5;
  dynamic noteBodyReply;
  String? noteFileReply;
  String? noteFile2Reply;
  String? noteFile3Reply;
  String? noteFile4Reply;
  String? noteFile5Reply;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msg_ser'] = msgSer;
    map['to_type'] = toType;
    map['from_type'] = fromType;
    map['emp_no'] = empNo;
    map['EnDesc'] = enDesc;
    map['Prof_nom'] = profNom;
    map['student_nom'] = studentNom;
    map['grade_desc'] = gradeDesc;
    map['note_subject'] = noteSubject;
    map['note_body'] = noteBody;
    map['reply_status'] = replyStatus;
    map['viewed_flag'] = viewedFlag;
    map['actual_editdate'] = actualEditdate;
    map['emp_name'] = empName;
    map['note_file'] = noteFile;
    map['note_file2'] = noteFile2;
    map['note_file3'] = noteFile3;
    map['note_file4'] = noteFile4;
    map['note_file5'] = noteFile5;
    map['note_body_Reply'] = noteBodyReply;
    map['note_file_Reply'] = noteFileReply;
    map['note_file2_Reply'] = noteFile2Reply;
    map['note_file3_Reply'] = noteFile3Reply;
    map['note_file4_Reply'] = noteFile4Reply;
    map['note_file5_Reply'] = noteFile5Reply;
    return map;
  }
}

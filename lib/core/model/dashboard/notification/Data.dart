class Data {
  Data({
      this.serNo, 
      this.fatherID, 
      this.nTitle, 
      this.nSubTitle, 
      this.nBody, 
      this.nCategory, 
      this.mSGCategory, 
      this.nSerNo, 
      this.var1, 
      this.var2, 
      this.status, 
      this.editedDate,});

  Data.fromJson(dynamic json) {
    serNo = json['serNo'];
    fatherID = json['fatherID'];
    nTitle = json['nTitle'];
    nSubTitle = json['nSubTitle'];
    nBody = json['nBody'];
    nCategory = json['nCategory'];
    mSGCategory = json['MSGCategory'];
    nSerNo = json['nSerNo'];
    var1 = json['Var1'];
    var2 = json['Var2'];
    status = json['status'];
    editedDate = json['editedDate'];
  }
  num? serNo;
  num? fatherID;
  String? nTitle;
  String? nSubTitle;
  String? nBody;
  dynamic nCategory;
  dynamic mSGCategory;
  dynamic nSerNo;
  dynamic var1;
  String? var2;
  num? status;
  String? editedDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serNo'] = serNo;
    map['fatherID'] = fatherID;
    map['nTitle'] = nTitle;
    map['nSubTitle'] = nSubTitle;
    map['nBody'] = nBody;
    map['nCategory'] = nCategory;
    map['MSGCategory'] = mSGCategory;
    map['nSerNo'] = nSerNo;
    map['Var1'] = var1;
    map['Var2'] = var2;
    map['status'] = status;
    map['editedDate'] = editedDate;
    return map;
  }

}
class Data {
  Data({this.newsDate, this.fullPathE, this.fullPathF});

  Data.fromJson(Map<String, dynamic> json) {
    newsDate = json['news_date'];
    fullPathE = json['full_path_e'];
    fullPathF = json['full_path_f'];
  }
  String? newsDate;
  String? fullPathE;
  String? fullPathF;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['news_date'] = newsDate;
    map['full_path_e'] = fullPathE;
    map['full_path_f'] = fullPathF;
    return map;
  }
}

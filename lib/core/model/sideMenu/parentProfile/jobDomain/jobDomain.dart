class jobDomain {
  jobDomain({this.serno, this.jobdomain, this.jobdomainEn});

  jobDomain.fromJson(dynamic json) {
    serno = json['serno'];
    jobdomain = json['jobdomain'];
    jobdomainEn = json['jobdomain_en'];
  }
  num? serno;
  String? jobdomain;
  String? jobdomainEn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serno'] = serno;
    map['jobdomain'] = jobdomain;
    map['jobdomain_en'] = jobdomainEn;
    return map;
  }
}

import 'jobDomain.dart';

class JobDomainResponse {
  JobDomainResponse({this.data});

  JobDomainResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(jobDomain.fromJson(v));
      });
    }
  }
  List<jobDomain>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

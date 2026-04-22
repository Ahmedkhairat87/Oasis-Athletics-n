class StdDoctorDiet {
  StdDoctorDiet({
    this.dayOfWeek,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.snack,
    this.createdAt,
    this.note,
  });

  StdDoctorDiet.fromJson(dynamic json) {
    dayOfWeek = _toText(json['DayOfWeek']);
    breakfast = _toText(json['Breakfast']);
    lunch = _toText(json['Lunch']);
    dinner = _toText(json['Dinner']);
    snack = _toText(json['Snack']);
    createdAt = _toText(json['CreatedAt']);
    note = _toText(json['note']);
  }

  String? dayOfWeek;
  String? breakfast;
  String? lunch;
  String? dinner;
  String? snack;
  String? createdAt;
  String? note;

  Map<String, dynamic> toJson() {
    return {
      'DayOfWeek': dayOfWeek,
      'Breakfast': breakfast,
      'Lunch': lunch,
      'Dinner': dinner,
      'Snack': snack,
      'CreatedAt': createdAt,
      'note': note,
    };
  }

  static String _toText(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }
}
import 'ToTypes.dart';
import 'ToDepartment.dart';

class Categories {
  final List<ToCategory> toTypes;
  final List<ToDepartment> toDepartment;

  Categories({required this.toTypes, required this.toDepartment});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      toTypes:
          (json['toTypes'] as List).map((e) => ToCategory.fromJson(e)).toList(),

      toDepartment:
          (json['toDepartment'] as List)
              .map((e) => ToDepartment.fromJson(e))
              .toList(),
    );
  }
}

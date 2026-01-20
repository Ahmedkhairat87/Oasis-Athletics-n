// lib/models/athletics_report.dart
class AthleticsReport {
  final String id;
  final DateTime publishedAt;
  DateTime? readAt; // null => not read yet
  final String fileName; // pretend file

  AthleticsReport({
    required this.id,
    required this.publishedAt,
    this.readAt,
    required this.fileName,
  });

  bool get isRead => readAt != null;
}

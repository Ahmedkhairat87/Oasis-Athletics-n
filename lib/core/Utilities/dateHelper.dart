DateTime? parseApiDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return null;

  try {
    final parts = dateStr.split(' '); // "02 Oct 2025" -> ["02","Oct","2025"]
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final monthStr = parts[1];
    final year = int.tryParse(parts[2]);

    if (day == null || year == null) return null;

    final monthMap = {
      "Jan": 1,
      "Feb": 2,
      "Mar": 3,
      "Apr": 4,
      "May": 5,
      "Jun": 6,
      "Jul": 7,
      "Aug": 8,
      "Sep": 9,
      "Oct": 10,
      "Nov": 11,
      "Dec": 12,
    };

    final month = monthMap[monthStr];
    if (month == null) return null;

    return DateTime(year, month, day);
  } catch (_) {
    return null;
  }
}

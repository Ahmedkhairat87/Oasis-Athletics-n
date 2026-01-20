class NewsLetter {
  final List<NewsLetterRow> data;

  NewsLetter({required this.data});

  factory NewsLetter.fromJson(Map<String, dynamic> json) {
    final raw = json['Data'];

    if (raw == null || raw is! List) {
      return NewsLetter(data: []);
    }

    return NewsLetter(data: raw.map((e) => NewsLetterRow.fromJson(e)).toList());
  }
}

class NewsLetterRow {
  final String newsDate;
  final String fullPathE;
  final String fullPathF;

  NewsLetterRow({
    required this.newsDate,
    required this.fullPathE,
    required this.fullPathF,
  });

  factory NewsLetterRow.fromJson(Map<String, dynamic> json) {
    return NewsLetterRow(
      newsDate: json['news_date']?.toString() ?? '',
      fullPathE: json['full_path_e']?.toString() ?? '',
      fullPathF: json['full_path_f']?.toString() ?? '',
    );
  }
}

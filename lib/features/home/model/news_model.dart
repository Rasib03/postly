class NewsArticle {
  const NewsArticle({required this.publishedAt, this.description});

  final String publishedAt;
  final String? description;

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      publishedAt: json['publishedAt'] ?? '',
      description: json['description'],
    );
  }
}

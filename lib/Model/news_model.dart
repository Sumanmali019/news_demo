class NewsArticle {
  final String title;
  final String? description;
  final String? urlToImage;
  final String url;
  final String? author;
  final DateTime? publishedAt;
  final String? sourceName;

  NewsArticle({
    required this.title,
    this.description,
    this.urlToImage,
    required this.url,
    this.author,
    this.publishedAt,
    this.sourceName,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'],
      description: json['description'],
      urlToImage: json['urlToImage'],
      url: json['url'],
      author: json['author'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
      sourceName: json['source'] != null ? json['source']['name'] : null,
    );
  }
}

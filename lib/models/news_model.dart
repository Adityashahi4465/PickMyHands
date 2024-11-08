import 'dart:convert';

class NewsData {
  final String title;
  final String description;
  final String author;
  final String imageUrl;
  final String writeup;
  final String url;
  final String publishedAt;

  NewsData({
    required this.title,
    required this.description,
    required this.author,
    required this.imageUrl,
    required this.writeup,
    required this.url,
    required this.publishedAt,
  });

  NewsData copyWith({
    String? title,
    String? description,
    String? author,
    String? imageUrl,
    String? writeup,
    String? url,
    String? publishedAt,
  }) {
    return NewsData(
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      writeup: writeup ?? this.writeup,
      url: url ?? this.url,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'author': author,
      'imageUrl': imageUrl,
      'writeup': writeup,
      'url': url,
      'publishedAt': publishedAt,
    };
  }

  factory NewsData.fromMap(Map<String, dynamic> map) {
    return NewsData(
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      author: map['author'] as String? ?? '',
      imageUrl: map['urlToImage'] as String? ?? '',
      writeup: map['content'] as String? ?? '',
      url: map['url'] as String? ?? '',
      publishedAt: map['publishedAt'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsData.fromJson(String source) =>
      NewsData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NewsData(title: $title, description: $description, author: $author, imageUrl: $imageUrl, writeup: $writeup, url: $url, publishedAt: $publishedAt)';
  }

  @override
  bool operator ==(covariant NewsData other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.description == description &&
        other.author == author &&
        other.imageUrl == imageUrl &&
        other.writeup == writeup &&
        other.url == url &&
        other.publishedAt == publishedAt;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        author.hashCode ^
        imageUrl.hashCode ^
        writeup.hashCode ^
        url.hashCode ^
        publishedAt.hashCode;
  }
}

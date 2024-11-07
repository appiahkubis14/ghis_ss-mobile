// // ignore_for_file: empty_constructor_bodies

import 'package:ghis_ss/src/model/source_model.dart';

// class ArticleMOdel {
//   NewsModel source;
//   String author;
//   String title;
//   String description;
//   String url;
//   String urlToImage;
//   String publishedAt;
//   String content;

//   ArticleMOdel({
//     required this.source,
//     required this.author,
//     required this.title,
//     required this.description,
//     required this.url,
//     required this.urlToImage,
//     required this.publishedAt,
//     required this.content,
//   });

//   factory ArticleMOdel.fromjson(Map<String, dynamic> json) {
//     return ArticleMOdel(
//       source: NewsModel.fromjson(json['source']),
//       author: json['author'] as String,
//       title: json['title'] as String,
//       description: json['description'] as String,
//       url: json['url'] as String,
//       urlToImage: json['urlToImage'] as String,
//       publishedAt: json['publishedAt'] as String,
//       content: json['content'] as String,
//     );
//   }
// }

//Now let's create the article model
// for that we just need to copy the property from the json structure
// and make a dart object

class Article {
  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  //Now let's create the constructor
  Article(
      {this.source,
      this.author,
      this.title,
      this.description,
      this.url,
      this.urlToImage,
      this.publishedAt,
      this.content});

  //And now let's create the function that will map the json into a list
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source']),
      author: json['author'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      urlToImage: json['urlToImage'] as String,
      publishedAt: json['publishedAt'] as String,
      content: json['content'] as String,
    );
  }
}

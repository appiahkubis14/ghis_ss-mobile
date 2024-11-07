import 'dart:convert';

import 'package:ghis_ss/src/model/article_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final endPointUrl =
      'https://newsapi.org/v2/everything?q=bitcoin&apiKey=c98c97d13d9947469c871baa853968fe';

  Future<List<Article>> getArticle() async {
    http.Response res = await http.get(Uri.parse(endPointUrl));
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonEncode(res.body) as Map<String, dynamic>;
      List<dynamic> body = json['articles'];
      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();
      return articles;
    } else {
      throw ("Can't get the artcles");
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({Key? key, this.userData}) : super(key: key);
  final Map<String, dynamic>? userData;

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  final String api = 'c98c97d13d9947469c871baa853968fe';
  final String country = 'us';
  late Future<List<Article>> _futureArticles;
  late TextEditingController _searchController;
  bool _isSearchExpanded = false;
  final Duration refreshInterval =
      const Duration(minutes: 5); // Refresh interval

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _futureArticles = fetchArticles();
    // Start a periodic timer to refresh news at regular intervals
    Timer.periodic(refreshInterval, (_) => _futureArticles = fetchArticles());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Article>> fetchArticles() async {
    final response = await http.get(
      Uri.parse(
          'https://newsapi.org/v2/everything?q=engineering%20surveying&apiKey=$api'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> articlesJson = json['articles'];
      _articles = articlesJson
          .map<Article>((articleJson) => Article.fromJson(articleJson))
          .toList();
      _filteredArticles = List.from(_articles); // Initialize filtered list
      setState(() {}); // Update the UI with new data
      return _articles;
    } else {
      throw Exception('Failed to load articles');
    }
  }

  List<Article> filterArticles(String query) {
    if (query.isEmpty) {
      return List.from(_articles);
    } else {
      return _articles.where((article) {
        return (article.title?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (article.description?.toLowerCase().contains(query.toLowerCase()) ??
                false);
      }).toList();
    }
  }

  void refreshArticles() {
    setState(() {
      _futureArticles = fetchArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest News'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearchExpanded = !_isSearchExpanded;
                if (!_isSearchExpanded) {
                  // Clear search text and reset filtered articles
                  _searchController.clear();
                  _filteredArticles =
                      _articles; // Assuming articles is your original list
                }
              });
            },
            icon: const Icon(Icons.search),
          ),
        ],
        bottom: _isSearchExpanded
            ? PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 60,
                  width: MediaQuery.of(context).size.width - 40,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _filteredArticles = filterArticles(value);
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: refreshArticles,
                        ),
                        hintText: 'Search...',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: FutureBuilder<List<Article>>(
        future: _futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("OOPS !!"),
                  Text("You're offline! Check network connection"),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: _filteredArticles.length,
              itemBuilder: (context, index) {
                final article = _filteredArticles[index];
                return ListTile(
                  title: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: article.imageUrl ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          article.description ?? '',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticlePage(article: article),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Article {
  final String? title;
  final String? description;
  final String? author;
  final String? publishedAt;
  final String? sourceName;
  final String? content;
  final String? imageUrl;

  Article({
    required this.title,
    required this.description,
    required this.author,
    required this.publishedAt,
    required this.sourceName,
    required this.content,
    required this.imageUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      author: json['author'],
      publishedAt: json['publishedAt'],
      sourceName: json['source']['name'],
      content: json['content'],
      imageUrl: json['urlToImage'],
    );
  }
}

class ArticlePage extends StatelessWidget {
  final Article article;

  const ArticlePage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest News'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text(
                  article.title ?? '',
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                article.description ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl ?? '',
                  placeholder: (context, url) =>
                      const CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Author: ${article.author ?? 'Unknown'}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Published At: ${_formatDateTime(article.publishedAt)}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              Text(
                'Source: ${article.sourceName ?? 'Unknown'}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              Text(
                'Content: ${article.content ?? ''}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) return 'Unknown';
    DateTime dateTime = DateTime.parse(dateTimeString);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${_formatTime(dateTime)}';
  }

  String _formatTime(DateTime dateTime) {
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

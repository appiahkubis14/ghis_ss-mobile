import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghis_ss/src/news/news_web_view.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';
import 'package:news_api_flutter_package/model/article.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<Article>> future;
  String? searchTerm;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  List<String> categoryItems = [
    "GENERAL",
    "BUSINESS",
    "ENTERTAINMENT",
    "HEALTH",
    "SCIENCE",
    "SPORTS",
    "TECHNOLOGY",
  ];

  late String selectedCategory;

  @override
  void initState() {
    selectedCategory = categoryItems[4];
    future = getNewsData();

    super.initState();
  }

  Future<List<Article>> getNewsData() async {
    NewsAPI newsAPI = NewsAPI(apiKey: 'c98c97d13d9947469c871baa853968fe');
    return await newsAPI.getTopHeadlines(
      country: "us",
      query: searchTerm,
      category: selectedCategory,
      pageSize: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: isSearching ? searchAppBar() : appBar(),
      body: SafeArea(
          child: Column(
        children: [
          _buildCategories(),
          Expanded(
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                        "Error loading the news ; check internet connection."),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return _buildNewsListView(snapshot.data as List<Article>);
                  } else {
                    return const Center(
                      child: Text("No news available"),
                    );
                  }
                }
              },
              future: future,
            ),
          )
        ],
      )),
    );
  }

  // searchAppBar() {
  //   return AppBar(
  //     elevation: 10,
  //     leading: IconButton(
  //       icon: const Icon(Icons.arrow_back),
  //       onPressed: () {
  //         setState(() {
  //           isSearching = false;
  //           searchTerm = null;
  //           searchController.text = "";
  //           future = getNewsData();
  //         });
  //       },
  //     ),
  //     title: TextField(
  //       controller: searchController,
  //       style: const TextStyle(color: Colors.white),
  //       cursorColor: Colors.white,
  //       decoration: const InputDecoration(
  //         hintText: "Search",
  //         hintStyle: TextStyle(color: Colors.white70),
  //         enabledBorder: UnderlineInputBorder(
  //           borderSide: BorderSide(color: Colors.transparent),
  //         ),
  //         focusedBorder: UnderlineInputBorder(
  //           borderSide: BorderSide(color: Colors.transparent),
  //         ),
  //       ),
  //     ),
  //     actions: [
  //       IconButton(
  //           onPressed: () {
  //             setState(() {
  //               searchTerm = searchController.text;
  //               future = getNewsData();
  //             });
  //           },
  //           icon: const Icon(Icons.search)),
  //     ],
  //   );
  // }

  // appBar() {
  //   return AppBar(
  //     elevation: 10,
  //     title: const Text("NEWS NOW"),
  //     actions: [
  //       IconButton(
  //           onPressed: () {
  //             setState(() {
  //               isSearching = true;
  //             });
  //           },
  //           icon: const Icon(Icons.search)),
  //     ],
  //   );
  // }

  Widget _buildNewsListView(List<Article> articleList) {
    return ListView.builder(
      itemBuilder: (context, index) {
        Article article = articleList[index];
        return _buildNewsItem(article);
      },
      itemCount: articleList.length,
    );
  }

  Widget _buildNewsItem(Article article) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsWebView(url: article.url!),
          ),
        );
      },
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.network(
                    article.urlToImage ?? "",
                    fit: BoxFit.fitHeight,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title!,
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    article.source.name!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedCategory = categoryItems[index];
                  future = getNewsData();
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  categoryItems[index] == selectedCategory
                      ? const Color.fromARGB(255, 162, 165, 204)
                          .withOpacity(0.5)
                      : const Color.fromARGB(255, 228, 228, 230),
                ),
              ),
              child: Text(categoryItems[index]),
            ),
          );
        },
        itemCount: categoryItems.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

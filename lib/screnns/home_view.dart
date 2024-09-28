import 'dart:convert';
import 'package:bitcoinnews/models/fatch_news.dart';
import 'package:bitcoinnews/screnns/news_detal_view.dart';
import 'package:bitcoinnews/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<List<FatechNews>?> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews("bitcoin");
  }

  Future<List<FatechNews>?> fetchNews(String query) async {
    var url = Uri.parse(
        "https://newsapi.org/v2/everything?q=$query&apiKey=76ad820c183d428988fa014f4eb3e12c");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        List<FatechNews> newsList = [];
        for (var articleJson in jsonData['articles']) {
          newsList.add(FatechNews.fromJson(articleJson));
        }
        return newsList;
      } else {
        print("Failed to load news. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred while fetching news: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/bitcoin.jpeg'),
                ),
                const SizedBox(width: 30),
                Text(
                  "Bitcoin updates",
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: AppColors.secondaryColor),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 5),
            TextField(
              style: TextStyle(color: AppColors.secondaryColor),
              decoration: InputDecoration(
                hintText: "Search News",
                hintStyle:
                    TextStyle(color: AppColors.secondaryColor.withOpacity(0.7)),
                prefixIcon: Icon(Icons.search, color: AppColors.secondaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.secondaryColor),
                ),
                filled: true,
                fillColor: AppColors.primaryColor,
              ),
              onSubmitted: (value) {
                setState(() {
                  futureNews = fetchNews(value);
                });
              },
            ),
            const SizedBox(height: 5),
            Expanded(
              child: FutureBuilder<List<FatechNews>?>(
                future: futureNews,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error occurred while fetching news.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available.'));
                  } else {
                    final articles = snapshot.data!;
                    return ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (BuildContext context, int index) {
                        final article = articles[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewsDetailView(news: article),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        article.urlToImage ??
                                            'https://via.placeholder.com/150'),
                                  ),
                                  title:
                                      Text(article.author ?? 'Unknown Author'),
                                  subtitle: Text(article.publishedAt ??
                                      'No time available'),
                                ),
                                Container(
                                  height: 180,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(article.urlToImage ??
                                          'https://via.placeholder.com/150'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    article.title ?? 'No title available',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.thumb_up,
                                              color: Colors.grey),
                                          const SizedBox(width: 5),
                                          const Text('Like'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.comment,
                                              color: Colors.grey),
                                          const SizedBox(width: 5),
                                          const Text('Comment'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

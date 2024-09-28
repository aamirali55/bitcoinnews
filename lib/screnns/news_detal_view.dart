import 'package:flutter/material.dart';
import 'package:bitcoinnews/models/fatch_news.dart';
import 'package:bitcoinnews/utils/app_colors.dart';

class NewsDetailView extends StatelessWidget {
  final FatechNews news;

  const NewsDetailView({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          news.title ?? 'News Detail',
          style: TextStyle(
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            news.urlToImage != null
                ? Image.network(
                    news.urlToImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(child: Text('No Image Available')),
                  ),
            const SizedBox(height: 10),
            Text(
              news.title ?? 'No title available',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "By: ${news.author ?? 'Unknown Author'}",
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 5),
            Text(
              "Published at: ${news.publishedAt ?? 'No time available'}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              news.description ?? 'No description available',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

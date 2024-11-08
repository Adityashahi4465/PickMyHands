import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../models/news_model.dart';
import '../../../../auth/controller/auth_controller.dart';
import '../../widgets/item_travel_news.dart';
import 'package:http/http.dart' as http;

class HomeScreenNews extends ConsumerStatefulWidget {
  const HomeScreenNews({super.key});

  @override
  ConsumerState createState() => HomeScreenNewsState();
}

class HomeScreenNewsState extends ConsumerState<HomeScreenNews> {
  String searchQuery = '';
  List<NewsData> newsList = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    const apiUrl =
        'https://newsapi.org/v2/everything?q=accessibility&apiKey=f61018259285447c93ce60952f2546e6';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];

        setState(() {
          newsList = articles
              .map((article) =>
                  NewsData.fromMap(article as Map<String, dynamic>))
              .toList();
        });
      } else {
        // Handle errors
        print('Failed to load news. Error ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    print(newsList);
    List<NewsData> filteredNews = newsList.where((news) {
      final titleLower = news.title.toLowerCase();
      final descriptionLower = news.description.toLowerCase();
      final authorLower = news.author.toLowerCase();
      final queryLower = searchQuery.toLowerCase();

      return titleLower.contains(queryLower) ||
          descriptionLower.contains(queryLower) ||
          authorLower.contains(queryLower);
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePicture),
                      radius: 40,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'News',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      'Expand your horizons.',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 5),
                            color:
                                Theme.of(context).primaryColor.withOpacity(.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: const InputDecoration(
                          prefixIcon:
                              Icon(CupertinoIcons.search, color: Colors.grey),
                          filled: true,
                          hintText: 'Search',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                      margin: const EdgeInsets.only(top: 15),
                    ),
                    GridView.count(
                      padding: const EdgeInsets.only(top: 10),
                      crossAxisCount: 1,
                      shrinkWrap: true,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 15,
                      physics: NeverScrollableScrollPhysics(),
                      children: filteredNews.map((newsData) {
                        return ItemTravelNews(
                          newsData: newsData,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// item_travel_news.dart
import 'package:flutter/material.dart';

import '../../../../../../../models/news_model.dart';
import '../feed/news/details_screen_news.dart';

class ItemTravelNews extends StatelessWidget {
  final NewsData newsData;

  const ItemTravelNews({super.key, required this.newsData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => DetailsScreenNews(newsData: newsData)),
      ),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(newsData.imageUrl),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Text(newsData.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
            ),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: Colors.grey, size: 18),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    newsData.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

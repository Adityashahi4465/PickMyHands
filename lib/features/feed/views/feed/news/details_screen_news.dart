import 'package:flutter/material.dart';

import '../../../../../models/news_model.dart';

class DetailsScreenNews extends StatelessWidget {
  final NewsData newsData;
  const DetailsScreenNews({super.key, required this.newsData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: Text(newsData.title),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Image.network(
            newsData.imageUrl,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Container(
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.only(bottom: 100),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          newsData.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          newsData.author,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    newsData.description,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    newsData.writeup,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      // bottomSheet: Container(
      //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
      //   width: double.infinity,
      //   child: ElevatedButton(
      //     onPressed: () {},
      //     style: ElevatedButton.styleFrom(
      //         padding: const EdgeInsets.all(15),
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(50)
      //         )
      //     ),
      //     child: const Text('Add to bookmarks'),
      //   ),
      // ),
    );
  }
}

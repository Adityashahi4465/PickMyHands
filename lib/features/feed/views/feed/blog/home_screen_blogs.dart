import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/common/error_text.dart';
import '../../../../../core/common/loader.dart';
import '../../../controller/feed_controller.dart';
import 'write_blog.dart';
import '../../widgets/article_overview_card.dart';

class HomeScreenBlog extends ConsumerWidget {
  const HomeScreenBlog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
      ),
      body: ref.watch(userArticleProvider).when(
            data: (data) {
              print(data[0].brief);
              return ListView.builder(
                physics:
                    const ClampingScrollPhysics(), // By Using this List Become Scrollable
                controller: ScrollController(initialScrollOffset: 0),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final articles = data[index];
                  return PostOverviewCard(
                    articles: articles,
                  );
                },
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WriteBlog()),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}

import 'package:intl/intl.dart';

/// Import this line
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common/error_text.dart';
import '../../../../../core/common/loader.dart';
import '../../../../user/controller/user_controller.dart';
import '../../../controller/feed_controller.dart';

class ArticleScreen extends ConsumerStatefulWidget {
  final String? articleId;
  const ArticleScreen({required this.articleId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen> {
  // final commentController = TextEditingController();

  // @override
  // void dispose() {
  //   super.dispose();
  //   commentController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getArticleByIdProvider(widget.articleId!)).when(
          data: (article) {
            return ref
                .watch(getUserDataByIdProvider(article.author.toString()))
                .when(
                  data: (user) {
                    print('article Screen is calling in user ref');
                    return Scaffold(
                      body: CustomScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        controller: ScrollController(initialScrollOffset: 0),
                        shrinkWrap: true,
                        slivers: [
                          SliverAppBar(
                            toolbarHeight: 80,
                            bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(25),
                              child: Container(
                                width: double.maxFinite,
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 10),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF9333EA),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: SelectableText(
                                    article.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            pinned: true,
                            backgroundColor: const Color(0xFFC026D3),
                            expandedHeight: 300,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Image.network(
                                article.bannerImage.toString(),
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset('assets/images/onboardin1.jpg'),
                                width: double.maxFinite,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.profilePicture),
                                  ),
                                  const SizedBox(
                                    width: 18,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat('MMM dd, yyyy').format(
                                                article.postedOn.toDate()),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '${article.postLength.toString()}min read',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  article.brief.toString(),
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(8).copyWith(top: 20),
                              child: Text(
                                article.body.toString(),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(left: 6, right: 6),
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                );
          },
          error: (error, stackTrace) {
            return ErrorText(error: error.toString());
          },
          loading: () => const Loader(),
        );
  }
}

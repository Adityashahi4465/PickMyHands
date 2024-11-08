import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/common/error_text.dart';
import '../../../../core/common/loader.dart';
import '../../../../models/article_model.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../user/controller/user_controller.dart';
import '../../controller/feed_controller.dart';
import '../feed/blog/article_details_view.dart';

// ignore: must_be_immutable
class PostOverviewCard extends ConsumerStatefulWidget {
  Articles articles;
  PostOverviewCard({super.key, required this.articles});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostOverviewCardState();
}

class _PostOverviewCardState extends ConsumerState<PostOverviewCard> {
  void deleteArticle(WidgetRef ref, BuildContext context) async {
    ref
        .read(articleControllerProvider.notifier)
        .deleteArticle(widget.articles, context);
  }

  void upVote(WidgetRef ref, BuildContext context) async {
    ref.read(articleControllerProvider.notifier).upVote(widget.articles);
  }

  void downVote(WidgetRef ref, BuildContext context) async {
    ref.read(articleControllerProvider.notifier).downVote(widget.articles);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userProvider)!;

    print('Card Build Method called');
    return ref.watch(getUserDataByIdProvider(widget.articles.author)).when(
          data: (user) {
            return Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              elevation: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Ink.image(
                        height: 240,
                        onImageError: (exception, stackTrace) => Image.asset(
                          'assets/images/js.jpg',
                          fit: BoxFit.cover,
                          height: 240,
                        ),
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.articles.bannerImage.toString(),
                        ),
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: ((context) => ArticleScreen(
                                  articleId: widget.articles.id)),
                            ),
                          ),
                        ),
                      ),
                      // Positioned(
                      //   bottom: 16,
                      //   right: 16,
                      //   left: 16,
                      //   child:
                      // )
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 10, top: 3),
                    child: Text(
                      widget.articles.title.toString(),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0)
                        .copyWith(bottom: 0, top: 5),
                    child: SelectableText(
                      widget.articles.brief.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(user.profilePicture),
                              foregroundImage:
                                  NetworkImage(user.profilePicture),
                              backgroundColor: Colors.deepPurple,
                              radius: 15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              user.name.toString().length > 10
                                  ? user.name.substring(0, 10)
                                  : user.name,
                              // widget.widget.articles.author!,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pinkAccent[400]),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.20,
                              height:
                                  MediaQuery.of(context).size.height * 0.06,
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple[200],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30))),
                              child: Center(
                                child: Text(
                                  widget.articles.category.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.share,
                              size: MediaQuery.of(context).size.width * 0.08,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => upVote(ref, context),
                              icon: Icon(
                                Icons.thumb_up,
                                color: widget.articles.upVotes
                                        .contains(currentUser.email)
                                    ? Colors.red
                                    : Theme.of(context).primaryColor,
                                size:
                                    MediaQuery.of(context).size.width * 0.08,
                              ),
                            ),
                            Text(
                              '${widget.articles.upVotes.length - widget.articles.downVotes.length == 0 ? 'Vote' : widget.articles.upVotes.length - widget.articles.downVotes.length}',
                            ),
                            IconButton(
                              onPressed: () => downVote(ref, context),
                              icon: Icon(
                                Icons.thumb_down,
                                color: widget.articles.downVotes
                                        .contains(currentUser.email)
                                    ? Colors.red
                                    : Theme.of(context).primaryColor,
                                size:
                                    MediaQuery.of(context).size.width * 0.08,
                              ),
                            ),
                          ],
                        ),
                        if (widget.articles.author == currentUser.email)
                          IconButton(
                            onPressed: () => deleteArticle(ref, context),
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: MediaQuery.of(context).size.width * 0.08,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'blog/welcome_screen_blog.dart';
import 'news/welcome_screen_news.dart';

class FeedHome extends ConsumerStatefulWidget {
  const FeedHome({super.key});

  @override
  ConsumerState<FeedHome> createState() => _FeedHomeState();
}

class _FeedHomeState extends ConsumerState<FeedHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text(
                    'FEED',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  subtitle: Text('A world of exploration!',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white54)),
                  trailing: const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/user.jpg'),
                  ),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.25,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(200),
                ),
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomeScreenNews()),
                      );
                    },
                    child: itemDashboard(
                      title: 'News',
                      iconData: CupertinoIcons.play_rectangle,
                      backgroundColor: Colors.deepOrange,
                      textColor: Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomeScreenBlog()),
                      );
                    },
                    child: itemDashboard(
                      title: 'Blogs',
                      iconData: CupertinoIcons.graph_circle,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemDashboard({
    required String title,
    required IconData iconData,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade400, //the colour of boxes
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                ),
          ),
        ],
      ),
    );
  }
}

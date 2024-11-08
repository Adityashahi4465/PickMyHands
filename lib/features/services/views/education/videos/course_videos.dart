import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../theme/font_provider.dart';
import 'video.dart';

class Videos extends ConsumerStatefulWidget {
  final List<String> videoLinks;
  final String courseTitle;

  const Videos({
    Key? key,
    required this.videoLinks,
    required this.courseTitle,
  }) : super(key: key);

  @override
  ConsumerState createState() => VideosState();
}

class VideosState extends ConsumerState<Videos> {
  void _incrementClickCount() {
    int clickCount = prefs.getInt('video_click_count') ?? 0; // Step 2
    clickCount += 10;
    prefs.setInt('video_click_count', clickCount); // Step 3
  }

  late SharedPreferences prefs; // Step 1

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = ref.watch(fontSizesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.courseTitle,
        ),
      ),
      body: ListView.builder(
        itemCount: widget.videoLinks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                _incrementClickCount();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VideoScreen(
                      videoLinks: widget.videoLinks[index],
                      courseTitle: widget.courseTitle,
                    ),
                  ),
                );
              },
              title: Text(
                'Video Tutorial ${index}',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: fontSize.headingSize,
                    ),
              ),
              subtitle: Text(
                widget.videoLinks[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: fontSize.subheadingSize - 8,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}

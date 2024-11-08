import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String videoLinks;
  final String courseTitle;

  const VideoScreen({
    Key? key,
    required this.videoLinks,
    required this.courseTitle,
  }) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoLinks)!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: YoutubePlayerBuilder(
                player: YoutubePlayer(controller: _controller),
                builder: (context, player) {
                  return Column(
                    children: [
                      player,
                      const SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _controller.metadata.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

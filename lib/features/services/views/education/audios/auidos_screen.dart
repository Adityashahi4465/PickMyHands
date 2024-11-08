import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioScreen extends StatefulWidget {
  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  String currentAudio = '';

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        setState(() {
          isPlaying = true;
        });
      } else if (state == PlayerState.paused) {
        setState(() {
          isPlaying = false;
        });
      } else if (state == PlayerState.completed) {
        setState(() {
          isPlaying = false;
          currentAudio = '';
        });
      }
    });
  }

  void playAudio(String assetPath) {
    if (isPlaying && currentAudio == assetPath) {
      // If audio is playing, pause it
      audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      // If audio is paused, resume it
      if (audioPlayer.state == PlayerState.paused) {
        audioPlayer.resume();
        setState(() {
          isPlaying = true;
        });
      } else {
        // If audio is stopped or not started, play from the beginning
        audioPlayer.play(
          AssetSource(assetPath),
          volume: 1.0,
          position: const Duration(milliseconds: 0),
        );
        setState(() {
          currentAudio = assetPath;
          isPlaying = true;
        });
      }
    }
  }

  void stopAudio() {
    audioPlayer.stop();
    setState(() {
      isPlaying = false;
      currentAudio = '';
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Courses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildAudioTile('Audio Tutorial 1', 'images/audio1.mp3'),
            const SizedBox(height: 16),
            buildAudioTile('Audio Tutorial 2', 'images/audio2.mp3'),
            const SizedBox(height: 16),
            buildAudioTile('Audio Tutorial 3', 'images/audio3.mp3'),
            const SizedBox(height: 16),
            Text(
              currentAudio != ""
                  ? 'Currently Playing: ${currentAudio.substring(7)}'
                  : 'No audio is playing',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text(
                    'Play',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () => playAudio('images/audio1.mp3'),
                ),
                TextButton(
                  onPressed: isPlaying ? () => stopAudio() : null,
                  child: const Text(
                    'Pause',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAudioTile(String title, String assetPath) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.music_note),
        onTap: () => playAudio(assetPath),
      ),
    );
  }
}

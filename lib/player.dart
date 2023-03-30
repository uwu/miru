import 'package:flutter/material.dart';
import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';

class Player extends StatefulWidget {
  const Player({super.key, required this.streamUrl, required this.episodeId});
  final String streamUrl;
  final String episodeId;

  @override
  PlayerState createState() => PlayerState();
}

class PlayerState extends State<Player> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: YoYoPlayer(
        allowCacheFile: true,
        displayFullScreenAfterInit: true,
        aspectRatio: 16 / 9,
        url: widget.streamUrl,
        videoStyle: const VideoStyle(),
        videoLoadingStyle: VideoLoadingStyle(
          loading: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
        onFullScreen: (fullScreenTurnedOn) {
          if (!fullScreenTurnedOn) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

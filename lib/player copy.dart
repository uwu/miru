import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class Player extends StatefulWidget {
  const Player({super.key, required this.streamUrl, required this.episodeId});
  final String streamUrl;
  final String episodeId;

  @override
  PlayerState createState() => PlayerState();
}

class PlayerState extends State<Player> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;
  int? bufferDelay;
  bool isExiting = false;

  void _handleStateChange() {
    if (_chewieController == null) return;
    if (!_chewieController!.isFullScreen && !isExiting) {
      _chewieController!.pause();
      isExiting = true;
      Navigator.pop(context);
    }
  }

  void _handlePositionUpdate() {
    // TODO: Update watch position in hive
    print(
        "Updating watch positon for ${widget.episodeId} to ${_controller.value.position}");
    // If value is close enough to the end, mark as watched
    if (_controller.value.position.inSeconds >
        _controller.value.duration.inSeconds - 120) {
      print("Marking ${widget.episodeId} as watched");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.streamUrl);

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      autoInitialize: true,
      fullScreenByDefault: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
      ],
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      optionsBuilder: (context, defaultOptions) async {
        PopupMenuButton<String>(
          onSelected: (String result) {},
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Settings',
              child: Text('Settings'),
            ),
            const PopupMenuItem<String>(
              value: 'About',
              child: Text('About'),
            ),
          ],
        );
      },
      showControlsOnInitialize: false,
      allowPlaybackSpeedChanging: true,
      playbackSpeeds: [0.25, 0.5, 1.0, 1.25, 1.5, 2.0],
      placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(),
          )),
    );
    _controller.addListener(_handlePositionUpdate);
    _chewieController?.addListener(_handleStateChange);
    setState(() {});
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _chewieController?.removeListener(_handleStateChange);
    _chewieController?.dispose();
    _controller.removeListener(_handlePositionUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController!,
    );
  }
}

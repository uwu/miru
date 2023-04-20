import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import 'player_controls.dart';

class Player extends StatefulWidget {
  const Player({super.key, required this.streamUrl, required this.episodeId});
  final String streamUrl;
  final String episodeId;

  @override
  PlayerState createState() => PlayerState();
}

class PlayerState extends State<Player> {
  late VlcPlayerController _videoPlayerController;
  Duration length = Duration.zero;
  Duration maxSeenPosition = Duration.zero;

  void _handleStateChange() async {
    if (length.inSeconds == 0) {
      length = _videoPlayerController.value.duration;
      return;
    }

    final currentPosition = _videoPlayerController.value.position;
    if (currentPosition.inSeconds > length.inSeconds - 120) {
      print("Marking ${widget.episodeId} as watched");
    }
    // If current position is greater than max seen position, update max seen position
    if (currentPosition > maxSeenPosition) {
      maxSeenPosition = currentPosition;
      print(
          "Updating watch position for ${widget.episodeId} to $maxSeenPosition");
    }
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _videoPlayerController = VlcPlayerController.network(
      widget.streamUrl,
      hwAcc: HwAcc.auto,
      autoPlay: true,
      options: VlcPlayerOptions(
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.liveCaching(30000),
          ]),
          http: VlcHttpOptions([
            VlcHttpOptions.httpReconnect(true),
          ]),
          video: VlcVideoOptions([
            VlcVideoOptions.dropLateFrames(true),
          ])),
    );
    _videoPlayerController.addListener(_handleStateChange);
    _videoPlayerController.addOnInitListener(() async {
      await _videoPlayerController.startRendererScanning();
    });
    setState(() {});
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    //_videoPlayerController.stopRecording();
    _videoPlayerController.stopRendererScanning();
    _videoPlayerController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        _buildPlayer(),
        _buildControls(),
      ],
    );
  }

  Widget _buildPlayer() {
    return SizedBox.expand(
      child: VlcPlayer(
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        controller: _videoPlayerController,
        placeholder: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildControls() {
    return ControlsOverlay(
      controller: _videoPlayerController,
    );
  }
}

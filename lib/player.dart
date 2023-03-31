import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class Player extends StatefulWidget {
  const Player({super.key, required this.streamUrl, required this.episodeId});
  final String streamUrl;
  final String episodeId;

  @override
  PlayerState createState() => PlayerState();
}

class PlayerState extends State<Player> {
  late VlcPlayerController _videoPlayerController;
  late Duration length;
  Duration maxSeenPosition = Duration.zero;

  void _handleStateChange() async {
    if (length.inSeconds == 0) {
      return;
    }

    final currentPosition = await _videoPlayerController.getPosition();
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
    _videoPlayerController = VlcPlayerController.network(
      widget.streamUrl,
      hwAcc: HwAcc.auto,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );
    _videoPlayerController.addListener(_handleStateChange);
    _videoPlayerController.addOnInitListener(() async {
      await _videoPlayerController.startRendererScanning();
      length = await _videoPlayerController.getDuration();
    });
    setState(() {});
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    //_videoPlayerController.stopRecording();
    _videoPlayerController.stopRendererScanning();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VlcPlayer(
      aspectRatio: 16 / 9,
      controller: _videoPlayerController,
      placeholder: const Center(child: CircularProgressIndicator()),
    );
  }
}

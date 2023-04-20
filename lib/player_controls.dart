import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:async/async.dart';

class ControlsOverlay extends StatefulWidget {
  const ControlsOverlay({super.key, required this.controller});

  final VlcPlayerController controller;

  @override
  ControlsOverlayState createState() => ControlsOverlayState();
}

class ControlsOverlayState extends State<ControlsOverlay>
    with TickerProviderStateMixin {
  static const double _playButtonIconSize = 16;
  static const double _replayButtonIconSize = 16;
  static const double _seekButtonIconSize = 12;

  static const Duration _seekStepForward = Duration(seconds: 10);
  static const Duration _seekStepBackward = Duration(seconds: -10);

  static const Color _iconColor = Colors.white;

  late AnimationController _playAnimationController;
  late AnimationController _controlsAnimationController;

  void _handleStateChange() {
    setState(() {});
  }

  double _getProgress() {
    if (widget.controller.value.duration.inSeconds == 0) {
      return 0.0;
    }

    if (isScrubbing) {
      return lastScrubValue;
    }

    return widget.controller.value.position.inSeconds /
        widget.controller.value.duration.inSeconds;
  }

  String _getElapsedTime() {
    if (isScrubbing) {
      return _formatDuration(
        Duration(
          milliseconds:
              (lastScrubValue * widget.controller.value.duration.inMilliseconds)
                  .round(),
        ),
      );
    }

    return _formatDuration(widget.controller.value.position);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  bool showControls = false;
  RestartableTimer? _hideControlsOperation;

  bool isScrubbing = false;
  double lastScrubValue = 0.0;

  Widget _controlRow() {
    return SizedBox.expand(
      child: GestureDetector(
        onTap: _handleControlShowTap,
        child: FadeTransition(
          opacity: _controlsAnimationController,
          child: Container(
            color: Colors.black54,
            child: FittedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -4),
                    onPressed: () => _seekRelative(_seekStepBackward),
                    color: _iconColor,
                    iconSize: _seekButtonIconSize,
                    icon: const Icon(Icons.replay_10),
                  ),
                  IconButton(
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -4),
                    onPressed: _playPause,
                    color: _iconColor,
                    iconSize: _playButtonIconSize,
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: _playAnimationController,
                    ),
                  ),
                  IconButton(
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -4),
                    onPressed: () => _seekRelative(_seekStepForward),
                    color: _iconColor,
                    iconSize: _seekButtonIconSize,
                    icon: const Icon(Icons.forward_10),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleControlShowTap() {
    _hideControlsOperation?.cancel();
    setState(() {
      showControls = !showControls;
      if (showControls) {
        _controlsAnimationController.forward();
      } else {
        _controlsAnimationController.reverse();
      }
    });
    if (showControls == true) {
      _hideControlsOperation = RestartableTimer(
        const Duration(seconds: 5),
        () => {
          setState(() {
            showControls = false;
            _controlsAnimationController.reverse();
          })
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleStateChange);
    _playAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _playAnimationController.forward();
    _controlsAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _handleControlShowTap();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleStateChange);
    _hideControlsOperation?.cancel();
    _playAnimationController.dispose();
    _controlsAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!showControls) {
      return GestureDetector(
        onTap: _handleControlShowTap,
        child: SizedBox.expand(
          child: Container(
            color: Colors.transparent,
          ),
        ),
      );
    }

    if (widget.controller.value.isEnded || widget.controller.value.hasError) {
      return Center(
        child: FittedBox(
          child: IconButton(
            onPressed: _replay,
            color: _iconColor,
            iconSize: _replayButtonIconSize,
            icon: const Icon(Icons.replay),
          ),
        ),
      );
    }

    Widget centerWidget = const SizedBox.shrink();

    switch (widget.controller.value.playingState) {
      case PlayingState.initialized:
      case PlayingState.stopped:
      case PlayingState.paused:
      case PlayingState.playing:
        centerWidget = _controlRow();
        break;

      case PlayingState.buffering:
      case PlayingState.initializing:
        centerWidget = const Center(
          child: CircularProgressIndicator(),
        );
        break;

      case PlayingState.ended:
      case PlayingState.error:
        centerWidget = Center(
          child: FittedBox(
            child: IconButton(
              onPressed: _replay,
              color: _iconColor,
              iconSize: _replayButtonIconSize,
              icon: const Icon(Icons.replay),
            ),
          ),
        );
        break;

      default:
        break;
    }

    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        centerWidget,
        Container(
          height: 42,
          padding: const EdgeInsets.fromLTRB(48, 0, 48, 24),
          child: Material(
            color: Colors.transparent,
            child: Row(
              children: [
                Text(
                  _getElapsedTime(),
                  style: const TextStyle(color: _iconColor),
                ),
                Expanded(
                  child: Slider(
                    onChanged: (value) {
                      setState(() {
                        isScrubbing = true;
                        lastScrubValue = value;
                      });
                      _hideControlsOperation?.reset();
                    },
                    onChangeEnd: (value) async {
                      await widget.controller.seekTo(
                        Duration(
                          milliseconds: (value *
                                  widget
                                      .controller.value.duration.inMilliseconds)
                              .round(),
                        ),
                      );
                      setState(() {
                        isScrubbing = false;
                      });
                    },
                    value: _getProgress(),
                  ),
                ),
                Text(
                  _formatDuration(widget.controller.value.duration),
                  style: const TextStyle(color: _iconColor),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 32,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: _iconColor,
                  iconSize: 38,
                  icon: const Icon(Icons.arrow_back),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                FutureBuilder(
                  future: widget.controller.getRendererDevices(),
                  builder: (context, snapshot) {
                    final hasData = snapshot.hasData;
                    final data = snapshot.data;
                    final hasDevices = hasData && data!.isNotEmpty;

                    return Visibility(
                      visible: hasDevices,
                      child: IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("TODO: show cast dialog"),
                          ));
                        },
                        color: _iconColor,
                        iconSize: 32,
                        icon: const Icon(Icons.cast_connected),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: 48,
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Future<void> _replay() async {
    _hideControlsOperation?.reset();
    await widget.controller.stop();
    widget.controller.play();
  }

  void _playPause() {
    _hideControlsOperation?.reset();
    if (widget.controller.value.isPlaying) {
      widget.controller.pause();
      _playAnimationController.reverse();
    } else {
      widget.controller.play();
      _playAnimationController.forward();
    }
  }

  /// Returns a callback which seeks the video relative to current playing time.
  Future<void> _seekRelative(Duration seekStep) async {
    _hideControlsOperation?.reset();
    if (widget.controller.value.duration.inSeconds != 0) {
      widget.controller.seekTo(widget.controller.value.position + seekStep);
    }
  }
}

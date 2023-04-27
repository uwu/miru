import 'package:flutter/material.dart';
import 'player.dart';
import 'api.dart' as api;

import 'tracking.dart' as tracking;

class EpisodePage extends StatelessWidget {
  const EpisodePage(
      {super.key,
      required this.id,
      required this.title,
      required this.episode,
      required this.image});
  final String title;
  final String id;
  final int episode;
  final String image;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api.getStreams(id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          tracking.addToHistory(this);
          final result = snapshot.data!;
          return Player(
            streamUrl: result.last,
            episodeId: id,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

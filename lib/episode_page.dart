import 'package:flutter/material.dart';
import 'player.dart';
import 'api.dart' as api;

import 'tracking.dart';

class EpisodePage extends StatelessWidget {
  const EpisodePage({super.key, required this.id, required this.title});
  final String title;
  final String id;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api.getStreams(id),
      builder: (context, snapshot) {
        // TODO: History
        if (snapshot.hasData) {
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

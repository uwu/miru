import 'package:flutter/material.dart';
import 'package:miru/player.dart';
import 'package:miru/api.dart' as api;

class EpisodePage extends StatelessWidget {
  const EpisodePage({super.key, required this.id, required this.title});
  final String title;
  final String id;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api.getStreams(id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: Center(
                  child: Player(
                    streamUrl: result.last,
                    episodeId: id,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Go back."),
              ),
            ],
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

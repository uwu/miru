import 'package:flutter/material.dart';
import 'package:miru/player.dart';

class EpisodePage extends StatelessWidget {
  const EpisodePage({super.key, required this.id, required this.title});
  final String title;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Player()
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EpisodePage extends StatelessWidget {
  const EpisodePage({super.key, required this.id, required this.title});
  final String title;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text("Episode $id"),
      ),
    );
  }
}

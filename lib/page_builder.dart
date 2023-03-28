import 'package:flutter/material.dart';
import 'package:miru/carousel.dart';

class PageBuilder extends StatelessWidget {
  const PageBuilder({super.key, required this.currentSelection});
  final int currentSelection;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12, 16, 0, 8),
          child: const Text(
            "Trending anime",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const Carousel(),
      ],
    );
  }
}

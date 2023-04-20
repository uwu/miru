import 'package:flutter/material.dart';
import 'grid.dart';
import 'anime_card.dart';
import 'carousel.dart';
import 'recently_updated.dart';
import 'tracking.dart' as tracking;
import 'utils.dart';

class FavoriteWrapper extends StatelessWidget {
  const FavoriteWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tracking.getFavoritesFuture(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          // while data is loading:
          return Center(
            child: Container(
              padding: const EdgeInsets.all(16),
            ),
          );
        } else {
          return Grid(
            children: animeCardsFromList(context, snapshot.data),
          );
        }
      },
    );
  }
}

List<Widget> pages = [
  SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12, 16, 0, 8),
          child: const Text(
            "Trending anime",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const Carousel(),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 16, 0, 8),
          child: const Text(
            "Recent episodes",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const RecentlyUpdated(),
      ],
    ),
  ),
  SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12, 16, 0, 8),
          child: const Text(
            "Favorite anime",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const FavoriteWrapper(),
      ],
    ),
  ),
  const Center(
    child: Text("History"),
  ),
];

class PageBuilder extends StatelessWidget {
  const PageBuilder({super.key, required this.currentSelection});
  final int currentSelection;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 20),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          // Curved tween
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      child: pages[currentSelection],
    );
  }
}

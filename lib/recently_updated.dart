import 'package:flutter/material.dart';
import 'anime_card.dart';
import 'grid.dart';
import 'api.dart' as api;
import 'utils.dart';

class RecentlyUpdated extends StatelessWidget {
  const RecentlyUpdated({super.key});

  static const rowSize = 2;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api.getLatest(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          // while data is loading:
          return Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const CircularProgressIndicator(),
            ),
          );
        } else {
          // data loaded:
          final recentlyUpdated = snapshot.data["results"];
          List<Widget> widgets = [];

          for (final item in recentlyUpdated) {
            widgets.add(
              AnimeCard(
                id: item["id"],
                title: item["title"].isEmpty
                    ? titleCase(removeDashes(item["id"]))
                    : item["title"],
                image: item["image"],
                size: MediaQuery.of(context).size.width / rowSize * 0.8,
                episode: item["episodeNumber"].toString(),
              ),
            );
          }

          return Grid(
            children: widgets,
          );
        }
      },
    );
  }
}

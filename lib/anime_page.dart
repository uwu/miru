import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miru/api.dart' as api;
import 'package:miru/episode_list.dart';

String titleCase(String text) {
  return text.split(" ").map((String word) {
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(" ");
}

class AnimePage extends StatelessWidget {
  const AnimePage(
      {super.key, required this.id, required this.title, required this.image});
  final String title;
  final String image;
  final String id;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api.getAnime(id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          // while data is loading:
          return Scaffold(
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: const CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          final result = snapshot.data;

          final pageScrollController = ScrollController();

          return Scaffold(
            body: Wrap(
              direction: Axis.vertical,
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top,
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.transparent,
                          Color.fromARGB(128, 0, 0, 0),
                        ],
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // TODO: Add to favorites
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 500,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 150,
                        padding: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).dividerColor.withAlpha(10),
                        child: Scrollbar(
                          controller: pageScrollController,
                          thumbVisibility: true,
                          radius: const Radius.circular(8),
                          child: SingleChildScrollView(
                            controller: pageScrollController,
                            child: Container(
                              padding: const EdgeInsets.only(right: 12),
                              child: Text(
                                result["description"],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Display release date and episode count, along with ongoing status
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${titleCase(result["type"])} - ${result["status"]}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Episodes
                      Row(
                        children: [
                          const Icon(
                            Icons.play_arrow,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${result["episodes"].length} episodes",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Genres
                      Row(
                        children: [
                          const Icon(
                            Icons.category,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            result["genres"].join(", "),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: EpisodeList(episodes: result["episodes"]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

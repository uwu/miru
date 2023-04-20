import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'anime_page.dart';
import 'utils.dart';

List<Widget> animeCardsFromList(BuildContext context, List items) {
  List<Widget> widgets = [];
  for (final item in items) {
    widgets.add(
      AnimeCard(
        id: item["id"],
        title: item["title"].isEmpty
            ? titleCase(removeDashes(item["id"]))
            : item["title"],
        image: item["image"],
        size: MediaQuery.of(context).size.width / 2 * 0.8,
      ),
    );
  }
  return widgets;
}

class AnimeCard extends StatelessWidget {
  const AnimeCard(
      {super.key,
      required this.id,
      required this.title,
      required this.image,
      this.size = 200,
      this.episode = ""});
  final String title;
  final String image;
  final String id;
  final double size;
  final String episode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              width: size,
              height: size * 1.5,
              placeholder: (context, url) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
              errorWidget: (context, url, error) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Expanded(
                    child: Center(
                      child: Icon(Icons.error),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromARGB(178, 0, 0, 0),
                    Colors.transparent,
                  ],
                ),
              ),
              width: size,
              padding: const EdgeInsets.all(8),
              child: Text(
                clipTitle(title) + (episode.isEmpty ? "" : "\n Ep. $episode"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkResponse(
                highlightColor: Colors.transparent,
                onTap: () {
                  // Navigate to anime page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) =>
                          AnimePage(id: id, title: title, image: image),
                    ),
                  );
                },
                child: SizedBox(
                  width: size,
                  height: size * 1.5,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

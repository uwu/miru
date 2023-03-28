import 'package:flutter/material.dart';
import 'package:miru/anime_page.dart';

String clipTitle(String title) {
  final words = title.split(" ");
  // Display only 6 words max
  if (words.length > 6) {
    return "${words.take(6).join(" ")}...";
  } else {
    return title;
  }
}

class AnimeCard extends StatelessWidget {
  const AnimeCard(
      {super.key, required this.id, required this.title, required this.image});
  final String title;
  final String image;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Card(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.network(
              image,
              fit: BoxFit.cover,
              width: 200,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                );
              },
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromARGB(200, 0, 0, 0),
                    Colors.transparent,
                  ],
                ),
              ),
              width: 200,
              padding: const EdgeInsets.all(8),
              child: Text(
                clipTitle(title),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}

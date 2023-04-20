import 'dart:io';
import 'package:flutter/material.dart';
import 'episode_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'api.dart' as api;

Future<File> getPreviewImage(String episodeId) async {
  // Attempt to read from cache
  final directory = await getTemporaryDirectory();
  final file = File('${directory.path}/thumb_$episodeId.jpg');
  if (await file.exists()) {
    return file;
  }

  final streams = await api.getStreams(episodeId);
  final videoUrl = await api.getMiddleStreamPart(streams.first);

  final byteData = await api.getData(videoUrl);
  File tempVideo = File('${directory.path}/thumb_$episodeId.mp4')
    ..createSync(recursive: true)
    ..writeAsBytesSync(byteData);

  final thumbnail = await VideoThumbnail.thumbnailData(
    video: tempVideo.path,
    imageFormat: ImageFormat.JPEG,
    quality: 50,
  );

  if (thumbnail == null) {
    return Future.error("Failed to generate thumbnail");
  }

  await file.writeAsBytes(thumbnail.toList());

  return file;
}

class EpisodeList extends StatelessWidget {
  const EpisodeList({super.key, required this.episodes});
  final List episodes;
  final bool seen = false;

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return Material(
      child: Scrollbar(
        radius: const Radius.circular(8),
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              for (var episode in episodes)
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).dividerColor.withAlpha(
                        int.parse("${episode["number"]}") % 2 == 0 ? 10 : 40),
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 57,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Theme.of(context).dividerColor.withAlpha(
                                int.parse("${episode["number"]}") % 2 == 0
                                    ? 10
                                    : 40),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: FutureBuilder(
                            future: getPreviewImage(episode["id"]),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Icon(Icons.error_outline,
                                    size: 57);
                              } else if (snapshot.hasData) {
                                return Image.file(
                                  snapshot.data!,
                                  width: 100,
                                  height: 57,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Episode ${episode["number"]}",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: seen
                                        ? Theme.of(context).disabledColor
                                        : Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .color,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          Icons.play_arrow,
                          size: 24,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EpisodePage(
                          id: episode["id"],
                          title: "Episode ${episode["number"]}",
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    // TODO: Open menu to mark as seen/unseen
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

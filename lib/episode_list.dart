import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miru/episode_page.dart';

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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Theme.of(context).dividerColor.withAlpha(
                                int.parse("${episode["number"]}") % 2 == 0
                                    ? 10
                                    : 40),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: CachedNetworkImage(
                            // TODO: generate thumbnail
                            imageUrl:
                                "https://cdn.discordapp.com/attachments/824921608560181261/1090406574985597108/Screenshot_20230328-234557.png",
                            width: 80,
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
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

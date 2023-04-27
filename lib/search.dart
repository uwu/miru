import 'package:flutter/material.dart';
import 'anime_card.dart';
import 'grid.dart';
import 'api.dart' as api;
import 'utils.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => SearchState();
}

class SearchState extends State<SearchPage> {
  List<Widget> results = [];
  bool hasNextPage = false;
  int lastPageSearched = 0;
  String lastSearch = '';
  bool loading = false;

  static const rowSize = 2;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextField(
            controller: controller,
            onSubmitted: (f) => doSearch(),
            decoration: const InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                doSearch();
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            loading
                ? Center(
                    child: Container(
                    padding: const EdgeInsets.all(16),
                    child: const CircularProgressIndicator(),
                  ))
                : Grid(children: results),
            hasNextPage
                ? ElevatedButton(
                    onPressed: () => searchMore(),
                    child:
                        const Text('Load more', style: TextStyle(fontSize: 16)))
                : Container(),
            const SizedBox(height: 16),
          ]),
        ));
  }

  void doSearch() {
    if (controller.text != lastSearch) {
      results = [];
      lastPageSearched = 0;
      hasNextPage = false;
    } else {
      return;
    }
    if (controller.text.isEmpty) return;
    setState(() {
      loading = true;
    });
    lastSearch = controller.text;
    api.search(controller.text).then((value) {
      loading = false;
      List parsed = value["results"];
      for (Map<String, dynamic> item in parsed) {
        results.add(
          AnimeCard(
            id: item["id"],
            title: item["title"].isEmpty
                ? titleCase(removeDashes(item["id"]))
                : item["title"],
            image: item["image"],
            size: MediaQuery.of(context).size.width / rowSize * 0.8,
          ),
        );
      }
      setState(() {
        hasNextPage = value["hasNextPage"];
      });
    });
  }

  void searchMore() {
    if (!hasNextPage) return;
    lastPageSearched++;

    api.search(controller.text, lastPageSearched).then((value) {
      List parsed = value["results"];
      for (Map<String, dynamic> item in parsed) {
        results.add(
          AnimeCard(
            id: item["id"],
            title: item["title"].isEmpty
                ? titleCase(removeDashes(item["id"]))
                : item["title"],
            image: item["image"],
            size: MediaQuery.of(context).size.width / rowSize * 0.8,
          ),
        );
      }
      setState(() {
        hasNextPage = value["hasNextPage"];
      });
    });
  }
}

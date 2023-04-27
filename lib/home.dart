import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "anime_card.dart";
import "recently_updated.dart";
import "search.dart";
import "carousel.dart";
import "grid.dart";
import 'tracking.dart' as tracking;

class MiruHome extends StatefulWidget {
  const MiruHome({super.key, required this.onBrightessChange});
  final void Function() onBrightessChange;

  @override
  State<MiruHome> createState() => MiruHomeState();
}

class MiruHomeState extends State<MiruHome> {
  bool _isDark = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Row(
            children: [
              SvgPicture.asset(
                "assets/logo.svg",
                colorFilter: ColorFilter.mode(
                    Theme.of(context).iconTheme.color!, BlendMode.srcIn),
                width: 32,
                height: 32,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                ),
              },
            ),
            PopupMenuButton<String>(
              onSelected: (String result) {},
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Settings',
                  child: Text('Settings'),
                ),
                const PopupMenuItem<String>(
                  value: 'About',
                  child: Text('About'),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: <Widget>[
            Tab(
              iconMargin: EdgeInsets.only(bottom: 4),
              icon: Icon(Icons.home),
              text: 'Home',
            ),
            Tab(
              iconMargin: EdgeInsets.only(bottom: 4),
              icon: Icon(Icons.favorite),
              text: 'Favorites',
            ),
            Tab(
              iconMargin: EdgeInsets.only(bottom: 4),
              icon: Icon(Icons.history),
              text: 'History',
            ),
          ],
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 16, 0, 8),
                    child: const Text(
                      "Trending anime",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Carousel(),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 16, 0, 8),
                    child: const Text(
                      "Recent episodes",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      List favorites = tracking.getFavorites();
                      if (favorites.isNotEmpty) {
                        return Grid(
                          children: animeCardsFromList(
                            context,
                            favorites,
                          ),
                        );
                      }
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 64, 0, 8),
                          child: const Text(
                            "So lonely... \n╥﹏╥",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
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
                      "Recently watched episodes",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  tracking.history.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(12, 16, 0, 8),
                          // child: Grid(
                          //   children: animeCardsFromList(
                          //     context,
                          //     tracking.getHistory(),
                          //   ),
                          // ),
                          child: const Text(
                              "I'll be honest. This shouldn't happen."))
                      : Center(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(12, 64, 0, 8),
                            child: const Text(
                              "Go watch something! \n٩(•̤̀ᵕ•̤́๑)ᵒᵏᵎᵎᵎᵎ \n(TODO)",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _isDark = !_isDark;
            widget.onBrightessChange();
          },
          tooltip: 'Brightness',
          child: Icon(
            _isDark ? Icons.light_mode : Icons.dark_mode,
          ),
        ),
      ),
    );
  }
}

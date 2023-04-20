import "package:flutter/material.dart";
import "package:miru/search.dart";
import "page_builder.dart";
import "package:flutter_svg/flutter_svg.dart";

class MiruHome extends StatefulWidget {
  const MiruHome({super.key, required this.onBrightessChange});
  final void Function() onBrightessChange;

  @override
  State<MiruHome> createState() => MiruHomeState();
}

class MiruHomeState extends State<MiruHome> {
  int _selectedIndex = 0;
  bool _isDark = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
      ),
      body: Center(
        child: PageBuilder(
          currentSelection: _selectedIndex,
        ),
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
    );
  }
}

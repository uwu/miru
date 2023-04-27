import 'package:hive_flutter/hive_flutter.dart';
import 'package:miru/anime_page.dart';
import 'package:miru/episode_page.dart';

Map favorites = {};
Map history = {};
Map timestamps = {};
Map watched = {};

void init() {
  Hive.openBox('miru').then((box) {
    favorites = box.get('favorites', defaultValue: {});
    history = box.get('history', defaultValue: {});
    timestamps = box.get('timestamps', defaultValue: {});
    watched = box.get('watched', defaultValue: {});
  });
}

bool isFavorite(AnimePage page) {
  return favorites.containsKey(page.id);
}

void addToFavorites(AnimePage page) {
  favorites[page.id] = {
    "title": page.title,
    "image": page.image,
    "id": page.id
  };
  Hive.openBox('miru').then((box) {
    box.put('favorites', favorites);
  });
}

List getFavorites() {
  return favorites.values.toList();
}

void removeFromFavorites(AnimePage page) {
  favorites.remove(page.id);
  Hive.openBox('miru').then((box) {
    box.put('favorites', favorites);
  });
}

void addToHistory(EpisodePage page) {
  history[page.id] = {
    "title": page.title,
    "id": page.id,
    "episode": page.episode,
    "image": page.image,
    "timeAdded": DateTime.now().millisecondsSinceEpoch,
  };
  Hive.openBox('miru').then((box) {
    box.put('history', history);
  });
}

List getHistory() {
  // reset history

  // history = {};
  // Hive.openBox('miru').then((box) {
  //   box.put('history', history);
  // });

  List h = history.values.toList();
  h.sort((a, b) => b["timeAdded"].compareTo(a["timeAdded"]));
  return h;
}

String getTimestamp(String id) {
  return timestamps[id];
}

void setTimestamp(String id, int timestamp) {
  timestamps[id] = timestamp;
  Hive.openBox('miru').then((box) {
    box.put('timestamps', timestamps);
  });
}

bool getWatched(String id) {
  return watched[id];
}

void setWatched(String id, bool isWatched) {
  watched[id] = isWatched;
  Hive.openBox('miru').then((box) {
    box.put('setWatched', setWatched);
  });
}

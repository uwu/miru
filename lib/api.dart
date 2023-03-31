import 'dart:convert';
import 'package:http/http.dart' as http;

const apiEndpoint = "https://api.consumet.org/anime/gogoanime";

Future<Map<dynamic, dynamic>> search(String query, [int page = 0]) async {
  final response = await http.get(Uri.parse('$apiEndpoint/$query?page=$page'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load anime');
  }
}

Future<Map<dynamic, dynamic>> getLatest() async {
  final response = await http.get(Uri.parse('$apiEndpoint/recent-episodes'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load anime');
  }
}

Future<Map<dynamic, dynamic>> getPopular() async {
  final response = await http.get(Uri.parse('$apiEndpoint/top-airing'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load anime');
  }
}

Future<Map<dynamic, dynamic>> getAnime(String id) async {
  final response = await http.get(Uri.parse('$apiEndpoint/info/$id'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load anime');
  }
}

Future<Map<dynamic, dynamic>> getServers(String id) async {
  final response = await http.get(Uri.parse('$apiEndpoint/servers/$id'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load anime');
  }
}

Future<String> getPlaylist(String id, [String server = "gogocdn"]) async {
  final response =
      await http.get(Uri.parse('$apiEndpoint/watch/$id?server=$server'));
  if (response.statusCode == 200) {
    final payload = jsonDecode(response.body);
    return payload["sources"]
        .firstWhere((source) => source["quality"] == "backup")["url"];
  } else {
    throw Exception('Failed to load streams');
  }
}

Future<List<String>> getStreams(String id, [String server = "gogocdn"]) async {
  final playlistStreams = await getPlaylist(id, server);
  final availableStreams = await http
      .get(
        Uri.parse(playlistStreams),
      )
      .catchError(
        (error) => throw Exception('Failed to load streams: $error'),
      );

  final baseUrlForStreams =
      playlistStreams.substring(0, playlistStreams.lastIndexOf("/"));

  if (availableStreams.statusCode == 200) {
    final List<String> filenames = [];
    List<RegExpMatch> matches =
        RegExp(r'([\w.-]+\.m3u8)').allMatches(availableStreams.body).toList();
    for (RegExpMatch match in matches) {
      filenames.add("$baseUrlForStreams/${match.group(1)}");
    }
    return filenames;
  } else {
    throw Exception('Failed to load streams');
  }
}

Future<String> getMiddleStreamPart(String m3u8StreamUrl) async {
  final response = await http.get(Uri.parse(m3u8StreamUrl));
  if (response.statusCode == 200) {
    final baseUrlForStreams =
        m3u8StreamUrl.substring(0, m3u8StreamUrl.lastIndexOf("/"));

    List<String> parts = [];
    List<RegExpMatch> matches =
        RegExp(r'([\w.-]+\.ts)').allMatches(response.body).toList();
    for (RegExpMatch match in matches) {
      parts.add("$baseUrlForStreams/${match.group(1)}");
    }
    return parts[parts.length ~/ 2];
  } else {
    throw Exception('Failed to load m3u8 parts');
  }
}

Future<List<int>> getData(String url) {
  return http.get(Uri.parse(url)).then((response) {
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to get m3u8 data');
    }
  });
}

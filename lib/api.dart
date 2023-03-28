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

Future<Map<dynamic, dynamic>> getStreams(String id,
    [String server = "gogocdn"]) async {
  final response =
      await http.get(Uri.parse('$apiEndpoint/watch/$id?server=$server'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load anime');
  }
}

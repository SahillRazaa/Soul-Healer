import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchService {
  final YoutubeExplode _youtubeExplode = YoutubeExplode();

  Future<List<dynamic>> searchSongs(String query) async {
    var searchResults = await _youtubeExplode.search.search(query);
    return searchResults.toList();
  }

  void dispose() {
    _youtubeExplode.close();
  }
}

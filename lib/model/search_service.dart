import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchService {
  final YoutubeExplode _youtubeExplode = YoutubeExplode();

  Future<List<Video>> searchSongs(String query) async {
    try {
      var searchResults = await _youtubeExplode.search.search(query);

      var musicVideos = searchResults.where((video) {
        var title = video.title.toLowerCase();
        var description = video.description.toLowerCase();

        return (title.contains('official music video') ||
            title.contains('music video') ||
            description.contains('official music video') ||
            description.contains('music video'));
      }).toList();

      return musicVideos;
    } catch (e) {
      print('Error fetching search results: $e');
      return [];
    }
  }

  void dispose() {
    _youtubeExplode.close();
  }
}

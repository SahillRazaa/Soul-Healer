import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchProvider with ChangeNotifier {
  final YoutubeExplode _youtubeExplode = YoutubeExplode();
  List<dynamic> _songs = [];
  bool _isLoading = false;

  List<dynamic> get songs => _songs;
  bool get isLoading => _isLoading;

  Future<void> searchSongs(String query) async {
    if (query.isEmpty) {
      _songs = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final searchResults = await _youtubeExplode.search.search(query);
      _songs = searchResults.toList();
    } catch (e) {
      print('Error searching songs: $e');
      _songs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _youtubeExplode.close();
    super.dispose();
  }
}

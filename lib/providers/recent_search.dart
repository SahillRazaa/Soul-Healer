import 'package:flutter/foundation.dart';

class RecentSearch with ChangeNotifier {
  List<dynamic> _recentSearchSongs = [];

  List<dynamic> get recentSearchSongs => _recentSearchSongs;

  void setRecentSongs(List<dynamic> songs) {
    _recentSearchSongs = songs;
    notifyListeners();
  }

  void addRecentSong(dynamic song) {
    _recentSearchSongs
        .removeWhere((existingSong) => existingSong['id'] == song['id']);

    _recentSearchSongs.add(song);

    notifyListeners();
  }
}

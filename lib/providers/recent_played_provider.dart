import 'package:flutter/foundation.dart';

class RecentPlayedProvider with ChangeNotifier {
  List<dynamic> _recentSongs = [];

  List<dynamic> get recentSongs => _recentSongs;

  void setRecentSongs(List<dynamic> songs) {
    _recentSongs = songs;
    notifyListeners();
  }

  void addRecentSong(dynamic song) {
    _recentSongs
        .removeWhere((existingSong) => existingSong['id'] == song['id']);

    _recentSongs.add(song);

    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';

class FavSongProvider with ChangeNotifier {
  List<dynamic> _favSongs = [];

  List<dynamic> get favSongs => _favSongs;

  void setFavSongs(List<dynamic> songs) {
    _favSongs = songs;
    notifyListeners();
  }

  void removeSong(dynamic song) {
    _favSongs.removeWhere((existingSong) => existingSong['id'] == song['id']);
    notifyListeners();
  }

  void addFavSong(dynamic song) {
    _favSongs.removeWhere((existingSong) => existingSong['id'] == song['id']);

    _favSongs.add(song);

    notifyListeners();
  }
}

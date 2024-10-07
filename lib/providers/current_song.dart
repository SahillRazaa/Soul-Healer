import 'package:flutter/material.dart';

class Song {
  final String songId;
  final String songName;
  final String artistName;
  final String songImage;

  Song({
    required this.songId,
    required this.songName,
    required this.artistName,
    required this.songImage,
  });
}

class CurrentSongProvider extends ChangeNotifier {
  List<Song> _songs = [];
  int _currentIndex = 0;

  String get currSong => _songs.isNotEmpty ? _songs[_currentIndex].songId : '';
  String get songName =>
      _songs.isNotEmpty ? _songs[_currentIndex].songName : '';
  String get artistName =>
      _songs.isNotEmpty ? _songs[_currentIndex].artistName : '';
  String get songImage =>
      _songs.isNotEmpty ? _songs[_currentIndex].songImage : '';

  void setSongs(List<Song> songs) {
    _songs = songs;
    _currentIndex = 0;
    notifyListeners();
  }

  bool hasPreviousSong() {
    return _currentIndex > 0;
  }

  bool hasNextSong() {
    return _currentIndex < _songs.length - 1;
  }

  void nextSong() {
    if (_songs.isNotEmpty && _currentIndex < _songs.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousSong() {
    if (_songs.isNotEmpty && _currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void setSong(String songId, String name, String artist, String image) {
    _currentIndex = _songs.indexWhere((song) => song.songId == songId);
    if (_currentIndex == -1) {
      _songs.add(Song(
          songId: songId,
          songName: name,
          artistName: artist,
          songImage: image));
      _currentIndex = _songs.length - 1;
    }
    notifyListeners();
  }
}

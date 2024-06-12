import 'package:flutter/material.dart';

class CurrentSongProvider extends ChangeNotifier {
  String _currSong = '';
  String _songName = '';
  String _artistName = '';
  String _songImage = '';

  String get currSong => _currSong;
  String get songName => _songName;
  String get artistName => _artistName;
  String get songImage => _songImage;

  void setSong(String songId, String name, String artist, String image) {
    _currSong = songId;
    _songName = name;
    _artistName = artist;
    _songImage = image;
    notifyListeners();
  }
}

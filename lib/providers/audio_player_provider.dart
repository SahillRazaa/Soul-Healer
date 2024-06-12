import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerProvider with ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  Duration progress = Duration.zero;
  Duration buffered = Duration.zero;
  Duration total = Duration.zero;

  AudioPlayerProvider() {
    audioPlayer.positionStream.listen((position) {
      progress = position;
      notifyListeners();
    });

    audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      buffered = bufferedPosition;
      notifyListeners();
    });

    audioPlayer.durationStream.listen((duration) {
      total = duration ?? Duration.zero;
      notifyListeners();
    });
  }

  Future<void> setUrl(String url) async {
    await audioPlayer.setUrl(url);
  }

  void playPause() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    isPlaying = audioPlayer.playing;
    notifyListeners();
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    isPlaying = false;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key, required this.songImage});

  final String songImage;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _progress = const Duration(minutes: 1);
  Duration _buffered = const Duration(minutes: 1, seconds: 20);
  Duration _total = const Duration(minutes: 3, seconds: 40);

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() async {
    await _audioPlayer.setUrl('https://example.com/audio.mp3');

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _progress = position;
      });
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      setState(() {
        _buffered = bufferedPosition;
      });
    });

    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _total = duration ?? Duration.zero;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.9,
            child: Container(
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                widget.songImage,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize: 35,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        color: Colors.black,
                      ),
                      Text(
                        'Currently Playing',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(217, 213, 213, 213),
                          ),
                        ),
                      ),
                      IconButton(
                        iconSize: 35,
                        onPressed: () {},
                        icon: const Icon(Icons.more_horiz),
                        color: Colors.black,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(150.0),
                      border: Border.all(
                        color: const Color.fromARGB(255, 143, 21, 21),
                        width: 6,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150.0),
                      child: Image.asset(
                        widget.songImage,
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Gulabi Sadi',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(217, 213, 213, 213),
                      ),
                    ),
                  ),
                  Text(
                    'Sanju Rathod, G-SPXRK',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(241, 160, 160, 160),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ProgressBar(
                      progress: _progress,
                      buffered: _buffered,
                      total: _total,
                      onSeek: (duration) {
                        _audioPlayer.seek(duration);
                      },
                      thumbColor: const Color.fromARGB(255, 143, 21, 21),
                      baseBarColor: const Color.fromARGB(220, 236, 236, 236),
                      thumbGlowColor: const Color.fromARGB(255, 165, 91, 91),
                      bufferedBarColor: const Color.fromARGB(255, 165, 91, 91),
                      progressBarColor: const Color.fromARGB(255, 143, 21, 21),
                      timeLabelLocation: TimeLabelLocation.below,
                      timeLabelTextStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize: 50,
                        onPressed: () {},
                        icon: const Icon(Icons.skip_previous),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      IconButton(
                        iconSize: 70,
                        onPressed: () {
                          if (_audioPlayer.playing) {
                            _audioPlayer.pause();
                          } else {
                            _audioPlayer.play();
                          }
                        },
                        icon: const Icon(
                          Icons.play_circle_fill_outlined,
                        ),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      IconButton(
                        iconSize: 50,
                        onPressed: () {},
                        icon: const Icon(Icons.skip_next),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize: 30,
                        onPressed: () {},
                        icon: const Icon(Icons.speaker),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      IconButton(
                        iconSize: 30,
                        onPressed: () {},
                        icon: const Icon(Icons.lyrics),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      IconButton(
                        iconSize: 30,
                        onPressed: () {},
                        icon: const Icon(Icons.repeat),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      IconButton(
                        iconSize: 30,
                        onPressed: () {},
                        icon: const Icon(Icons.shuffle),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

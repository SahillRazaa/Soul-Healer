import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/audio_player_provider.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as youtube;

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key, required this.flag});
  final bool flag;

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late AudioPlayerProvider audioProvider;
  bool isAudioLoading = false;
  String videoId = '';
  String songname = '';
  String songArtist = '';
  String songImage = '';

  @override
  void initState() {
    super.initState();
    audioProvider = Provider.of<AudioPlayerProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentSong = Provider.of<CurrentSongProvider>(context);
    if (videoId != currentSong.currSong &&
        currentSong.currSong.isNotEmpty &&
        widget.flag) {
      videoId = currentSong.currSong;
      loadAudio();
    }
    songname = currentSong.songName;
    songArtist = currentSong.artistName;
    songImage = currentSong.songImage;
  }

  void loadAudio() async {
    setState(() {
      isAudioLoading = true;
    });

    String? audioUrl = await getAudioUrl(videoId);

    if (audioUrl != null) {
      if (audioProvider.isPlaying) {
        await audioProvider.stop();
      }
      await audioProvider.setUrl(audioUrl);
      audioProvider.playPause();
    } else {
      print('Failed to get audio URL from YouTube');
    }
    setState(() {
      isAudioLoading = false;
    });
  }

  Future<String?> getAudioUrl(String videoId) async {
    final yt = youtube.YoutubeExplode();

    try {
      var manifest = await yt.videos.streamsClient.getManifest(videoId);
      var audioStream = manifest.audioOnly.firstOrNull;
      if (audioStream != null) {
        return audioStream.url.toString();
      } else {
        print('No audio-only streams found');
        return null;
      }
    } catch (e) {
      print('Error fetching audio URL: $e');
      return null;
    } finally {
      yt.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    audioProvider = Provider.of<AudioPlayerProvider>(context);

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
              opacity: 0.6,
              child: Image.network(
                songImage,
                fit: BoxFit.fitHeight,
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
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      Text(
                        'Currently Playing',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      IconButton(
                        iconSize: 35,
                        onPressed: () {},
                        icon: const Icon(Icons.more_horiz),
                        color: const Color.fromARGB(255, 255, 255, 255),
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
                      child: Image.network(
                        songImage,
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
                    songname,
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(217, 213, 213, 213),
                      ),
                    ),
                  ),
                  Text(
                    songArtist,
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
                      progress: audioProvider.progress,
                      buffered: audioProvider.buffered,
                      total: audioProvider.total,
                      onSeek: (duration) {
                        audioProvider.audioPlayer.seek(duration);
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
                          setState(() {
                            audioProvider.playPause();
                          });
                        },
                        icon: audioProvider.isPlaying
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_circle_fill_outlined),
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
}

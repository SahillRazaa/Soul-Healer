import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/audio_player_provider.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as youtube;
import 'package:just_audio/just_audio.dart';

class PlayerPage extends StatefulWidget {
  final bool flag;

  const PlayerPage({Key? key, required this.flag}) : super(key: key);

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
  bool isRepeating = false;
  bool isRepeatIcon = false;
  bool showPopup = false;
  String popupMessage = '';

  @override
  void initState() {
    super.initState();
    audioProvider = Provider.of<AudioPlayerProvider>(context, listen: false);

    audioProvider.audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          isRepeatIcon = state.processingState == ProcessingState.completed;
        });
      }
    });
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
      await audioProvider.setUrl(audioUrl, songname, songArtist, songImage);
      audioProvider.playPause();
    } else {
      print('Failed to get audio URL from YouTube');
    }
    if (mounted) {
      setState(() {
        isAudioLoading = false;
      });
    }
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

  void showPopupMessage(String message) {
    setState(() {
      popupMessage = message;
      showPopup = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showPopup = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    audioProvider = Provider.of<AudioPlayerProvider>(context);
    final currentSong = Provider.of<CurrentSongProvider>(context);

    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: themeManager.themeData.scaffoldBackgroundColor,
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
                        color: themeManager.themeData.primaryColor,
                      ),
                      Text(
                        'Currently Playing',
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: themeManager.themeData.primaryColor,
                          ),
                        ),
                      ),
                      IconButton(
                        iconSize: 35,
                        onPressed: () {},
                        icon: const Icon(Icons.more_horiz),
                        color: themeManager.themeData.primaryColor,
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
                        color: themeManager.themeData.primaryColor,
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
                  if (showPopup)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      margin: const EdgeInsets.only(top: 0.0),
                      color: themeManager.themeData.hintColor,
                      child: Text(
                        popupMessage,
                        style: TextStyle(
                          color: themeManager.themeData.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Text(
                      songname,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: themeManager.themeData.primaryColor,
                        ),
                      ),
                    ),
                  Text(
                    songArtist,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: themeManager.themeData.primaryColor,
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
                      thumbColor: themeManager.themeData.hintColor,
                      baseBarColor:
                          Color.fromARGB(235, 211, 211, 211).withOpacity(0.3),
                      thumbGlowColor: themeManager.themeData.primaryColor,
                      bufferedBarColor: themeManager.themeData.primaryColor,
                      progressBarColor: themeManager.themeData.hintColor,
                      timeLabelLocation: TimeLabelLocation.below,
                      timeLabelTextStyle:
                          TextStyle(color: themeManager.themeData.primaryColor),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize: 50,
                        onPressed: () {
                          if (!currentSong.hasPreviousSong()) {
                            showPopupMessage('No previous song available');
                          } else {
                            currentSong.previousSong();
                          }
                        },
                        icon: const Icon(Icons.skip_previous),
                        color: currentSong.hasPreviousSong()
                            ? themeManager.themeData.primaryColor
                            : Color.fromARGB(98, 255, 191, 191),
                      ),
                      StreamBuilder<PlayerState>(
                        stream: audioProvider.audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          bool isPlaying = snapshot.data?.playing ?? false;
                          return IconButton(
                            iconSize: 70,
                            onPressed: () {
                              setState(() {
                                audioProvider.playPause();
                              });
                            },
                            icon: isPlaying
                                ? const Icon(Icons.pause)
                                : const Icon(Icons.play_circle_fill_outlined),
                            color: themeManager.themeData.primaryColor,
                          );
                        },
                      ),
                      IconButton(
                        iconSize: 50,
                        onPressed: () {
                          if (!currentSong.hasNextSong()) {
                            showPopupMessage('No next song available');
                          } else {
                            currentSong.nextSong();
                          }
                        },
                        icon: const Icon(Icons.skip_next),
                        color: currentSong.hasNextSong()
                            ? themeManager.themeData.primaryColor
                            : Color.fromARGB(98, 255, 191, 191),
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
                        color: themeManager.themeData.primaryColor,
                      ),
                      IconButton(
                        iconSize: 30,
                        onPressed: () {
                          setState(() {
                            isRepeating = !isRepeating;
                            audioProvider.audioPlayer.setLoopMode(
                              isRepeating ? LoopMode.one : LoopMode.off,
                            );
                          });
                        },
                        icon: Icon(
                          isRepeating ? Icons.repeat_on_rounded : Icons.repeat,
                          color: isRepeating
                              ? themeManager.themeData.hintColor
                              : themeManager.themeData.primaryColor,
                        ),
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

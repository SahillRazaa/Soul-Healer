import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/audio_player_provider.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'package:soul_healer/providers/fav_song_provider.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
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

  List<dynamic> favPlayed = [];

  @override
  void initState() {
    super.initState();
    audioProvider = Provider.of<AudioPlayerProvider>(context, listen: false);
    _loadFavPlayed();
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

  Future<void> _loadFavPlayed() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/fav_played.json');
      if (await file.exists()) {
        String favPlayedString = await file.readAsString();
        setState(() {
          favPlayed = json.decode(favPlayedString);
        });

        Provider.of<FavSongProvider>(context, listen: false)
            .setFavSongs(favPlayed);
      }
    } catch (e) {
      print("Error loading recent played songs: $e");
    }
  }

  Future<void> _saveFavPlayed() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/fav_played.json');
      await file.writeAsString(json.encode(favPlayed));
    } catch (e) {
      print("Error saving Fav played songs: $e");
    }
  }

  bool _isSongInFavorites(dynamic songData) {
    return favPlayed.any((song) => song['id'] == songData['id']);
  }

  @override
  Widget build(BuildContext context) {
    audioProvider = Provider.of<AudioPlayerProvider>(context);
    final currentSong = Provider.of<CurrentSongProvider>(context);
    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double relativeWidth(double percentage) {
      return screenWidth * (percentage / 100);
    }

    double relativeHeight(double percentage) {
      return screenHeight * (percentage / 100);
    }

    final songData = {
      'id': videoId,
      'title': songname,
      'thumbnailUrl': songImage,
    };

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeManager.themeData.primaryColor.withOpacity(0.8),
              themeManager.themeData.hintColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: relativeHeight(2),
              ),
              IconButton(
                iconSize: relativeWidth(10),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.cancel_sharp),
                color: Colors.black,
              ),
              SizedBox(
                height: relativeHeight(2),
              ),
              Text(
                'Currently Playing',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: relativeWidth(6),
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: relativeHeight(1),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: relativeWidth(60),
                      height: relativeWidth(60),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: themeManager.themeData.primaryColor,
                            spreadRadius: 10,
                            blurRadius: 25,
                          ),
                        ],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: themeManager.themeData.hintColor,
                          width: 4,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          songImage,
                          width: relativeWidth(65),
                          height: relativeWidth(65),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: relativeHeight(2),
                    ),
                    if (showPopup)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        margin: const EdgeInsets.only(top: 0.0),
                        decoration: BoxDecoration(
                          color:
                              themeManager.themeData.hintColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(
                            relativeWidth(3),
                          ),
                        ),
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
                            fontSize: relativeWidth(5),
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    Text(
                      songArtist,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: relativeWidth(4),
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: relativeWidth(2),
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
                        thumbColor: Colors.black,
                        baseBarColor: Colors.black.withOpacity(0.2),
                        bufferedBarColor: Colors.black.withOpacity(0.4),
                        progressBarColor: Colors.black,
                        timeLabelLocation: TimeLabelLocation.below,
                        timeLabelTextStyle:
                            TextStyle(color: Colors.black.withOpacity(1)),
                      ),
                    ),
                    SizedBox(
                      height: relativeHeight(2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          iconSize: relativeWidth(10),
                          onPressed: () {
                            if (!currentSong.hasPreviousSong()) {
                              showPopupMessage('No previous song available');
                            } else {
                              currentSong.previousSong();
                            }
                          },
                          icon: const Icon(Icons.skip_previous),
                          color: currentSong.hasPreviousSong()
                              ? Colors.black
                              : Colors.black.withOpacity(0.3),
                        ),
                        StreamBuilder<PlayerState>(
                          stream: audioProvider.audioPlayer.playerStateStream,
                          builder: (context, snapshot) {
                            bool isPlaying = snapshot.data?.playing ?? false;
                            return IconButton(
                              iconSize: relativeWidth(15),
                              onPressed: () {
                                setState(() {
                                  audioProvider.playPause();
                                });
                              },
                              icon: isPlaying
                                  ? const Icon(Icons.pause)
                                  : const Icon(Icons.play_circle_fill_outlined),
                              color: Colors.black,
                            );
                          },
                        ),
                        IconButton(
                          iconSize: relativeWidth(10),
                          onPressed: () {
                            if (!currentSong.hasNextSong()) {
                              showPopupMessage('No next song available');
                            } else {
                              currentSong.nextSong();
                            }
                          },
                          icon: const Icon(Icons.skip_next),
                          color: currentSong.hasNextSong()
                              ? Colors.black
                              : Colors.black.withOpacity(0.3),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: relativeHeight(2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          iconSize: relativeWidth(8),
                          onPressed: () {
                            if (_isSongInFavorites(songData)) {
                              _showAlreadyInFavoritesDialog(context);
                            } else {
                              _showAddFavConfirmationDialog(context, songData);
                            }
                          },
                          icon: const Icon(Icons.favorite),
                          color: Colors.black,
                        ),
                        IconButton(
                          iconSize: relativeWidth(8),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isRepeating ? 'Loop Off' : 'Loop On',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                            setState(() {
                              isRepeating = !isRepeating;
                              audioProvider.audioPlayer.setLoopMode(
                                isRepeating ? LoopMode.one : LoopMode.off,
                              );
                            });
                          },
                          icon: Icon(
                            isRepeating
                                ? Icons.repeat_on_rounded
                                : Icons.repeat,
                            color: isRepeating
                                ? Colors.black
                                : Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: relativeHeight(2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddFavConfirmationDialog(
      BuildContext context, dynamic songData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add to Favorites'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure you want to add "${songData['title']}" to your favorite songs?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                setState(() {
                  favPlayed.add(songData);
                });

                await _saveFavPlayed();
                Provider.of<FavSongProvider>(context, listen: false)
                    .addFavSong(songData);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAlreadyInFavoritesDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Already in Favorites'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'The song is already present in your favorite songs list.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

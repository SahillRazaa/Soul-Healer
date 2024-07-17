import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'package:soul_healer/providers/fav_song_provider.dart';
import 'package:soul_healer/providers/recent_played_provider.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:soul_healer/screen/player_screen.dart';
import 'package:soul_healer/utilities/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Genresongs extends StatefulWidget {
  const Genresongs({
    Key? key,
    required this.genreName,
    required this.gradientColors,
  }) : super(key: key);

  final String genreName;
  final List<Color> gradientColors;

  @override
  State<Genresongs> createState() => _GenresongsState();
}

class _GenresongsState extends State<Genresongs> {
  late Future<List<dynamic>> _fetchSongsFuture;

  Future<List<dynamic>> fetchGenreVideos() async {
    const apiKey = Constants.YoutubeKey;
    String genreName = widget.genreName;

    try {
      final searchVideosUrl = 'https://www.googleapis.com/youtube/v3/search'
          '?part=snippet'
          '&q=${Uri.encodeComponent('$genreName songs')}'
          '&type=video'
          '&maxResults=30'
          '&videoCategoryId=10'
          '&regionCode=IN'
          '&videoDuration=short'
          '&relavanceLanguage=hi'
          '&order=relevance'
          '&safeSearch=moderate'
          '&key=$apiKey';

      final videosResponse = await http.get(Uri.parse(searchVideosUrl));

      if (videosResponse.statusCode == 200) {
        final videosData = json.decode(videosResponse.body);
        List<dynamic> videos = videosData['items'];

        return videos;
      } else {
        throw Exception('Failed to load videos: ${videosResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading artist videos: $e');
    }
  }

  String formatTitle(String title) {
    List<String> words = title.split(' ');
    if (words.isEmpty) return title;
    words[0] = words[0][0].toUpperCase() + words[0].substring(1).toLowerCase();
    for (int i = 1; i < words.length; i++) {
      words[i] = words[i].toLowerCase();
    }
    return words.join(' ');
  }

  List<dynamic> recentPlayed = [];
  List<dynamic> favPlayed = [];

  @override
  void initState() {
    super.initState();
    _fetchSongsFuture = fetchGenreVideos();
    _loadRecentPlayed();
    _loadFavPlayed();
  }

  Future<void> _loadRecentPlayed() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/recent_played.json');
      if (await file.exists()) {
        String recentPlayedString = await file.readAsString();
        setState(() {
          recentPlayed = json.decode(recentPlayedString);
        });

        Provider.of<RecentPlayedProvider>(context, listen: false)
            .setRecentSongs(recentPlayed);
      }
    } catch (e) {
      print("Error loading recent played songs: $e");
    }
  }

  Future<void> _saveRecentPlayed() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/recent_played.json');
      await file.writeAsString(json.encode(recentPlayed));
    } catch (e) {
      print("Error saving recent played songs: $e");
    }
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double relativeWidth(double percentage) {
      return screenWidth * (percentage / 100);
    }

    double relativeHeight(double percentage) {
      return screenHeight * (percentage / 100);
    }

    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeManager.themeData.hintColor,
        title: Text(
          "Playlists",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              color: themeManager.themeData.primaryColor,
              fontSize: relativeWidth(5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: themeManager.themeData.primaryColor,
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: themeManager.themeData.scaffoldBackgroundColor,
            ),
          ),
          Center(
            child: FutureBuilder<List<dynamic>>(
              future: _fetchSongsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<dynamic> songs = snapshot.data ?? [];
                  return Column(
                    children: [
                      buildGradientCircle(
                          widget.genreName, widget.gradientColors, context),
                      SizedBox(height: relativeHeight(4)),
                      Expanded(
                        child: ListView.builder(
                          itemCount: songs.length,
                          itemBuilder: (BuildContext context, int index) {
                            final song = songs[index];
                            final videoId = song['id']['videoId'];
                            final fullTitle = song['snippet']['title'];
                            final thumbnailUrl = song['snippet']['thumbnails']
                                        ['maxres'] !=
                                    null
                                ? song['snippet']['thumbnails']['maxres']['url']
                                : (song['snippet']['thumbnails']['standard'] !=
                                        null
                                    ? song['snippet']['thumbnails']['standard']
                                        ['url']
                                    : (song['snippet']['thumbnails']['high'] !=
                                            null
                                        ? song['snippet']['thumbnails']['high']
                                            ['url']
                                        : song['snippet']['thumbnails']
                                                    ['medium'] !=
                                                null
                                            ? song['snippet']['thumbnails']
                                                ['medium']['url']
                                            : song['snippet']['thumbnails']
                                                ['default']['url']));

                            final parts = fullTitle.split(RegExp(r' - | \| '));
                            String songName = '';

                            for (String part in parts) {
                              if (part
                                  .toLowerCase()
                                  .contains(widget.genreName.toLowerCase())) {
                                songName =
                                    fullTitle.replaceAll(part, '').trim();
                                break;
                              }
                            }

                            if (songName.isEmpty) {
                              songName = fullTitle;
                            }

                            int newLength = (relativeWidth(55) / 8).floor();

                            if (songName.length > newLength) {
                              songName =
                                  '${songName.substring(0, newLength)}..';
                            }

                            final songData = {
                              'id': videoId,
                              'title': fullTitle,
                              'thumbnailUrl': thumbnailUrl,
                            };

                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SizedBox(
                                  width: relativeWidth(12),
                                  height: relativeWidth(12),
                                  child: Image.network(
                                    thumbnailUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    songName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        color:
                                            themeManager.themeData.primaryColor,
                                        fontSize: relativeWidth(3.5),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    widget.genreName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        color:
                                            themeManager.themeData.primaryColor,
                                        fontSize: relativeWidth(3),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.favorite),
                                color: themeManager.themeData.hintColor,
                                onPressed: () {
                                  if (_isSongInFavorites(songData)) {
                                    _showAlreadyInFavoritesDialog(context);
                                  } else {
                                    _showAddFavConfirmationDialog(
                                        context, songData);
                                  }
                                },
                              ),
                              onTap: () async {
                                Provider.of<CurrentSongProvider>(context,
                                        listen: false)
                                    .setSong(videoId, songName,
                                        widget.genreName, thumbnailUrl);

                                setState(() {
                                  recentPlayed.add(songData);
                                });

                                await _saveRecentPlayed();
                                Provider.of<RecentPlayedProvider>(context,
                                        listen: false)
                                    .addRecentSong(songData);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PlayerPage(
                                      flag: true,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
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

Widget buildGradientCircle(
    String genreName, List<Color> gradientColors, BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  double relativeWidth(double percentage) {
    return screenWidth * (percentage / 100);
  }

  double relativeHeight(double percentage) {
    return screenHeight * (percentage / 100);
  }

  return Column(
    children: [
      Container(
        width: relativeWidth(60),
        height: relativeHeight(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            genreName,
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Color.fromARGB(255, 255, 181, 181),
                fontSize: relativeWidth(6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

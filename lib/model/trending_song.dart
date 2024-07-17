import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/model/recent_songs.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'package:soul_healer/providers/fav_song_provider.dart';
import 'package:soul_healer/providers/recent_played_provider.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:soul_healer/screen/player_screen.dart';
import 'package:path_provider/path_provider.dart';

class TrendingSong extends StatefulWidget {
  TrendingSong(
      {super.key,
      required this.trendingSongs,
      required this.showMore,
      required this.formatTitle});

  final List<dynamic> trendingSongs;
  bool showMore;
  final String Function(String) formatTitle;

  @override
  State<TrendingSong> createState() => _TrendingSongState();
}

class _TrendingSongState extends State<TrendingSong> {
  List<dynamic> recentPlayed = [];
  List<dynamic> favPlayed = [];

  @override
  void initState() {
    super.initState();
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
    final itemCount = widget.showMore ? widget.trendingSongs.length : 5;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double relativeWidth(double percentage) {
      return screenWidth * (percentage / 100);
    }

    double relativeHeight(double percentage) {
      return screenHeight * (percentage / 100);
    }

    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Consumer<RecentPlayedProvider>(
          builder: (context, recentPlayedProvider, child) {
            return RecentSong(formatTitle: widget.formatTitle);
          },
        ),
        SizedBox(
          height: relativeHeight(3),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: relativeWidth(5)),
              child: Text(
                "Trending Songs",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: relativeWidth(5),
                    color: themeManager.themeData.hintColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: relativeHeight(2)),
        if (widget.trendingSongs.isEmpty)
          Center(
            child: Text(
              "No recent played songs available",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: relativeWidth(4),
                  color: themeManager.themeData.primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: widget.showMore ? null : relativeHeight(8.0 * itemCount),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                final song = widget.trendingSongs[index];
                final videoId = song['id'];
                final fullTitle = song['snippet']['title'];
                final thumbnailUrl = song['snippet']['thumbnails']['maxres'] !=
                        null
                    ? song['snippet']['thumbnails']['maxres']['url']
                    : (song['snippet']['thumbnails']['standard'] != null
                        ? song['snippet']['thumbnails']['standard']['url']
                        : (song['snippet']['thumbnails']['high'] != null
                            ? song['snippet']['thumbnails']['high']['url']
                            : song['snippet']['thumbnails']['medium'] != null
                                ? song['snippet']['thumbnails']['medium']['url']
                                : song['snippet']['thumbnails']['default']
                                    ['url']));

                final parts = fullTitle.split(RegExp(r' - | \| '));
                String songName = '';
                String artistName = '';

                if (parts.length >= 2) {
                  songName = parts[0].trim();
                  artistName = parts[1].trim();
                } else {
                  songName = fullTitle;
                  artistName = 'Unknown Artist';
                }

                songName = widget.formatTitle(songName);
                artistName = widget.formatTitle(artistName);

                int newLength = (relativeWidth(55) / 8).floor();

                if (songName.length > newLength) {
                  songName = '${songName.substring(0, newLength)}..';
                }
                if (artistName.length > newLength) {
                  artistName = '${artistName.substring(0, newLength)}..';
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
                            fontSize: relativeWidth(3.5),
                            color: themeManager.themeData.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        artistName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: relativeWidth(3),
                            color: themeManager.themeData.primaryColor,
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
                        _showAddFavConfirmationDialog(context, songData);
                      }
                    },
                  ),
                  onTap: () async {
                    Provider.of<CurrentSongProvider>(context, listen: false)
                        .setSong(videoId, songName, artistName, thumbnailUrl);

                    setState(() {
                      recentPlayed.add(songData);
                    });

                    await _saveRecentPlayed();
                    Provider.of<RecentPlayedProvider>(context, listen: false)
                        .addRecentSong(songData);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlayerPage(flag: true),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        SizedBox(
          height: 10,
        ),
        widget.trendingSongs.length > 5
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    widget.showMore = !widget.showMore;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(relativeWidth(3)),
                  decoration: BoxDecoration(
                    color: themeManager.themeData.hintColor,
                    borderRadius: BorderRadius.circular(relativeWidth(2)),
                    boxShadow: [
                      BoxShadow(
                        color: themeManager.themeData.primaryColor
                            .withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    widget.showMore ? 'See Less' : 'See More',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: themeManager.themeData.primaryColor,
                        fontSize: relativeWidth(3),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(
                height: 0,
              ),
      ],
    );
  }

  Future<void> _showAddFavConfirmationDialog(
      BuildContext context, dynamic songData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
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

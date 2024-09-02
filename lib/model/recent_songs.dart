import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'package:soul_healer/providers/fav_song_provider.dart';
import 'package:soul_healer/providers/recent_played_provider.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:soul_healer/screen/player_screen.dart';

class RecentSong extends StatefulWidget {
  const RecentSong({super.key, required this.formatTitle});

  final String Function(String) formatTitle;

  @override
  _RecentSongState createState() => _RecentSongState();
}

class _RecentSongState extends State<RecentSong> {
  bool showMore = false;
  List<dynamic> favPlayed = [];

  @override
  void initState() {
    super.initState();
    _loadFavPlayed();
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
    return Consumer<RecentPlayedProvider>(
      builder: (context, recentPlayedProvider, child) {
        return buildRecentSongsSection(
            context, 'Recent Played', recentPlayedProvider.recentSongs);
      },
    );
  }

  Widget buildRecentSongsSection(
      BuildContext context, String title, List<dynamic> recentSongList) {
    int itemCount = showMore
        ? (recentSongList.length < 20 ? recentSongList.length : 20)
        : (recentSongList.length < 5 ? recentSongList.length : 5);

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
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: relativeWidth(5)),
              child: Text(
                title,
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
        recentSongList.isNotEmpty
            ? SizedBox(
                height: showMore ? null : relativeHeight(8.0 * itemCount),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    final song =
                        recentSongList[recentSongList.length - 1 - index];
                    final fullTitle = song['title'];
                    final thumbnailUrl = song['thumbnailUrl'];

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

                    int newLength = (relativeWidth(25) / 8).floor();

                    if (songName.length > newLength) {
                      songName = '${songName.substring(0, newLength)}..';
                    }
                    if (artistName.length > newLength) {
                      artistName = '${artistName.substring(0, newLength)}..';
                    }

                    final songId = song['id'];

                    final songData = {
                      'id': songId,
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
                      onTap: () {
                        Provider.of<CurrentSongProvider>(context, listen: false)
                            .setSong(
                                songId, songName, artistName, thumbnailUrl);
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
              )
            : Center(
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
              ),
        SizedBox(
          height: 10,
        ),
        recentSongList.length > 5
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    showMore = !showMore;
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
                    showMore ? 'See Less' : 'See More',
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

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'package:soul_healer/providers/fav_song_provider.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:soul_healer/screen/player_screen.dart';

class FavPageModel extends StatefulWidget {
  const FavPageModel({super.key});

  @override
  _FavPageModelState createState() => _FavPageModelState();
}

String formatTitle(String title) {
  if (title.isEmpty) {
    return 'Unknown Title';
  } else {
    List<String> words = title.split(' ');
    if (words.isEmpty) return title;
    words[0] = words[0][0].toUpperCase() + words[0].substring(1).toLowerCase();
    for (int i = 1; i < words.length; i++) {
      words[i] = words[i].toLowerCase();
    }
    return words.join(' ');
  }
}

class _FavPageModelState extends State<FavPageModel> {
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
      print("Error loading favorite played songs: $e");
    }
  }

  Future<void> _saveFavPlayed() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/fav_played.json');
      await file.writeAsString(json.encode(favPlayed));
    } catch (e) {
      print("Error saving favorite played songs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavSongProvider>(
      builder: (context, favPlayedProvider, child) {
        return buildFavSongsSection(
            context, 'Your Fav Songs', favPlayedProvider.favSongs);
      },
    );
  }

  Widget buildFavSongsSection(
      BuildContext context, String title, List<dynamic> favSongList) {
    int itemCount = favSongList.length;

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: relativeHeight(3)),
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
        SizedBox(height: relativeHeight(2)),
        favSongList.isNotEmpty
            ? SizedBox(
                height: relativeHeight(8.0 * itemCount),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    final song = favSongList[favSongList.length - 1 - index];
                    final fullTitle = song['title'] ?? 'Unknown Title';
                    final thumbnailUrl = song['thumbnailUrl'] ?? '';
                    final songId = song['id'] ?? '';

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

                    songName = formatTitle(songName);
                    artistName = formatTitle(artistName);

                    int newLength = (relativeWidth(25) / 8).floor();

                    if (songName.length > newLength) {
                      songName = '${songName.substring(0, newLength)}..';
                    }
                    if (artistName.length > newLength) {
                      artistName = '${artistName.substring(0, newLength)}..';
                    }

                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: relativeWidth(12),
                          height: relativeWidth(12),
                          child: Image.network(
                            thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error);
                            },
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
                        icon: Icon(
                          Icons.delete_forever_rounded,
                          size: relativeWidth(6),
                        ),
                        color: themeManager.themeData.hintColor,
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, song, index);
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
        SizedBox(height: 10),
      ],
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, dynamic song, int index) async {
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
                    'Are you sure you want to delete "${song['title']}" from your favorite songs?'),
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
              onPressed: () {
                setState(() {
                  favPlayed.removeWhere((item) => item['id'] == song['id']);
                });

                _saveFavPlayed();

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

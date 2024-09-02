import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'package:soul_healer/providers/recent_played_provider.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:soul_healer/screen/player_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Tophits extends StatefulWidget {
  const Tophits({
    super.key,
    required this.topHitsSongs,
    required this.formatTitle,
  });

  final List<dynamic> topHitsSongs;
  final String Function(String) formatTitle;

  @override
  State<Tophits> createState() => _TophitsState();
}

class _TophitsState extends State<Tophits> {
  final PageController _pageController = PageController();
  List<dynamic> recentPlayed = [];

  @override
  void initState() {
    super.initState();
    _loadRecentPlayed();
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: relativeWidth(5)),
              child: Text(
                "Top Hits Songs for you",
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
        SizedBox(
          height: relativeHeight(38),
          child: widget.topHitsSongs.isEmpty
              ? Center(
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
              : PageView.builder(
                  controller: _pageController,
                  itemCount: widget.topHitsSongs.length,
                  itemBuilder: (context, index) {
                    final song = widget.topHitsSongs[index];
                    final fullTitle = song['snippet']['title'];
                    final videoId = song['id']['videoId'];
                    final thumbnailUrl = song['snippet']['thumbnails']
                                ['maxres'] !=
                            null
                        ? song['snippet']['thumbnails']['maxres']['url']
                        : (song['snippet']['thumbnails']['standard'] != null
                            ? song['snippet']['thumbnails']['standard']['url']
                            : (song['snippet']['thumbnails']['high'] != null
                                ? song['snippet']['thumbnails']['high']['url']
                                : song['snippet']['thumbnails']['medium'] !=
                                        null
                                    ? song['snippet']['thumbnails']['medium']
                                        ['url']
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

                    int newLength = (relativeWidth(25) / 8).floor();

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

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Provider.of<CurrentSongProvider>(context,
                                      listen: false)
                                  .setSong(videoId, songName, artistName,
                                      thumbnailUrl);
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
                                  builder: (context) =>
                                      const PlayerPage(flag: true),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(relativeWidth(6)),
                              child: Image.network(
                                thumbnailUrl,
                                width: relativeWidth(95),
                                height: relativeHeight(33),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        if (widget.topHitsSongs.isNotEmpty)
          SmoothPageIndicator(
            controller: _pageController,
            count: widget.topHitsSongs.length,
            effect: ExpandingDotsEffect(
              dotHeight: relativeHeight(1),
              dotWidth: relativeWidth(2),
              activeDotColor: themeManager.themeData.hintColor,
              dotColor: themeManager.themeData.primaryColor,
            ),
          ),
      ],
    );
  }
}

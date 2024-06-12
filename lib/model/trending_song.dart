import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/model/recent_songs.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'package:soul_healer/providers/recent_played_provider.dart';
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
    final itemCount = widget.showMore ? widget.trendingSongs.length : 5;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double relativeWidth(double percentage) {
      return screenWidth * (percentage / 100);
    }

    double relativeHeight(double percentage) {
      return screenHeight * (percentage / 100);
    }

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
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: relativeHeight(2)),
        if (widget.trendingSongs.isEmpty)
          const Text("No trending songs available")
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
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      thumbnailUrl,
                      width: relativeWidth(15),
                      height: relativeWidth(15),
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
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_horiz_rounded),
                    onPressed: () {},
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
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(relativeWidth(2)),
                  ),
                  child: Text(
                    widget.showMore ? 'See Less' : 'See More',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.white,
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
}

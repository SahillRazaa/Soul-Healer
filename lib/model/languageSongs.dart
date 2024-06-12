import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'package:soul_healer/providers/recent_played_provider.dart';
import 'package:soul_healer/screen/player_screen.dart';
import 'package:soul_healer/utilities/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Languagesongs extends StatefulWidget {
  const Languagesongs({
    Key? key,
    required this.languageName,
    required this.languageImage,
  }) : super(key: key);

  final String languageName;
  final String languageImage;

  @override
  State<Languagesongs> createState() => _LanguagesongsState();
}

class _LanguagesongsState extends State<Languagesongs> {
  late Future<List<dynamic>> _fetchSongsFuture;

  Future<List<dynamic>> fetchLanguageVideos() async {
    const apiKey = Constants.YoutubeKey;
    String languageName = widget.languageName;

    try {
      final searchVideosUrl = 'https://www.googleapis.com/youtube/v3/search'
          '?part=snippet'
          '&q=${Uri.encodeComponent(languageName)}'
          '&type=video'
          '&maxResults=30'
          '&videoCategoryId=10'
          '&regionCode=IN'
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

  @override
  void initState() {
    super.initState();
    _fetchSongsFuture = fetchLanguageVideos();
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 59, 158, 211),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Music for Every Mood",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
          style: GoogleFonts.cedarvilleCursive(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: relativeWidth(5),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
      body: Center(
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
                  SizedBox(height: relativeHeight(3)),
                  Text(
                    widget.languageName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: relativeWidth(5),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(height: relativeHeight(1)),
                  Container(
                    width: relativeWidth(35),
                    height: relativeWidth(35),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 191, 133, 133),
                        width: relativeWidth(1.5),
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        widget.languageImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: relativeHeight(3)),
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
                            : (song['snippet']['thumbnails']['standard'] != null
                                ? song['snippet']['thumbnails']['standard']
                                    ['url']
                                : (song['snippet']['thumbnails']['high'] != null
                                    ? song['snippet']['thumbnails']['high']
                                        ['url']
                                    : song['snippet']['thumbnails']['medium'] !=
                                            null
                                        ? song['snippet']['thumbnails']
                                            ['medium']['url']
                                        : song['snippet']['thumbnails']
                                            ['default']['url']));

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

                        int newLength = (relativeWidth(55) / 8).floor();

                        if (songName.length > newLength) {
                          songName = '${songName.substring(0, newLength)}..';
                        }
                        if (artistName.length > newLength) {
                          artistName =
                              '${artistName.substring(0, newLength)}..';
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
    );
  }
}

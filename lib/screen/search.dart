import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'package:soul_healer/providers/recent_played_provider.dart';
import 'package:soul_healer/providers/search_provider.dart';
import 'package:soul_healer/screen/player_screen.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> recentPlayed = [];
  List<dynamic> recentSearches = [];
  bool showMoreRecentSearches = false;

  @override
  void initState() {
    super.initState();
    _loadRecentPlayed();
    _loadRecentSearches();
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

  Future<void> _loadRecentSearches() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/recent_searches.json');
      if (await file.exists()) {
        String recentSearchesString = await file.readAsString();
        setState(() {
          recentSearches = json.decode(recentSearchesString);
        });
      }
    } catch (e) {
      print("Error loading recent searches: $e");
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

  Future<void> _saveRecentSearches() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/recent_searches.json');
      await file.writeAsString(json.encode(recentSearches));
    } catch (e) {
      print("Error saving recent searches: $e");
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

  String _query = '';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double relativeWidth(double percentage) {
      return screenWidth * (percentage / 100);
    }

    final screenHeight = MediaQuery.of(context).size.height;

    double relativeHeight(double percentage) {
      return screenHeight * (percentage / 100);
    }

    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.7,
            child: Container(
              color: const Color.fromARGB(255, 122, 173, 200),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                "assets/pattern.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(relativeWidth(5)),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Search Songs',
                        border: OutlineInputBorder(),
                        prefixIcon: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: Icon(Icons.arrow_back),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _query = '';
                            });
                          },
                          child: Icon(Icons.clear),
                        ),
                      ),
                      onChanged: (query) {
                        setState(() {
                          _query = query;
                        });
                        Provider.of<SearchProvider>(context, listen: false)
                            .searchSongs(query);
                      },
                    ),
                    SizedBox(
                      height: relativeHeight(2),
                    ),
                    _query.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Recent Searches",
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: relativeWidth(5),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              recentSearches.isEmpty
                                  ? const Text("No recent searches")
                                  : buildRecentSearchesSection(
                                      context,
                                      recentSearches,
                                      showMoreRecentSearches,
                                      relativeWidth,
                                      relativeHeight,
                                    ),
                              SizedBox(
                                height: relativeHeight(3),
                              ),
                              Text(
                                "Explore Songs by Genre",
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: relativeWidth(5),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Consumer<SearchProvider>(
                            builder: (context, searchProvider, child) {
                              if (searchProvider.isLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (searchProvider.songs.isEmpty) {
                                return const Center(
                                    child: Text("No songs found"));
                              }

                              return ListView.builder(
                                itemCount: searchProvider.songs.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final Video song =
                                      searchProvider.songs[index];
                                  final videoId = song.id.value;
                                  final fullTitle = song.title;
                                  final thumbnailUrl =
                                      song.thumbnails.standardResUrl;
                                  final parts =
                                      fullTitle.split(RegExp(r' - | \| '));
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

                                  int newLength =
                                      (relativeWidth(55) / 8).floor();

                                  if (songName.length > newLength) {
                                    songName =
                                        '${songName.substring(0, newLength)}..';
                                  }
                                  if (artistName.length > newLength) {
                                    artistName =
                                        '${artistName.substring(0, newLength)}..';
                                  }

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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          songName,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: false,
                                          style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                              fontSize: relativeWidth(3),
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
                                      icon:
                                          const Icon(Icons.more_horiz_rounded),
                                      onPressed: () {},
                                    ),
                                    onTap: () async {
                                      final songData = {
                                        'id': videoId,
                                        'title': fullTitle,
                                        'thumbnailUrl': thumbnailUrl,
                                        'artist': artistName
                                      };

                                      Provider.of<CurrentSongProvider>(context,
                                              listen: false)
                                          .setSong(
                                        videoId,
                                        songName,
                                        artistName,
                                        thumbnailUrl,
                                      );

                                      // Remove previous instances of the song
                                      setState(() {
                                        recentSearches.removeWhere((element) =>
                                            element['id'] == videoId);
                                        recentPlayed.removeWhere((element) =>
                                            element['id'] == videoId);

                                        recentSearches.add(songData);
                                        recentPlayed.add(songData);
                                      });

                                      await _saveRecentSearches();
                                      await _saveRecentPlayed();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PlayerPage(
                                            flag: true,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecentSearchesSection(
      BuildContext context,
      List<dynamic> recentSearches,
      bool showMore,
      double Function(double) relativeWidth,
      double Function(double) relativeHeight) {
    int itemCount = showMore
        ? (recentSearches.length < 20 ? recentSearches.length : 20)
        : (recentSearches.length < 5 ? recentSearches.length : 5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: showMore ? null : relativeHeight(8.0 * itemCount),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final song = recentSearches[recentSearches.length - 1 - index];
              final parts = song['title'].split(RegExp(r' - | \| '));
              String songName = '';

              if (parts.length >= 2) {
                songName = parts[0].trim();
              } else {
                songName = song['title'];
              }

              songName = formatTitle(songName);

              int newLength = (relativeWidth(55) / 8).floor();

              if (songName.length > newLength) {
                songName = '${songName.substring(0, newLength)}..';
              }

              return ListTile(
                leading: Image.network(
                  song['thumbnailUrl'],
                  width: relativeWidth(15),
                  height: relativeWidth(15),
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
                      song['artist'],
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
                  icon: const Icon(Icons.delete_forever_rounded),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, song, index);
                  },
                ),
                onTap: () {
                  setState(() {
                    _query = song['title'];
                  });
                  Provider.of<SearchProvider>(context, listen: false)
                      .searchSongs(_query);
                },
              );
            },
          ),
        ),
        recentSearches.length > 5
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    showMoreRecentSearches = !showMoreRecentSearches;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(relativeWidth(3)),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(relativeWidth(2)),
                  ),
                  child: Text(
                    showMore ? 'See Less' : 'See More',
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
                    'Are you sure you want to delete "${song['title']}" from recent searches?'),
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
                  recentSearches.removeAt(index);
                });
                await _saveRecentSearches();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

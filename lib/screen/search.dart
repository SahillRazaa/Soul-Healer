import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:soul_healer/model/genreList.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'package:soul_healer/providers/fav_song_provider.dart';
import 'package:soul_healer/providers/recent_played_provider.dart';
import 'package:soul_healer/providers/search_provider.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:soul_healer/screen/player_screen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> recentPlayed = [];
  List<dynamic> recentSearches = [];
  List<dynamic> favPlayed = [];
  bool showMoreRecentSearches = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadRecentPlayed();
    _loadRecentSearches();
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

  String formatTitle(String title) {
    List<String> words = title.split(' ');
    if (words.isEmpty) return title;
    words[0] = words[0][0].toUpperCase() + words[0].substring(1).toLowerCase();
    for (int i = 1; i < words.length; i++) {
      words[i] = words[i].toLowerCase();
    }
    return words.join(' ');
  }

  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: themeManager.themeData.scaffoldBackgroundColor,
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
                      cursorColor:
                          themeManager.themeData.scaffoldBackgroundColor,
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Search Song Name',
                        hintStyle: TextStyle(
                          color: themeManager.themeData.scaffoldBackgroundColor,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            width: 1.5,
                          ),
                        ),
                        fillColor: themeManager.themeData.primaryColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color:
                                themeManager.themeData.scaffoldBackgroundColor,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _controller.clear();
                            setState(() {
                              _query = '';
                            });
                            Provider.of<SearchProvider>(context, listen: false)
                                .searchSongs('');
                          },
                          child: Icon(
                            Icons.clear,
                            color:
                                themeManager.themeData.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: themeManager.themeData.scaffoldBackgroundColor,
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
                                    color: themeManager.themeData.hintColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              recentSearches.isEmpty
                                  ? Text(
                                      "No recent searches",
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          fontSize: relativeWidth(3),
                                          color: themeManager
                                              .themeData.primaryColor,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    )
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
                                    color: themeManager.themeData.hintColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              GenreListScreen(),
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
                                    child: Text(
                                  "No songs found",
                                ));
                              }

                              return ListView.builder(
                                itemCount: searchProvider.songs.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final song = searchProvider.songs[index];
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
                                              color: themeManager
                                                  .themeData.primaryColor,
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
                                              color: themeManager
                                                  .themeData.primaryColor,
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
                                          _showAlreadyInFavoritesDialog(
                                              context);
                                        } else {
                                          _showAddFavConfirmationDialog(
                                              context, songData);
                                        }
                                      },
                                    ),
                                    onTap: () async {
                                      Provider.of<CurrentSongProvider>(context,
                                              listen: false)
                                          .setSong(
                                        videoId,
                                        songName,
                                        artistName,
                                        thumbnailUrl,
                                      );

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

    final themeManager = Provider.of<ThemeManager>(context, listen: true);

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
              final parts = (song['title'] ?? '').split(RegExp(r' - | \| '));
              String songName = '';

              if (parts.length >= 2) {
                songName = parts[0].trim();
              } else {
                songName = song['title'] ?? 'Unknown Title';
              }

              songName = formatTitle(songName);

              int newLength = (relativeWidth(55) / 8).floor();

              if (songName.length > newLength) {
                songName = '${songName.substring(0, newLength)}..';
              }

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: relativeWidth(12),
                    height: relativeWidth(12),
                    child: Image.network(
                      song['thumbnailUrl'] ?? '',
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
                      song['artist'] ?? 'Unknown Artist',
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
                  setState(() {
                    _query = song['title'] ?? '';
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
                  recentSearches
                      .removeWhere((item) => item['id'] == song['id']);
                });
                _saveRecentSearches();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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

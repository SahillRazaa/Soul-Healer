import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'package:soul_healer/providers/recent_played_provider.dart';
import 'package:soul_healer/screen/player_screen.dart';

class Recentsearchmodel extends StatefulWidget {
  const Recentsearchmodel({super.key, required this.formatTitle});

  final String Function(String) formatTitle;

  @override
  _RecentsearchmodelState createState() => _RecentsearchmodelState();
}

class _RecentsearchmodelState extends State<Recentsearchmodel> {
  bool showMore = false;

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

                    int newLength = (relativeWidth(55) / 8).floor();

                    if (songName.length > newLength) {
                      songName = '${songName.substring(0, newLength)}..';
                    }
                    if (artistName.length > newLength) {
                      artistName = '${artistName.substring(0, newLength)}..';
                    }

                    final songId = song['id'];

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
            : const Text("No recent played songs available"),
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
}

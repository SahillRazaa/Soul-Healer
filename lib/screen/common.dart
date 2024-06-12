import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soul_healer/providers/audio_player_provider.dart';
import 'package:soul_healer/model/footer.dart';
import 'package:soul_healer/providers/app_screen.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'player_screen.dart';
import 'home.dart';
import 'search.dart';
import 'fav.dart';
import 'setting.dart';

class CommonPage extends StatefulWidget {
  const CommonPage({super.key});

  @override
  State<CommonPage> createState() => _CommonPageState();
}

class _CommonPageState extends State<CommonPage> {
  late AudioPlayerProvider audioProvider;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final audioProvider = Provider.of<AudioPlayerProvider>(context);
    final songProvider = Provider.of<CurrentSongProvider>(context);

    Widget currwidget;
    switch (appState.currentPage) {
      case '/search':
        currwidget = const SearchPage();
        break;
      case '/favourite':
        currwidget = const FavPage();
        break;
      case '/settings':
        currwidget = const SettingPage();
        break;
      case '/home':
      default:
        currwidget = const HomePage();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double relativeWidth(double percentage) {
      return screenWidth * (percentage / 100);
    }

    double relativeHeight(double percentage) {
      return screenHeight * (percentage / 100);
    }

    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 1,
            child: Container(
              color: const Color.fromARGB(255, 91, 244, 255),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                "assets/background.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: currwidget,
                ),
                songProvider.currSong != ''
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PlayerPage(
                                flag: false,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: double.infinity,
                          height: relativeHeight(6),
                          child: Row(
                            children: [
                              Image.network(
                                songProvider.songImage,
                                width: relativeWidth(15),
                              ),
                              SizedBox(
                                width: relativeHeight(1),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    songProvider.songName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        fontSize: relativeWidth(4),
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    songProvider.artistName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                          fontSize: relativeWidth(3),
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                iconSize: relativeWidth(8),
                                onPressed: () {
                                  audioProvider.playPause();
                                },
                                icon: audioProvider.isPlaying
                                    ? const Icon(Icons.pause)
                                    : const Icon(Icons.play_arrow),
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(height: 0),
                const Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

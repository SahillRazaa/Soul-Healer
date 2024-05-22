import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/model/footer.dart';
import 'package:soul_healer/screen/player_screen.dart';
import 'app_screen.dart';
import 'home.dart';
import 'songs.dart';
import 'search.dart';
import 'fav.dart';
import 'setting.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonPage extends StatefulWidget {
  const CommonPage({super.key});

  @override
  State<CommonPage> createState() => _CommonPageState();
}

class _CommonPageState extends State<CommonPage> {
  bool isPlaying = false;

  String currSongImage = 'assets/song_poster.jpeg';

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    Widget currwidget;
    switch (appState.currentPage) {
      case '/songs':
        currwidget = const SongPage();
        break;
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerPage(
                          songImage: currSongImage,
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      children: [
                        Image.asset(
                          currSongImage,
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gulabi Sadi",
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Text(
                              "Sanju Rathod, G-SPXRK - Gulabi Sadi",
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        IconButton(
                          iconSize: 35,
                          onPressed: () {
                            setState(() {
                              isPlaying = !isPlaying;
                            });
                          },
                          icon: isPlaying
                              ? const Icon(Icons.pause)
                              : const Icon(Icons.play_arrow),
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                const Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

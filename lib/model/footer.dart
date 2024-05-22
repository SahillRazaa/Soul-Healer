import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/screen/app_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  Color homeIconColor = const Color.fromARGB(255, 255, 173, 50);
  Color songsIconColor = Colors.black;
  Color searchIconColor = Colors.black;
  Color favouriteIconColor = Colors.black;
  Color settingsIconColor = Colors.black;

  Color homeTextColor = const Color.fromARGB(255, 255, 173, 50);
  Color songsTextColor = Colors.black;
  Color searchTextColor = Colors.black;
  Color favouriteTextColor = Colors.black;
  Color settingsTextColor = Colors.black;

  double homesize = 35;
  double songsize = 30;
  double searchsize = 30;
  double favsize = 30;
  double settingsize = 30;

  double hometxtsize = 13;
  double songtxtsize = 12;
  double searchtxtsize = 12;
  double favtxtsize = 12;
  double settingtxtsize = 12;

  void _resetIconSizesAndColors() {
    setState(() {
      homeIconColor = Colors.black;
      songsIconColor = Colors.black;
      searchIconColor = Colors.black;
      favouriteIconColor = Colors.black;
      settingsIconColor = Colors.black;

      homeTextColor = Colors.black;
      songsTextColor = Colors.black;
      searchTextColor = Colors.black;
      favouriteTextColor = Colors.black;
      settingsTextColor = Colors.black;

      homesize = 30;
      songsize = 30;
      searchsize = 30;
      favsize = 30;
      settingsize = 30;

      hometxtsize = 12;
      songtxtsize = 12;
      searchtxtsize = 12;
      favtxtsize = 12;
      settingtxtsize = 12;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Container(
      height: 80,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromARGB(132, 75, 137, 170),
        border: BorderDirectional(
          top: BorderSide(
            color: Color.fromARGB(233, 0, 0, 0),
            width: 2.0,
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIconColumn(
              icon: Icons.home,
              label: 'Home',
              iconColor: homeIconColor,
              textColor: homeTextColor,
              iconSize: homesize,
              fontSize: hometxtsize,
              onPressed: () {
                _resetIconSizesAndColors();
                setState(() {
                  homeIconColor = const Color.fromARGB(255, 255, 173, 50);
                  homeTextColor = const Color.fromARGB(255, 255, 173, 50);
                  homesize = 35;
                  hometxtsize = 13;
                });
                appState.setPage('/home');
              },
            ),
            _buildIconColumn(
              icon: Icons.my_library_music_sharp,
              label: 'Songs',
              iconColor: songsIconColor,
              textColor: songsTextColor,
              iconSize: songsize,
              fontSize: songtxtsize,
              onPressed: () {
                _resetIconSizesAndColors();
                setState(() {
                  songsIconColor = const Color(0xFFCDDC39);
                  songsTextColor = const Color(0xFFCDDC39);
                  songsize = 35;
                  songtxtsize = 13;
                });
                appState.setPage('/songs');
              },
            ),
            _buildIconColumn(
              icon: Icons.search_outlined,
              label: 'Search',
              iconColor: searchIconColor,
              textColor: searchTextColor,
              iconSize: searchsize,
              fontSize: searchtxtsize,
              onPressed: () {
                _resetIconSizesAndColors();
                setState(() {
                  searchIconColor = const Color(0xFFFFFFFF);
                  searchTextColor = const Color(0xFFFFFFFF);
                  searchsize = 35;
                  searchtxtsize = 13;
                });
                appState.setPage('/search');
              },
            ),
            _buildIconColumn(
              icon: Icons.favorite_rounded,
              label: 'Favourite',
              iconColor: favouriteIconColor,
              textColor: favouriteTextColor,
              iconSize: favsize,
              fontSize: favtxtsize,
              onPressed: () {
                _resetIconSizesAndColors();
                setState(() {
                  favouriteIconColor = const Color(0xFFF44336);
                  favouriteTextColor = const Color(0xFFF44336);
                  favsize = 35;
                  favtxtsize = 13;
                });
                appState.setPage('/favourite');
              },
            ),
            _buildIconColumn(
              icon: Icons.miscellaneous_services_rounded,
              label: 'Settings',
              iconColor: settingsIconColor,
              textColor: settingsTextColor,
              iconSize: settingsize,
              fontSize: settingtxtsize,
              onPressed: () {
                _resetIconSizesAndColors();
                setState(() {
                  settingsIconColor = const Color(0xFFB0BEC5);
                  settingsTextColor = const Color(0xFFB0BEC5);
                  settingsize = 35;
                  settingtxtsize = 13;
                });
                appState.setPage('/settings');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconColumn({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color textColor,
    required double iconSize,
    required double fontSize,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.spaceMono(
                textStyle: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

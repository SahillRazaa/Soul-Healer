import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/model/languageSongs.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:soul_healer/utilities/topLanguageSongList.dart';

class Languagelist extends StatefulWidget {
  const Languagelist({
    Key? key,
  }) : super(key: key);

  @override
  State<Languagelist> createState() => _LanguagelistState();
}

class _LanguagelistState extends State<Languagelist> {
  @override
  Widget build(BuildContext context) {
    return buildLanguageHitsSongSection('Songs of Languages');
  }

  Widget buildLanguageHitsSongSection(String title) {
    final screenWidth = MediaQuery.of(context).size.width;

    double relativeWidth(double percentage) {
      return screenWidth * (percentage / 100);
    }

    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                color: themeManager.themeData.hintColor,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        buildLaunguageList(context),
      ],
    );
  }
}

Widget buildLaunguageList(BuildContext context) {
  List<Languagesong> artists = LanguagesongList.languageInfo;

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (var artist in artists) buildLanguageRow(artist, context),
      ],
    ),
  );
}

Widget buildLanguageRow(Languagesong languageInfo, BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  double relativeWidth(double percentage) {
    return screenWidth * (percentage / 100);
  }

  double relativeHeight(double percentage) {
    return screenHeight * (percentage / 100);
  }

  final themeManager = Provider.of<ThemeManager>(context, listen: true);

  return Padding(
    padding: EdgeInsets.all(relativeWidth(3)),
    child: Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Languagesongs(
                  languageName: languageInfo.name,
                  languageImage: languageInfo.imageUrl,
                ),
              ),
            );
          },
          child: CircleAvatar(
            radius: relativeWidth(15),
            backgroundImage: NetworkImage(languageInfo.imageUrl),
          ),
        ),
        SizedBox(height: relativeHeight(2)),
        Text(
          languageInfo.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: relativeWidth(4),
              color: themeManager.themeData.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

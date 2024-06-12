import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soul_healer/model/artistSongs.dart';
import 'package:soul_healer/utilities/artistsNameList.dart';

class Artistlist extends StatefulWidget {
  const Artistlist({
    super.key,
  });

  @override
  State<Artistlist> createState() => _ArtistlistState();
}

class _ArtistlistState extends State<Artistlist> {
  @override
  Widget build(BuildContext context) {
    return buildTopHitsSongSection('Top singers for you');
  }

  Widget buildTopHitsSongSection(String title) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double relativeWidth(double percentage) {
      return screenWidth * (percentage / 100);
    }

    double relativeHeight(double percentage) {
      return screenHeight * (percentage / 100);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: relativeHeight(2),
        ),
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
        buildArtistList(context),
      ],
    );
  }
}

Widget buildArtistList(BuildContext context) {
  List<ArtistInfo> artists = ArtistsNameList.artistInfos;

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (var artist in artists) buildArtistRow(artist, context),
      ],
    ),
  );
}

Widget buildArtistRow(ArtistInfo artistInfo, BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  double relativeWidth(double percentage) {
    return screenWidth * (percentage / 100);
  }

  double relativeHeight(double percentage) {
    return screenHeight * (percentage / 100);
  }

  return Padding(
    padding: EdgeInsets.all(relativeWidth(3)),
    child: Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Artistsongs(
                  artistName: artistInfo.name,
                  artistImage: artistInfo.imageUrl,
                ),
              ),
            );
          },
          child: CircleAvatar(
            radius: relativeWidth(15),
            backgroundImage: NetworkImage(artistInfo.imageUrl),
          ),
        ),
        SizedBox(height: relativeHeight(2)),
        Text(
          artistInfo.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: relativeWidth(4),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

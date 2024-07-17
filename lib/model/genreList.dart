import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soul_healer/model/genreSongs.dart';
import 'package:soul_healer/utilities/genre.dart';

class GenreListScreen extends StatelessWidget {
  final Map<String, List<Color>> genreColorSchemes = {
    'Romantic': [Colors.pinkAccent, Colors.deepPurpleAccent],
    'Dance': [const Color.fromARGB(255, 15, 55, 125), Colors.lightBlueAccent],
    'Sufi': [Colors.amber, Color.fromARGB(255, 227, 49, 0)],
    'Kids': [const Color.fromARGB(255, 48, 68, 25), Colors.green],
    'Classical': [Color.fromARGB(255, 178, 174, 80), Colors.black],
    'Hip Hop': [Color.fromARGB(255, 194, 144, 129), Colors.red],
    'Pop': [
      const Color.fromARGB(255, 1, 169, 152),
      Color.fromARGB(255, 30, 54, 52)
    ],
    'K-pop': [
      Color.fromARGB(255, 179, 1, 255),
      Color.fromARGB(255, 67, 0, 96),
    ],
    'Party': [Colors.yellow, Color.fromARGB(255, 20, 54, 190)],
    'Chill': [
      const Color.fromARGB(255, 204, 208, 227),
      Color.fromARGB(255, 27, 47, 56)
    ],
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double relativeWidth(double percentage) {
      return screenWidth * (percentage / 100);
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.5,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(
        relativeWidth(3),
      ),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        final genreName = genres[index].name;
        final colors =
            genreColorSchemes[genreName] ?? [Colors.grey, Colors.black];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Genresongs(
                  genreName: genreName,
                  gradientColors: colors,
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: relativeWidth(4),
              horizontal: relativeWidth(1),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Center(
              child: Text(
                genreName,
                style: GoogleFonts.cedarvilleCursive(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: relativeWidth(5),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}

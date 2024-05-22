import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext context) {
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
          Text(
            '"Song Page"',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

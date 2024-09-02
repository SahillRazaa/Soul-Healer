import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:soul_healer/screen/common.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const CommonPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    final screenWidth = MediaQuery.of(context).size.width;

    double relativeWidth(double percentage) {
      return screenWidth * (percentage / 100);
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: themeManager.themeData.hintColor,
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 1,
              child: Image.asset(
                "assets/pattern.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logo.png",
                  width: relativeWidth(40),
                  height: relativeWidth(40),
                ),
                Text(
                  'Soul Healer',
                  style: GoogleFonts.montserrat(
                    fontSize: relativeWidth(5),
                    fontWeight: FontWeight.w700,
                    color: themeManager.themeData.primaryColor,
                  ),
                ),
                Text(
                  '"Harmonize your day"',
                  style: GoogleFonts.roboto(
                    fontSize: relativeWidth(2.5),
                    fontWeight: FontWeight.w600,
                    color: themeManager.themeData.scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

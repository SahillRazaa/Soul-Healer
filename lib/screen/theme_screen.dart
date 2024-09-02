import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:soul_healer/utilities/app_theme.dart';

class ThemeListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> themes = [
    {
      'name': 'Coral Teal Theme',
      'themeData': coralTealTheme,
      'hintColor': coralTealTheme.hintColor,
    },
    {
      'name': 'Turquoise Purple Theme',
      'themeData': turquoisePurpleTheme,
      'hintColor': turquoisePurpleTheme.hintColor,
    },
    {
      'name': 'Lavender Orange Theme',
      'themeData': lavenderOrangeTheme,
      'hintColor': lavenderOrangeTheme.hintColor,
    },
    {
      'name': 'Cyan Magenta Theme',
      'themeData': cyanMagentaTheme,
      'hintColor': cyanMagentaTheme.hintColor,
    },
    {
      'name': 'Mint Coral Theme',
      'themeData': mintCoralTheme,
      'hintColor': mintCoralTheme.hintColor,
    },
    {
      'name': 'Indigo Cyan Theme',
      'themeData': indigoCyanTheme,
      'hintColor': indigoCyanTheme.hintColor,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double relativeWidth(double percentage) {
      return screenWidth * (percentage / 100);
    }

    double relativeHeight(double percentage) {
      return screenHeight * (percentage / 100);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Themes',
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
              color: themeManager.themeData.primaryColor,
              fontSize: relativeWidth(5),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: themeManager.themeData.primaryColor,
          size: relativeWidth(7),
        ),
        backgroundColor: themeManager.themeData.hintColor,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final theme = themes[index];
          final isActive = themeManager.themeData == theme['themeData'];

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: theme['hintColor'],
            ),
            title: Text(
              theme['name'],
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: theme['hintColor'],
                  fontSize: relativeWidth(4),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            tileColor: isActive ? Colors.black : Colors.transparent,
            onTap: () {
              themeManager.setTheme(theme['themeData']);
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}

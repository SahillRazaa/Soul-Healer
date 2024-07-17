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
      'scaffoldBackgroundColor': coralTealTheme.scaffoldBackgroundColor,
    },
    {
      'name': 'Turquoise Purple Theme',
      'themeData': turquoisePurpleTheme,
      'scaffoldBackgroundColor': turquoisePurpleTheme.scaffoldBackgroundColor,
    },
    {
      'name': 'Lavender Orange Theme',
      'themeData': lavenderOrangeTheme,
      'scaffoldBackgroundColor': lavenderOrangeTheme.scaffoldBackgroundColor,
    },
    {
      'name': 'Cyan Magenta Theme',
      'themeData': cyanMagentaTheme,
      'scaffoldBackgroundColor': cyanMagentaTheme.scaffoldBackgroundColor,
    },
    {
      'name': 'Peach Turquoise Theme',
      'themeData': peachTurquoiseTheme,
      'scaffoldBackgroundColor': peachTurquoiseTheme.scaffoldBackgroundColor,
    },
    {
      'name': 'Lime Blue Theme',
      'themeData': limeBlueTheme,
      'scaffoldBackgroundColor': limeBlueTheme.scaffoldBackgroundColor,
    },
    {
      'name': 'Mint Coral Theme',
      'themeData': mintCoralTheme,
      'scaffoldBackgroundColor': mintCoralTheme.scaffoldBackgroundColor,
    },
    {
      'name': 'Indigo Cyan Theme',
      'themeData': indigoCyanTheme,
      'scaffoldBackgroundColor': indigoCyanTheme.scaffoldBackgroundColor,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Themes',
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
              color: themeManager.themeData.hintColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: themeManager.themeData.hintColor,
        ),
        backgroundColor: themeManager.themeData.scaffoldBackgroundColor,
      ),
      body: ListView.builder(
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final theme = themes[index];
          final isActive = themeManager.themeData == theme['themeData'];

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: theme['scaffoldBackgroundColor'],
            ),
            title: Text(
              theme['name'],
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: isActive
                      ? Colors.white
                      : theme['scaffoldBackgroundColor'],
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            tileColor: isActive
                ? themeManager.themeData.hintColor
                : Colors.transparent,
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

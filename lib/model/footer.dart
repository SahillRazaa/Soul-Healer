import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soul_healer/providers/app_screen.dart';
import 'package:soul_healer/providers/theme_manager.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  String selectedPage = '/home';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    final appState = Provider.of<AppState>(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double relativeWidth(double percentage) {
      return screenWidth * (percentage / 100);
    }

    double relativeHeight(double percentage) {
      return screenHeight * (percentage / 100);
    }

    Color getIconColor(String page) {
      switch (page) {
        case '/home':
          return selectedPage == page
              ? const Color(0xFF4CAF50)
              : themeManager.themeData.primaryColor;
        case '/search':
          return selectedPage == page
              ? const Color(0xFFFFA726)
              : themeManager.themeData.primaryColor;
        case '/favourite':
          return selectedPage == page
              ? const Color(0xFFE91E63)
              : themeManager.themeData.primaryColor;
        case '/settings':
          return selectedPage == page
              ? const Color(0xFF607D8B)
              : themeManager.themeData.primaryColor;
        default:
          return Colors.black;
      }
    }

    Color getTextColor(String page) {
      switch (page) {
        case '/home':
          return selectedPage == page
              ? const Color(0xFF4CAF50)
              : themeManager.themeData.primaryColor;
        case '/search':
          return selectedPage == page
              ? const Color(0xFFFFA726)
              : themeManager.themeData.primaryColor;
        case '/favourite':
          return selectedPage == page
              ? const Color(0xFFE91E63)
              : themeManager.themeData.primaryColor;
        case '/settings':
          return selectedPage == page
              ? const Color(0xFF607D8B)
              : themeManager.themeData.primaryColor;
        default:
          return Colors.black;
      }
    }

    double getIconSize(String page) {
      return selectedPage == page ? relativeWidth(8) : relativeWidth(7);
    }

    double getTextSize(String page) {
      return selectedPage == page ? relativeWidth(3.3) : relativeWidth(3);
    }

    void onIconPressed(String page) {
      if (mounted) {
        setState(() {
          selectedPage = page;
        });
        appState.setPage(page);
      }
    }

    return Container(
      height: relativeHeight(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeManager.themeData.hintColor,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIconColumn(
              icon: Icons.home,
              label: 'Home',
              page: '/home',
              iconColor: getIconColor('/home'),
              textColor: getTextColor('/home'),
              iconSize: getIconSize('/home'),
              fontSize: getTextSize('/home'),
              onPressed: () => onIconPressed('/home'),
            ),
            _buildIconColumn(
              icon: Icons.search_outlined,
              label: 'Search',
              page: '/search',
              iconColor: getIconColor('/search'),
              textColor: getTextColor('/search'),
              iconSize: getIconSize('/search'),
              fontSize: getTextSize('/search'),
              onPressed: () => onIconPressed('/search'),
            ),
            _buildIconColumn(
              icon: Icons.favorite_rounded,
              label: 'Favourite',
              page: '/favourite',
              iconColor: getIconColor('/favourite'),
              textColor: getTextColor('/favourite'),
              iconSize: getIconSize('/favourite'),
              fontSize: getTextSize('/favourite'),
              onPressed: () => onIconPressed('/favourite'),
            ),
            _buildIconColumn(
              icon: Icons.miscellaneous_services_rounded,
              label: 'Settings',
              page: '/settings',
              iconColor: getIconColor('/settings'),
              textColor: getTextColor('/settings'),
              iconSize: getIconSize('/settings'),
              fontSize: getTextSize('/settings'),
              onPressed: () => onIconPressed('/settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconColumn({
    required IconData icon,
    required String label,
    required String page,
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
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
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

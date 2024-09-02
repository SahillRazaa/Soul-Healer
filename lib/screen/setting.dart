import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/model/custom_setting_container.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:soul_healer/screen/about_us.dart';
import 'package:soul_healer/screen/contact.dart';
import 'package:soul_healer/screen/feedback.dart';

import 'package:soul_healer/screen/privacy_screen.dart';
import 'package:soul_healer/screen/theme_screen.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double relativeWidth(double percentage) {
      return screenWidth * (percentage / 100);
    }

    double relativeHeight(double percentage) {
      return screenHeight * (percentage / 100);
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: themeManager.themeData.scaffoldBackgroundColor,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: relativeHeight(2),
                  ),
                  Image.asset(
                    "assets/logo.png",
                    width: relativeWidth(60),
                    height: relativeHeight(30),
                  ),
                  SizedBox(height: relativeHeight(2)),
                  Text(
                    'Thank you for using this app',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cedarvilleCursive(
                      textStyle: TextStyle(
                        fontSize: relativeWidth(6),
                        color: themeManager.themeData.hintColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(height: relativeHeight(3)),
                  CustomSettingContainer(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThemeListScreen(),
                        ),
                      );
                    },
                    text: 'Themes',
                    icon: Icons.colorize_rounded,
                  ),
                  CustomSettingContainer(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutUsPage(),
                        ),
                      );
                    },
                    text: 'About us',
                    icon: Icons.info_outline_rounded,
                  ),
                  CustomSettingContainer(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactPage(),
                        ),
                      );
                    },
                    text: 'Contact us',
                    icon: Icons.contact_page,
                  ),
                  CustomSettingContainer(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartPage(),
                        ),
                      );
                    },
                    text: 'Give feedbacks',
                    icon: Icons.feedback_rounded,
                  ),
                  CustomSettingContainer(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivacyPolicyPage(),
                        ),
                      );
                    },
                    text: 'Privacy policy',
                    icon: Icons.privacy_tip_outlined,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '© 2024 Your Company. All rights reserved.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: relativeWidth(4),
                          color: themeManager.themeData.hintColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:soul_healer/screen/emailScreen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    void _showLoader(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text("Loading..."),
                ],
              ),
            ),
          );
        },
      );
    }

    Future<void> _launchURL(String name) async {
      String url = '';
      if (name == "Portfolio") {
        url = 'https://sahilraza-me.onrender.com/';
      } else if (name == "Linkedin") {
        url = 'https://www.linkedin.com/in/sahilraza-mern-developer/';
      } else if (name == "Github") {
        url = 'https://github.com/SahillRazaa';
      }

      _showLoader(context);

      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      backgroundColor: themeManager.themeData.hintColor,
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: themeManager.themeData.scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Get in touch with us!',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.primaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(
                Icons.email,
                color: themeManager.themeData.primaryColor,
              ),
              title: Text(
                'Email Us',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: themeManager.themeData.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Emailscreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_box,
                color: themeManager.themeData.primaryColor,
              ),
              title: Text(
                'PortFolio',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: themeManager.themeData.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () {
                _launchURL("Portfolio");
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.linkedin,
                color: themeManager.themeData.primaryColor,
              ),
              title: Text(
                'LinkedIn',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: themeManager.themeData.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () {
                _launchURL("Linkedin");
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.github,
                color: themeManager.themeData.primaryColor,
              ),
              title: Text(
                'GitHub',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: themeManager.themeData.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () {
                _launchURL("Github");
              },
            ),
          ],
        ),
      ),
    );
  }
}

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

      try {
        if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
        } else {
          throw 'Could not launch $url';
        }
      } catch (e) {
        print(e);
      } finally {
        Navigator.of(context).pop();
      }
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double relativeWidth(double percentage) {
      return screenWidth * (percentage / 100);
    }

    double relativeHeight(double percentage) {
      return screenHeight * (percentage / 100);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
              color: themeManager.themeData.primaryColor,
              fontSize: relativeWidth(5),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        backgroundColor: themeManager.themeData.hintColor,
        iconTheme: IconThemeData(
          color: themeManager.themeData.primaryColor,
          size: relativeWidth(7),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: relativeWidth(20),
                      backgroundImage: AssetImage('assets/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: relativeHeight(3),
                  ),
                  Center(
                    child: Text(
                      'Get in Touch!',
                      style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                          color: themeManager.themeData.hintColor,
                          fontSize: relativeWidth(5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: relativeHeight(3),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(relativeWidth(3)),
                    ),
                    elevation: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeManager.themeData.primaryColor
                                .withOpacity(0.9),
                            themeManager.themeData.primaryColor
                                .withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          relativeWidth(3),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.email,
                          color: themeManager.themeData.hintColor,
                        ),
                        title: Text(
                          'Email Us',
                          style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                              color: themeManager.themeData.hintColor,
                              fontSize: relativeWidth(5),
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
                    ),
                  ),
                  SizedBox(
                    height: relativeHeight(2),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        relativeWidth(3),
                      ),
                    ),
                    elevation: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeManager.themeData.primaryColor
                                .withOpacity(0.9),
                            themeManager.themeData.primaryColor
                                .withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          relativeWidth(3),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.account_box,
                          color: themeManager.themeData.hintColor,
                        ),
                        title: Text(
                          'Portfolio',
                          style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                              color: themeManager.themeData.hintColor,
                              fontSize: relativeWidth(5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        onTap: () {
                          _launchURL("Portfolio");
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: relativeHeight(2),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        relativeWidth(3),
                      ),
                    ),
                    elevation: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeManager.themeData.primaryColor
                                .withOpacity(0.9),
                            themeManager.themeData.primaryColor
                                .withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          relativeHeight(1),
                        ),
                      ),
                      child: ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.linkedin,
                          color: themeManager.themeData.hintColor,
                        ),
                        title: Text(
                          'LinkedIn',
                          style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                              color: themeManager.themeData.hintColor,
                              fontSize: relativeWidth(5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        onTap: () {
                          _launchURL("Linkedin");
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: relativeHeight(2),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        relativeWidth(3),
                      ),
                    ),
                    elevation: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeManager.themeData.primaryColor
                                .withOpacity(0.9),
                            themeManager.themeData.primaryColor
                                .withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          relativeWidth(3),
                        ),
                      ),
                      child: ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.github,
                          color: themeManager.themeData.hintColor,
                        ),
                        title: Text(
                          'GitHub',
                          style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                              color: themeManager.themeData.hintColor,
                              fontSize: relativeWidth(5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        onTap: () {
                          _launchURL("Github");
                        },
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

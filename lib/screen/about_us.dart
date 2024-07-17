import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    Future<void> _launchURL() async {
      const url = 'https://sahilraza-me.onrender.com/';
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      backgroundColor: themeManager.themeData.hintColor,
      appBar: AppBar(
        title: Text(
          'About Us',
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
              color: themeManager.themeData.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: themeManager.themeData.primaryColor,
        ),
        backgroundColor: themeManager.themeData.scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Us',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: themeManager.themeData.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Welcome to Soul Healer!',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: themeManager.themeData.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Soul Healer is a unique music app designed to bring you a curated selection of your favorite tunes, all powered by the YouTube API. As a solo project, this app is a labor of love, developed with the aim of providing a simple yet enjoyable music streaming experience.',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: themeManager.themeData.scaffoldBackgroundColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Our Mission',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: themeManager.themeData.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Our mission is to create an easy-to-use music app that allows you to enjoy a selection of handpicked songs. We believe in quality over quantity, which is why we focus on providing a limited but excellent range of music.',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: themeManager.themeData.scaffoldBackgroundColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Why Soul Healer?',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: themeManager.themeData.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '- Curated Selection:',
                      style: TextStyle(
                        color: themeManager.themeData.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' Enjoy a handpicked selection of songs tailored for a superior listening experience.',
                      style: TextStyle(
                        color: themeManager.themeData.scaffoldBackgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '- Seamless Integration:',
                      style: TextStyle(
                        color: themeManager.themeData.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' Powered by the YouTube API, our app ensures smooth and high-quality music streaming.',
                      style: TextStyle(
                        color: themeManager.themeData.scaffoldBackgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '- User-Friendly Interface:',
                      style: TextStyle(
                        color: themeManager.themeData.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' With a clean and intuitive interface, Soul Healer makes it easy for you to find and play your favorite tracks.',
                      style: TextStyle(
                        color: themeManager.themeData.scaffoldBackgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'About the Developer',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: themeManager.themeData.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Hi, I\'m ',
                      style: TextStyle(
                        color: themeManager.themeData.scaffoldBackgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: 'Sahil Raza Ansari',
                      style: TextStyle(
                        color: themeManager.themeData.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: ' the solo developer behind',
                      style: TextStyle(
                        color: themeManager.themeData.scaffoldBackgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: ' Soul Healer.\n\n',
                      style: TextStyle(
                        color: themeManager.themeData.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text:
                          'I am a Full Stack MERN and Flutter developer, currently doing my BTech. This app is a passion project, created to combine my love for music and technology. I am dedicated to continuously improving the app and providing you with the best possible music streaming experience.',
                      style: TextStyle(
                        color: themeManager.themeData.scaffoldBackgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Contact Us',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: themeManager.themeData.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Column(
                children: [
                  Text(
                    'I value your feedback and am always here to help. If you have any questions, suggestions, or just want to say hello, feel free to reach out at my PortFolio.',
                    style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                        color: themeManager.themeData.scaffoldBackgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _launchURL,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeManager.themeData.primaryColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: themeManager.themeData.primaryColor
                                .withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        'Portfolio',
                        style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                            color: themeManager.themeData.hintColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                '\n"Thank you for choosing Soul Healer. Enjoy the music!"',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: themeManager.themeData.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

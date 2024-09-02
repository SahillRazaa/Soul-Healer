import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:flutter/services.dart';

class PrivacyPolicyPage extends StatelessWidget {
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
      backgroundColor: themeManager.themeData.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
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
        ),
        centerTitle: true,
        backgroundColor: themeManager.themeData.hintColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.hintColor,
                  fontSize: relativeWidth(10),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(
              height: relativeHeight(2),
            ),
            Text(
              'Effective Date: 02-08-24\n',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.primaryColor,
                  fontSize: relativeWidth(6),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              'Thank you for choosing to be part of our community at Soul Healer. '
              'We are committed to protecting your personal information and your right to privacy. '
              'If you have any questions or concerns about our policy or our practices with regards to your personal information, '
              'please contact us at our email.\n',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.hintColor,
                  fontSize: relativeWidth(4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '1. Information We Collect\n',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.primaryColor,
                  fontSize: relativeWidth(6),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              'We collect personal information that you voluntarily provide to us when you register on the app, '
              'express an interest in obtaining information about us or our products and services, '
              'when you participate in activities on the app, or otherwise when you contact us.\n',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.hintColor,
                  fontSize: relativeWidth(4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '2. How We Use Your Information\n',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.primaryColor,
                  fontSize: relativeWidth(6),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              'We use personal information collected via the app for a variety of business purposes described below. '
              'We process your personal information for these purposes in reliance on our legitimate business interests, '
              'in order to enter into or perform a contract with you, with your consent, and/or for compliance with our legal obligations.\n',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.hintColor,
                  fontSize: relativeWidth(4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '3. Sharing Your Information\n',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.primaryColor,
                  fontSize: relativeWidth(6),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              'We do not share, sell, rent, or trade your personal information with third parties. '
              'We may share your information with third-party service providers who perform services on our behalf, such as payment processing and data analysis.\n',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.hintColor,
                  fontSize: relativeWidth(4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '4. Security of Your Information\n',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.primaryColor,
                  fontSize: relativeWidth(6),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              'We use administrative, technical, and physical security measures to help protect your personal information. '
              'While we have taken reasonable steps to secure the personal information you provide to us, please be aware that despite our efforts, no security measures are perfect or impenetrable.\n',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.hintColor,
                  fontSize: relativeWidth(2),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '5. Your Privacy Rights\n',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.primaryColor,
                  fontSize: relativeWidth(6),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              'Depending on your location, you may have the following rights regarding your personal information: the right to access, correct, or delete your personal information; '
              'the right to object to or restrict processing of your personal information; and the right to data portability.\n',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.hintColor,
                  fontSize: relativeWidth(4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '6. Changes to This Privacy Policy\n',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.primaryColor,
                  fontSize: relativeWidth(6),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              'We may update this privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on the app. '
              'You are advised to review this privacy policy periodically for any changes.\n',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.hintColor,
                  fontSize: relativeWidth(4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '7. Contact Us\n',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.primaryColor,
                  fontSize: relativeWidth(6),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              'If you have any questions about this Privacy Policy, please contact us at:',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.hintColor,
                  fontSize: relativeWidth(4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              'Email: ',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.primaryColor,
                  fontSize: relativeWidth(6),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'connectwithsahil007@gmail.com',
                    style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                        color: themeManager.themeData.hintColor,
                        fontSize: relativeWidth(4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy),
                  color: themeManager.themeData.hintColor,
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: 'connectwithsahil007@gmail.com'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Email address copied to clipboard!')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

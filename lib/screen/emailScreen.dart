import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Emailscreen extends StatefulWidget {
  const Emailscreen({super.key});

  @override
  State<Emailscreen> createState() => _EmailscreenState();
}

class _EmailscreenState extends State<Emailscreen> {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    final controllerSubject = TextEditingController();
    final controllerMessage = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeManager.themeData.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          color: themeManager.themeData.hintColor,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Email Us",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              color: themeManager.themeData.hintColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: themeManager.themeData.hintColor,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextField(
                      title: "\nSubject",
                      controller: controllerSubject,
                      themeManager: themeManager,
                      hint: "Enter the subject"),
                  const SizedBox(
                    height: 10,
                  ),
                  buildTextField(
                      title: "Message",
                      controller: controllerMessage,
                      maxLines: 8,
                      themeManager: themeManager,
                      hint: "Enter your message"),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (controllerMessage.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Validation Error'),
                              content: Text('Please fill in the message.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          launchEmail(
                            toEmail: "connectwithsahil007@gmail.com",
                            subject: controllerSubject.text,
                            message: controllerMessage.text,
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 25,
                        ),
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
                          'SEND',
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future launchEmail({
    required String toEmail,
    required String subject,
    required String message,
  }) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  Widget buildTextField({
    required String title,
    required TextEditingController controller,
    required ThemeManager themeManager,
    required String hint,
    int maxLines = 1,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 18,
                  color: themeManager.themeData.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: controller,
            cursorColor: themeManager.themeData.scaffoldBackgroundColor,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              filled: true,
              fillColor: themeManager.themeData.primaryColor,
              hintText: maxLines == 8 ? "" : hint,
              hintStyle: TextStyle(
                color: themeManager.themeData.scaffoldBackgroundColor,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: themeManager.themeData.scaffoldBackgroundColor,
                  width: 1.5,
                ),
              ),
              prefixIcon: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: themeManager.themeData.scaffoldBackgroundColor,
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  controller.clear();
                },
                child: Icon(
                  Icons.clear,
                  color: themeManager.themeData.scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
        ],
      );
}

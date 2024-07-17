import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailto/mailto.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    return Scaffold(
      backgroundColor: themeManager.themeData.hintColor,
      appBar: AppBar(
        title: Text(
          'Feedback',
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
              color: themeManager.themeData.hintColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: themeManager.themeData.hintColor,
        ),
        backgroundColor: themeManager.themeData.scaffoldBackgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset('assets/feedback.png'),
            ),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmailInputPage(),
                  ),
                );
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
                      color:
                          themeManager.themeData.primaryColor.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  'Start',
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
      ),
    );
  }
}

class EmailInputPage extends StatefulWidget {
  @override
  _EmailInputPageState createState() => _EmailInputPageState();
}

class _EmailInputPageState extends State<EmailInputPage> {
  final _emailController = TextEditingController();

  void _startFeedback() {
    final email = _emailController.text;
    if (email.isNotEmpty && email.contains('@')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RatingGamePage(email: email)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid Email'),
          content: Text('Please enter a valid email address.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Email Section',
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
              color: themeManager.themeData.hintColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: themeManager.themeData.hintColor,
        ),
        backgroundColor: themeManager.themeData.scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  'assets/email.png',
                  width: 200,
                ),
              ),
              Text(
                'Why your email?',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: themeManager.themeData.hintColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '"We are taking your email to get a feedback mail to us!"',
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: themeManager.themeData.hintColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  labelStyle:
                      TextStyle(color: themeManager.themeData.hintColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  prefixIcon: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: themeManager.themeData.hintColor,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _emailController.clear();
                    },
                    child: Icon(
                      Icons.clear,
                      color: themeManager.themeData.hintColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _startFeedback();
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
                        color:
                            themeManager.themeData.hintColor.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Text(
                    'Next',
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
        ),
      ),
    );
  }
}

class RatingGamePage extends StatefulWidget {
  final String email;

  RatingGamePage({required this.email});

  @override
  _RatingGamePageState createState() => _RatingGamePageState();
}

class _RatingGamePageState extends State<RatingGamePage> {
  final List<Question> _questions = [
    Question(
      text: 'How would you rate the song quality?',
      options: [
        'Very Poor',
        'Poor',
        'Average',
        'Good',
        'Excellent',
      ],
      images: [
        'assets/very_poor.png',
        'assets/poor.png',
        'assets/average.png',
        'assets/good.png',
        'assets/excellent.png',
      ],
    ),
    Question(
      text: 'How likely are you to recommend this app?',
      options: [
        'Very Unlikely',
        'Unlikely',
        'Neutral',
        'Likely',
        'Very Likely',
      ],
      images: [
        'assets/very_poor.png',
        'assets/poor.png',
        'assets/average.png',
        'assets/good.png',
        'assets/excellent.png',
      ],
    ),
  ];

  int _currentQuestionIndex = 0;
  Map<int, String> _answers = {};

  void _submitAnswer(String answer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _showConfirmationDialog();
      }
    });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final themeManager = Provider.of<ThemeManager>(context, listen: true);

        return AlertDialog(
          backgroundColor: themeManager.themeData.primaryColor,
          title: Text(
            'Confirm Feedback',
            style: GoogleFonts.raleway(
              textStyle: TextStyle(
                color: themeManager.themeData.hintColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          content: Text(
            'Are you sure you want to send your feedback?',
            style: GoogleFonts.raleway(
              textStyle: TextStyle(
                color: themeManager.themeData.hintColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          actions: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: themeManager.themeData.primaryColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: themeManager.themeData.hintColor.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      color: themeManager.themeData.hintColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: themeManager.themeData.primaryColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: themeManager.themeData.hintColor.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _sendFeedback();
                },
                child: Text(
                  'Send',
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      color: themeManager.themeData.hintColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _sendFeedback() async {
    final feedbackBody = _answers.entries
        .map((entry) =>
            'Question ${entry.key + 1}: ${_questions[entry.key].text}\nAnswer: ${entry.value}')
        .join('\n\n');

    final mailtoLink = Mailto(
      to: ['connectwithsahil007@gmail.com'],
      cc: [widget.email],
      subject: 'App Feedback',
      body: feedbackBody,
    );

    await launchUrlString('$mailtoLink');
    _showResults();
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (context) {
        final themeManager = Provider.of<ThemeManager>(context, listen: true);

        return AlertDialog(
          backgroundColor: themeManager.themeData.primaryColor,
          title: Text(
            'Thank You!',
            style: GoogleFonts.raleway(
              textStyle: TextStyle(
                color: themeManager.themeData.hintColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your feedback has been submitted. Here are your responses:',
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      color: themeManager.themeData.hintColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ..._answers.entries.map(
                  (entry) => Text(
                    '${_questions[entry.key].text}\nAnswer: ${entry.value}\n',
                    style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                        color: themeManager.themeData.hintColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: themeManager.themeData.primaryColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: themeManager.themeData.hintColor.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.home,
                  color: themeManager.themeData.hintColor,
                ),
                label: Text(
                  'Home',
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      color: themeManager.themeData.hintColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: themeManager.themeData.primaryColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: themeManager.themeData.hintColor.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _currentQuestionIndex = 0;
                    _answers.clear();
                  });
                },
                icon: Icon(
                  Icons.refresh,
                  color: themeManager.themeData.hintColor,
                ),
                label: Text(
                  'Re-Feedback',
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      color: themeManager.themeData.hintColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];

    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    return Scaffold(
      backgroundColor: themeManager.themeData.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Rate Our App',
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
              color: themeManager.themeData.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: themeManager.themeData.primaryColor,
        ),
        backgroundColor: themeManager.themeData.hintColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.text,
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: themeManager.themeData.hintColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: List.generate(question.options.length, (index) {
                return GestureDetector(
                  onTap: () => _submitAnswer(question.options[index]),
                  child: Row(
                    children: [
                      Image.asset(
                        question.images[index],
                        width: 60,
                        height: 60,
                      ),
                      SizedBox(width: 10),
                      Text(
                        question.options[index],
                        style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                            color: themeManager.themeData.hintColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String text;
  final List<String> options;
  final List<String> images;

  Question({
    required this.text,
    required this.options,
    required this.images,
  });
}

class FeedbackFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Form'),
      ),
      body: Center(
        child: Text('Feedback form page content here.'),
      ),
    );
  }
}

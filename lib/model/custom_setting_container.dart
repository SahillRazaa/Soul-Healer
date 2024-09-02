import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/theme_manager.dart';

class CustomSettingContainer extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final IconData icon;

  const CustomSettingContainer({
    Key? key,
    required this.onTap,
    required this.text,
    required this.icon,
  }) : super(key: key);

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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: relativeHeight(0.5)),
        margin: EdgeInsets.symmetric(
            horizontal: relativeWidth(5), vertical: relativeHeight(1)),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: themeManager.themeData.primaryColor,
              blurRadius: relativeHeight(8),
              blurStyle: BlurStyle.inner,
            ),
          ],
          border: Border.symmetric(
            horizontal: BorderSide(
              color: themeManager.themeData.primaryColor,
              width: relativeWidth(0.5),
            ),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(relativeWidth(6)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: themeManager.themeData.primaryColor,
            ),
            SizedBox(width: relativeWidth(1)),
            Text(
              text,
              style: TextStyle(
                color: themeManager.themeData.primaryColor,
                fontSize: relativeWidth(4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

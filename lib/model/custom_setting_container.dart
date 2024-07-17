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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3),
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: themeManager.themeData.primaryColor,
              blurRadius: 80,
              blurStyle: BlurStyle.inner,
            ),
          ],
          border: Border.symmetric(
            horizontal: BorderSide(
              color: themeManager.themeData.primaryColor,
              width: 3,
            ),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: themeManager.themeData.primaryColor,
            ),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: themeManager.themeData.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

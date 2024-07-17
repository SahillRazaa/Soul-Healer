import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/model/your_fav_songs.dart';
import 'package:soul_healer/providers/theme_manager.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: themeManager.themeData.scaffoldBackgroundColor,
            ),
          ),
          FavPageModel(),
        ],
      ),
    );
  }
}

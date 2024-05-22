import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/screen/app_screen.dart';
import 'package:soul_healer/screen/fav.dart';
import 'package:soul_healer/screen/home.dart';
import 'package:soul_healer/screen/search.dart';
import 'package:soul_healer/screen/setting.dart';
import 'package:soul_healer/screen/songs.dart';
import 'package:soul_healer/screen/splash.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(),
        '/home': (context) => const HomePage(),
        '/songs': (context) => const SongPage(),
        '/search': (context) => const SearchPage(),
        '/favourite': (context) => const FavPage(),
        '/settings': (context) => const SettingPage(),
      },
    );
  }
}

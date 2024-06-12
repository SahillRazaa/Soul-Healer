import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/app_screen.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'package:soul_healer/providers/recent_played_provider.dart';
import 'package:soul_healer/providers/search_provider.dart';
import 'package:soul_healer/screen/fav.dart';
import 'package:soul_healer/screen/home.dart';
import 'package:soul_healer/screen/search.dart';
import 'package:soul_healer/screen/setting.dart';
import 'package:soul_healer/screen/splash.dart';
import 'package:soul_healer/providers/audio_player_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => AudioPlayerProvider()),
        ChangeNotifierProvider(create: (context) => CurrentSongProvider()),
        ChangeNotifierProvider(create: (context) => RecentPlayedProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
      ],
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
        '/search': (context) => const SearchPage(),
        '/favourite': (context) => const FavPage(),
        '/settings': (context) => const SettingPage(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/providers/app_screen.dart';
import 'package:soul_healer/providers/audio_player_provider.dart';
import 'package:soul_healer/providers/current_song.dart';
import 'package:soul_healer/providers/fav_song_provider.dart';
import 'package:soul_healer/providers/recent_played_provider.dart';
import 'package:soul_healer/providers/search_provider.dart'; 
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:soul_healer/screen/fav.dart';
import 'package:soul_healer/screen/home.dart';
import 'package:soul_healer/screen/search.dart';
import 'package:soul_healer/screen/setting.dart';
import 'package:soul_healer/screen/splash.dart';
import 'package:soul_healer/utilities/app_theme.dart';
import 'package:soul_healer/utilities/theme_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  final themeStorage = ThemeStorage();
  final savedTheme = await themeStorage.loadTheme() ?? coralTealTheme;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => AudioPlayerProvider()),
        ChangeNotifierProvider(create: (context) => CurrentSongProvider()),
        ChangeNotifierProvider(create: (context) => RecentPlayedProvider()),
        ChangeNotifierProvider(create: (context) => FavSongProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => ThemeManager(savedTheme)),
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
      title: 'Flutter Theme Demo',
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

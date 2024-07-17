import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soul_healer/model/artistList.dart';
import 'package:soul_healer/model/languageList.dart';
import 'package:soul_healer/model/yearly_hits.dart';
import 'package:soul_healer/model/topHits.dart';
import 'package:soul_healer/model/trending_song.dart';
import 'package:soul_healer/providers/theme_manager.dart';
import 'package:soul_healer/utilities/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> trendingSongs = [];
  List<dynamic> tensTwentiesSongs = [];
  List<dynamic> zerostensSongs = [];
  List<dynamic> recentPlayed = [];
  List<dynamic> topHits = [];
  bool isLoading = true;
  String? error;
  bool showMore = false;

  @override
  void initState() {
    super.initState();
    fetchTrendingSongs();
    fetchTopHits();
    fetchTensTwentiesSongs();
    fetchZerosTensSongs();
  }

  Future<void> fetchTrendingSongs() async {
    const apiKey = Constants.YoutubeKey;
    const url = 'https://www.googleapis.com/youtube/v3/videos'
        '?part=snippet'
        '&chart=mostPopular'
        '&maxResults=30'
        '&regionCode=IN'
        '&videoCategoryId=10'
        '&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          trendingSongs = data['items'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          error = 'Failed to load songs: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Error loading songs: $e';
      });
    }
  }

  Future<void> fetchTensTwentiesSongs() async {
    const apiKey = Constants.YoutubeKey;
    const url = 'https://www.googleapis.com/youtube/v3/search'
        '?part=snippet'
        '&maxResults=30'
        '&regionCode=IN'
        '&q=Hindi'
        '&videoCategoryId=10'
        '&publishedBefore=2021-01-01T00:00:00Z'
        '&publishedAfter=2010-01-01T00:00:00Z'
        '&type=video'
        '&order=viewCount'
        '&videoDuration=medium'
        '&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          tensTwentiesSongs = data['items'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          error = 'Failed to load songs: ${response.statusCode}';
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        error = 'Error loading songs: $e';
      });
    }
  }

  Future<void> fetchZerosTensSongs() async {
    const apiKey = Constants.YoutubeKey;
    const url = 'https://www.googleapis.com/youtube/v3/search'
        '?part=snippet'
        '&maxResults=30'
        '&regionCode=IN'
        '&q=Hindi'
        '&videoCategoryId=10'
        '&publishedBefore=2000-01-01T00:00:00Z'
        '&publishedAfter=2009-01-01T00:00:00Z'
        '&type=video'
        '&order=viewCount'
        '&videoDuration=medium'
        '&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          zerostensSongs = data['items'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          error = 'Failed to load songs: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Error loading songs: $e';
      });
    }
  }

  Future<void> fetchTopHits() async {
    const apiKey = Constants.YoutubeKey;
    final currentYear = DateTime.now().year;
    final startDate = '$currentYear-01-01T00:00:00Z';

    final queryParameters = {
      'part': 'snippet',
      'maxResults': '10',
      'regionCode': 'IN',
      'order': 'viewCount',
      'q': 'song',
      'videoCategoryId': '10',
      'publishedAfter': startDate,
      'type': 'video',
      'videoDuration': 'medium',
      'key': apiKey,
    };

    final uri =
        Uri.https('www.googleapis.com', '/youtube/v3/search', queryParameters);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          topHits = data['items'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          error = 'Failed to load top hits: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Error loading top hits: $e';
      });
    }
  }

  String formatTitle(String title) {
    if (title.isEmpty) {
      return 'Unknown Title';
    } else {
      List<String> words = title.split(' ');
      if (words.isEmpty) return title;
      words[0] =
          words[0][0].toUpperCase() + words[0].substring(1).toLowerCase();
      for (int i = 1; i < words.length; i++) {
        words[i] = words[i].toLowerCase();
      }
      return words.join(' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double relativeWidth(double percentage) {
      return screenWidth * (percentage / 100);
    }

    double relativeHeight(double percentage) {
      return screenHeight * (percentage / 100);
    }

    final themeManager = Provider.of<ThemeManager>(context, listen: true);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: themeManager.themeData.scaffoldBackgroundColor,
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
                  ? Center(
                      child: Text(
                        error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(relativeWidth(5)),
                            child: Text(
                              '"Let the music bring you peace and joy"',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cedarvilleCursive(
                                textStyle: TextStyle(
                                  fontSize: relativeWidth(4.9),
                                  color: themeManager.themeData.primaryColor,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          Tophits(
                            topHitsSongs: topHits,
                            formatTitle: formatTitle,
                          ),
                          SizedBox(
                            height: relativeHeight(5),
                          ),
                          TrendingSong(
                            trendingSongs: trendingSongs,
                            showMore: showMore,
                            formatTitle: formatTitle,
                          ),
                          SizedBox(height: relativeHeight(2)),
                          const Artistlist(),
                          SizedBox(height: relativeHeight(3)),
                          YearlyHits(
                            yearlyHits: tensTwentiesSongs,
                            formatTitle: formatTitle,
                            pageTitle: "2010's - 20's Hindi Hits",
                          ),
                          SizedBox(
                            height: relativeHeight(3),
                          ),
                          YearlyHits(
                            yearlyHits: zerostensSongs,
                            formatTitle: formatTitle,
                            pageTitle: "2000's - 10's Hindi Hits",
                          ),
                          SizedBox(
                            height: relativeHeight(3),
                          ),
                          const Languagelist(),
                          SizedBox(
                            height: relativeHeight(3),
                          ),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }
}

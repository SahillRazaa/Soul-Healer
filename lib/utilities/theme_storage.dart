import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:soul_healer/utilities/app_theme.dart';

class ThemeStorage {
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/theme.json';
  }

  Future<ThemeData?> loadTheme() async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = json.decode(content);
        return _decodeThemeData(data);
      }
    } catch (e) {
      print("Error loading theme: $e");
    }
    return null;
  }

  Future<void> saveTheme(ThemeData theme) async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      final data = _encodeThemeData(theme);
      await file.writeAsString(json.encode(data));
    } catch (e) {
      print("Error saving theme: $e");
    }
  }

  Map<String, dynamic> _encodeThemeData(ThemeData theme) {
    if (theme == coralTealTheme) {
      return {'theme': 'coralTealTheme'};
    } else if (theme == turquoisePurpleTheme) {
      return {'theme': 'turquoisePurpleTheme'};
    } else if (theme == lavenderOrangeTheme) {
      return {'theme': 'lavenderOrangeTheme'};
    } else if (theme == cyanMagentaTheme) {
      return {'theme': 'cyanMagentaTheme'};
    } else if (theme == mintCoralTheme) {
      return {'theme': 'mintCoralTheme'};
    } else if (theme == indigoCyanTheme) {
      return {'theme': 'indigoCyanTheme'};
    } else {
      return {'theme': 'custom'};
    }
  }

  ThemeData _decodeThemeData(Map<String, dynamic> data) {
    switch (data['theme']) {
      case 'coralTealTheme':
        return coralTealTheme;
      case 'turquoisePurpleTheme':
        return turquoisePurpleTheme;
      case 'lavenderOrangeTheme':
        return lavenderOrangeTheme;
      case 'cyanMagentaTheme':
        return cyanMagentaTheme;

      case 'mintCoralTheme':
        return mintCoralTheme;
      case 'indigoCyanTheme':
        return indigoCyanTheme;
      default:
        return coralTealTheme;
    }
  }
}

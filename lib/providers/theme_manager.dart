import 'package:flutter/material.dart';
import 'package:soul_healer/utilities/theme_storage.dart';

class ThemeManager extends ChangeNotifier {
  ThemeData _themeData;
  final ThemeStorage _storage = ThemeStorage();

  ThemeManager(this._themeData) {
    _loadTheme();
  }

  ThemeData get themeData => _themeData;

  void setTheme(ThemeData theme) {
    _themeData = theme;
    _storage.saveTheme(theme);
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final theme = await _storage.loadTheme();
    if (theme != null) {
      _themeData = theme;
      notifyListeners();
    }
  }
}

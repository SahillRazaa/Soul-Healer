import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String _currentPage = '/home';

  String get currentPage => _currentPage;

  void setPage(String page) {
    _currentPage = page;
    notifyListeners();
  }
}

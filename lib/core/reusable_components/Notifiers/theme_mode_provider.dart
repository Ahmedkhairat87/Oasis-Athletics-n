import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeProvider extends ChangeNotifier {
  static const _key = 'isDarkMode';
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeModeProvider() {
    _loadTheme();
  }

  /// Toggle and save the theme mode
  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }

  /// Load the saved theme mode
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_key) ?? false;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      if (savedTheme != null) {
        if (savedTheme == 'dark') {
          _themeMode = ThemeMode.dark;
        } else if (savedTheme == 'light') {
          _themeMode = ThemeMode.light;
        } else if (savedTheme == 'system') {
          _themeMode = ThemeMode.system;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
    }
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, _themeMode == ThemeMode.dark ? 'dark' : 'light');
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _themeKey,
        mode == ThemeMode.dark
            ? 'dark'
            : (mode == ThemeMode.light ? 'light' : 'system'),
      );
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }
}

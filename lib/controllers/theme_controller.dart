import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeController() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode')?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode =!_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true, brightness: Brightness.light);
  ThemeData get darkTheme => ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark), useMaterial3: true, brightness: Brightness.dark);
}

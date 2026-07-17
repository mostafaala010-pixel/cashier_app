import 'package:flutter/material.dart';
class ProTheme {
  static const primary = Color(0xFF0F172A);
  static const green = Color(0xFF16A34A);
  static const cardDark = Color(0xFF1E293B);
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: primary,
    colorScheme: const ColorScheme.dark(primary: green, surface: cardDark),
    appBarTheme: const AppBarTheme(backgroundColor: primary, elevation: 0, centerTitle: false, titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
    cardTheme: CardThemeData(color: cardDark, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
  );
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF1F5F9),
    colorScheme: const ColorScheme.light(primary: primary, secondary: green),
    cardTheme: CardThemeData(color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
  );
}


import 'package:flutter/material.dart';
class AppTheme {
  static final dark = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0F172A), centerTitle: true),
    useMaterial3: true,
  );
  static final light = ThemeData.light().copyWith(useMaterial3: true);
}

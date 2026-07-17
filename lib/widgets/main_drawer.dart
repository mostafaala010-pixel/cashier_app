import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  String _language = 'ar';
  String _currency = 'SAR';
  String get language => _language;
  String get currency => _currency;

  SettingsController() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language')?? 'ar';
    _currency = prefs.getString('currency')?? 'SAR';
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    notifyListeners();
  }

  Future<void> setCurrency(String curr) async {
    _currency = curr;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', curr);
    notifyListeners();
  }
}

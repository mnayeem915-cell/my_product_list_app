import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _languageCode = 'en';

  bool get isDarkMode => _isDarkMode;
  String get languageCode => _languageCode;

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _languageCode = prefs.getString('languageCode') ?? 'en';
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  void changeLanguage(String code) async {
    _languageCode = code;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', _languageCode);
  }
}
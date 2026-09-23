import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager extends ChangeNotifier {
  Locale? _locale;
  bool _highContrast = false;
  bool _vibration = true;

  Locale? get locale => _locale;
  bool get highContrast => _highContrast;
  bool get vibration => _vibration;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    final langCode = prefs.getString('languageCode');
    if (langCode != null) {
      _locale = Locale(langCode);
    }
    
    _highContrast = prefs.getBool('highContrast') ?? false;
    _vibration = prefs.getBool('vibration') ?? true;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    notifyListeners();
  }

  Future<void> setHighContrast(bool value) async {
    _highContrast = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('highContrast', value);
    notifyListeners();
  }

  Future<void> setVibration(bool value) async {
    _vibration = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration', value);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:breakout/settings/settings_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsManager Tests', () {
    late SettingsManager manager;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      manager = SettingsManager();
    });

    test('Loads default settings', () async {
      await manager.loadSettings();
      expect(manager.locale, isNull);
      expect(manager.highContrast, false);
      expect(manager.vibration, true);
    });

    test('Persists locale setting', () async {
      await manager.loadSettings();
      await manager.setLocale(const Locale('ar'));
      expect(manager.locale?.languageCode, 'ar');
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('languageCode'), 'ar');
    });

    test('Persists accessibility settings', () async {
      await manager.loadSettings();
      await manager.setHighContrast(true);
      await manager.setVibration(false);
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('highContrast'), true);
      expect(prefs.getBool('vibration'), false);
    });
  });
}

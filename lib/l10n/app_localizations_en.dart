// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Breakout';

  @override
  String get modeClassic => 'Classic Mode';

  @override
  String get modeCampaign => 'Campaign';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get highContrast => 'High Contrast';

  @override
  String get vibration => 'Vibrations';

  @override
  String levelNumber(int level) {
    return 'Level $level';
  }

  @override
  String get difficultyRelax => 'Relax';

  @override
  String get difficultyArcade => 'Arcade';

  @override
  String get difficultyExpert => 'Expert';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Breakout';

  @override
  String get modeClassic => 'Klassischer Modus';

  @override
  String get modeCampaign => 'Kampagne';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get highContrast => 'Hoher Kontrast';

  @override
  String get vibration => 'Vibrationen';

  @override
  String levelNumber(int level) {
    return 'Lev $level';
  }

  @override
  String get difficultyRelax => 'Entspannt';

  @override
  String get difficultyArcade => 'Arcade';

  @override
  String get difficultyExpert => 'Experte';
}

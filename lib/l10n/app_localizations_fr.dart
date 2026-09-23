// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Breakout';

  @override
  String get modeClassic => 'Mode Classique';

  @override
  String get modeCampaign => 'Campagne';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get highContrast => 'Contraste renforcé';

  @override
  String get vibration => 'Vibrations';

  @override
  String levelNumber(int level) {
    return 'Niv $level';
  }

  @override
  String get difficultyRelax => 'Détente';

  @override
  String get difficultyArcade => 'Arcade';

  @override
  String get difficultyExpert => 'Expert';
}

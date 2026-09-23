// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Breakout';

  @override
  String get modeClassic => 'Modo Classico';

  @override
  String get modeCampaign => 'Campagna';

  @override
  String get settings => 'Impostazioni';

  @override
  String get language => 'Lingua';

  @override
  String get highContrast => 'Contrasto Elevato';

  @override
  String get vibration => 'Vibrazioni';

  @override
  String levelNumber(int level) {
    return 'Liv $level';
  }

  @override
  String get difficultyRelax => 'Rilassato';

  @override
  String get difficultyArcade => 'Arcade';

  @override
  String get difficultyExpert => 'Esperto';
}

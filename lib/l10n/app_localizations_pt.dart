// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Breakout';

  @override
  String get modeClassic => 'Modo Clássico';

  @override
  String get modeCampaign => 'Campanha';

  @override
  String get settings => 'Configurações';

  @override
  String get language => 'Idioma';

  @override
  String get highContrast => 'Alto Contraste';

  @override
  String get vibration => 'Vibrações';

  @override
  String levelNumber(int level) {
    return 'Nív $level';
  }

  @override
  String get difficultyRelax => 'Relaxado';

  @override
  String get difficultyArcade => 'Arcade';

  @override
  String get difficultyExpert => 'Especialista';
}

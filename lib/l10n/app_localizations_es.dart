// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Breakout';

  @override
  String get modeClassic => 'Modo Clásico';

  @override
  String get modeCampaign => 'Campaña';

  @override
  String get settings => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get highContrast => 'Alto Contraste';

  @override
  String get vibration => 'Vibraciones';

  @override
  String levelNumber(int level) {
    return 'Niv $level';
  }

  @override
  String get difficultyRelax => 'Relajado';

  @override
  String get difficultyArcade => 'Arcade';

  @override
  String get difficultyExpert => 'Experto';
}

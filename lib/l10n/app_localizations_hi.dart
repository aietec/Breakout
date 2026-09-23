// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Breakout';

  @override
  String get modeClassic => 'क्लासिक मोड';

  @override
  String get modeCampaign => 'अभियान';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get highContrast => 'उच्च कंट्रास्ट';

  @override
  String get vibration => 'कंपन';

  @override
  String levelNumber(int level) {
    return 'स्तर $level';
  }

  @override
  String get difficultyRelax => 'आराम';

  @override
  String get difficultyArcade => 'आर्केड';

  @override
  String get difficultyExpert => 'विशेषज्ञ';
}

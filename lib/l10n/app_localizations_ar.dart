// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Breakout';

  @override
  String get modeClassic => 'الوضع الكلاسيكي';

  @override
  String get modeCampaign => 'حملة';

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get highContrast => 'تباين عالي';

  @override
  String get vibration => 'اهتزاز';

  @override
  String levelNumber(int level) {
    return 'مستوى $level';
  }

  @override
  String get difficultyRelax => 'استرخاء';

  @override
  String get difficultyArcade => 'ممر';

  @override
  String get difficultyExpert => 'خبير';
}

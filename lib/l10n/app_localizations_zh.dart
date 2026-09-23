// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Breakout';

  @override
  String get modeClassic => '经典模式';

  @override
  String get modeCampaign => '活动';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get highContrast => '高对比度';

  @override
  String get vibration => '震动';

  @override
  String levelNumber(int level) {
    return '级别 $level';
  }

  @override
  String get difficultyRelax => '放松';

  @override
  String get difficultyArcade => '街机';

  @override
  String get difficultyExpert => '专家';
}

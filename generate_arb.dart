import 'dart:io';

void main() {
  final dir = Directory('lib/l10n');
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  final languages = {
    'en': {
      'appTitle': 'Breakout',
      'modeClassic': 'Classic Mode',
      'modeCampaign': 'Campaign',
      'settings': 'Settings',
      'language': 'Language',
      'highContrast': 'High Contrast',
      'vibration': 'Vibrations',
      'levelNumber': 'Level {level}',
      '@levelNumber': {
        'placeholders': {'level': {'type': 'int'}}
      },
      'difficultyRelax': 'Relax',
      'difficultyArcade': 'Arcade',
      'difficultyExpert': 'Expert'
    },
    'fr': {
      'appTitle': 'Breakout',
      'modeClassic': 'Mode Classique',
      'modeCampaign': 'Campagne',
      'settings': 'Paramètres',
      'language': 'Langue',
      'highContrast': 'Contraste renforcé',
      'vibration': 'Vibrations',
      'levelNumber': 'Niv {level}',
      'difficultyRelax': 'Détente',
      'difficultyArcade': 'Arcade',
      'difficultyExpert': 'Expert'
    },
    'es': {'appTitle': 'Breakout', 'modeClassic': 'Modo Clásico', 'modeCampaign': 'Campaña', 'settings': 'Ajustes', 'language': 'Idioma', 'highContrast': 'Alto Contraste', 'vibration': 'Vibraciones', 'levelNumber': 'Niv {level}', 'difficultyRelax': 'Relajado', 'difficultyArcade': 'Arcade', 'difficultyExpert': 'Experto'},
    'it': {'appTitle': 'Breakout', 'modeClassic': 'Modo Classico', 'modeCampaign': 'Campagna', 'settings': 'Impostazioni', 'language': 'Lingua', 'highContrast': 'Contrasto Elevato', 'vibration': 'Vibrazioni', 'levelNumber': 'Liv {level}', 'difficultyRelax': 'Rilassato', 'difficultyArcade': 'Arcade', 'difficultyExpert': 'Esperto'},
    'pt': {'appTitle': 'Breakout', 'modeClassic': 'Modo Clássico', 'modeCampaign': 'Campanha', 'settings': 'Configurações', 'language': 'Idioma', 'highContrast': 'Alto Contraste', 'vibration': 'Vibrações', 'levelNumber': 'Nív {level}', 'difficultyRelax': 'Relaxado', 'difficultyArcade': 'Arcade', 'difficultyExpert': 'Especialista'},
    'de': {'appTitle': 'Breakout', 'modeClassic': 'Klassischer Modus', 'modeCampaign': 'Kampagne', 'settings': 'Einstellungen', 'language': 'Sprache', 'highContrast': 'Hoher Kontrast', 'vibration': 'Vibrationen', 'levelNumber': 'Lev {level}', 'difficultyRelax': 'Entspannt', 'difficultyArcade': 'Arcade', 'difficultyExpert': 'Experte'},
    'zh': {'appTitle': 'Breakout', 'modeClassic': '经典模式', 'modeCampaign': '活动', 'settings': '设置', 'language': '语言', 'highContrast': '高对比度', 'vibration': '震动', 'levelNumber': '级别 {level}', 'difficultyRelax': '放松', 'difficultyArcade': '街机', 'difficultyExpert': '专家'},
    'hi': {'appTitle': 'Breakout', 'modeClassic': 'क्लासिक मोड', 'modeCampaign': 'अभियान', 'settings': 'सेटिंग्स', 'language': 'भाषा', 'highContrast': 'उच्च कंट्रास्ट', 'vibration': 'कंपन', 'levelNumber': 'स्तर {level}', 'difficultyRelax': 'आराम', 'difficultyArcade': 'आर्केड', 'difficultyExpert': 'विशेषज्ञ'},
    'ar': {'appTitle': 'Breakout', 'modeClassic': 'الوضع الكلاسيكي', 'modeCampaign': 'حملة', 'settings': 'إعدادات', 'language': 'لغة', 'highContrast': 'تباين عالي', 'vibration': 'اهتزاز', 'levelNumber': 'مستوى {level}', 'difficultyRelax': 'استرخاء', 'difficultyArcade': 'ممر', 'difficultyExpert': 'خبير'},
  };

  for (var entry in languages.entries) {
    String suffix = entry.key == 'zh' ? 'zh_Hans' : entry.key;
    final file = File('${dir.path}/app_$suffix.arb');
    
    // Write JSON with proper quotes formatting
    String content = "{\n";
    var keys = entry.value.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      var k = keys[i];
      var v = entry.value[k];
      content += '  "$k": ';
      if (v is String) {
        content += '"$v"';
      } else {
        // Just for @ placeholders which are Maps
        content += '{"placeholders": {"level": {"type": "int"}}}';
      }
      if (i < keys.length - 1) {
        content += ",\n";
      } else {
        content += "\n";
      }
    }
    content += "}";
    
    file.writeAsStringSync(content);
  }
}

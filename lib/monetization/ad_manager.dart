import 'package:shared_preferences/shared_preferences.dart';

class AdManager {
  static const String _lastAdTimeKey = 'last_ad_time';
  
  // Plafonds
  static const int minLevelsBeforeFirstAd = 3;
  static const int levelsBetweenAds = 3;
  static const int minMinutesBetweenAds = 10;

  int _levelsCompletedSession = 0;

  Future<bool> shouldShowInterstitial() async {
    _levelsCompletedSession++;

    // Plafond 1: Aucune annonce durant les 3 premiers niveaux de la session (ou globalement)
    if (_levelsCompletedSession <= minLevelsBeforeFirstAd) {
      return false;
    }

    // Plafond 2: Au maximum une annonce toutes les 3 fins de niveau
    // Since we wait 3 levels, if (current - 3) % 3 != 0...
    if ((_levelsCompletedSession - minLevelsBeforeFirstAd) % levelsBetweenAds != 0) {
      return false;
    }

    // Plafond 3: Délai minimal de 10 minutes
    final prefs = await SharedPreferences.getInstance();
    final lastAdTimestamp = prefs.getInt(_lastAdTimeKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    final elapsedMinutes = (now - lastAdTimestamp) / (1000 * 60);
    
    if (elapsedMinutes < minMinutesBetweenAds) {
      return false;
    }

    return true;
  }

  Future<void> recordAdShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastAdTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  // In a real app, integrate google_mobile_ads and UMP here.
  // This class provides the logical gatekeeper.
}

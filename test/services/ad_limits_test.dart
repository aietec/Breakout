import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:breakout/monetization/ad_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdManager Ceilings', () {
    late AdManager manager;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      manager = AdManager();
    });

    test('No ads during first 3 levels', () async {
      // simulate 1st level
      expect(await manager.shouldShowInterstitial(), false);
      // 2nd level
      expect(await manager.shouldShowInterstitial(), false);
      // 3rd level
      expect(await manager.shouldShowInterstitial(), false);
    });

    test('Show ad after 4th level if 10 mins passed (simulated)', () async {
      // Mock that last ad was 11 mins ago
      SharedPreferences.setMockInitialValues({
        'last_ad_time': DateTime.now().subtract(const Duration(minutes: 11)).millisecondsSinceEpoch
      });

      manager = AdManager();
      
      // Complete 3 levels
      await manager.shouldShowInterstitial();
      await manager.shouldShowInterstitial();
      await manager.shouldShowInterstitial();
      
      // 4th level should show ad (assuming we also fix the logic for exactly every 3 levels after the first 3)
      // Actually my logic: (levels - 3) % 3 == 0. So 4th level -> (4-3)%3 = 1 -> false!
      // Wait, 4th level should NOT show ad under that logic?
      // "au maximum une annonce toutes les 3 fins de niveau".
      // If we skip first 3, then 4th level is just 1 level after. The next ad should be at level 6.
      
      // Let's test the modulo logic
      expect(await manager.shouldShowInterstitial(), false); // level 4
      expect(await manager.shouldShowInterstitial(), false); // level 5
      expect(await manager.shouldShowInterstitial(), true);  // level 6
    });

    test('Do not show ad if 10 mins have not passed', () async {
      // Mock that last ad was 1 min ago
      SharedPreferences.setMockInitialValues({
        'last_ad_time': DateTime.now().subtract(const Duration(minutes: 1)).millisecondsSinceEpoch
      });

      manager = AdManager();
      
      // Complete 5 levels
      for(int i=0; i<5; i++) {
        await manager.shouldShowInterstitial();
      }
      
      // 6th level would normally show an ad, but time ceiling prevents it
      expect(await manager.shouldShowInterstitial(), false);
    });
  });
}

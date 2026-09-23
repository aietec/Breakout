import 'package:shared_preferences/shared_preferences.dart';

class IAPManager {
  static const String _removeAdsKey = 'has_removed_ads';

  Future<bool> hasRemovedAds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_removeAdsKey) ?? false;
  }

  Future<void> cacheRemoveAdsRight(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_removeAdsKey, value);
  }

  // In a real app, integrate in_app_purchase streams here.
  // We mock the successful purchase flow for the architecture.
  Future<bool> purchaseRemoveAds() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    await cacheRemoveAdsRight(true);
    return true;
  }
}

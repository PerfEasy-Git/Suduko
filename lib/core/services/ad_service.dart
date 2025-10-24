import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdService {
  static bool _isInitialized = false;
  
  // Production Ad Unit IDs
  static String get _homeBannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-6994238600887611/1190297939' // Home Screen Banner
      : 'ca-app-pub-6994238600887611/1190297939';
      
  static String get _gameTopBannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-6994238600887611/7229270282' // Game Screen Top Banner
      : 'ca-app-pub-6994238600887611/7229270282';
      
  static String get _gameBottomBannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-6994238600887611/7396613630' // Game Screen Bottom Banner
      : 'ca-app-pub-6994238600887611/7396613630';
      
  static String get _gameCompleteInterstitialAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-6994238600887611/4700784646' // Game Complete Interstitial
      : 'ca-app-pub-6994238600887611/4700784646';
      
  static String get _levelTransitionInterstitialAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-6994238600887611/2144286951' // Level Transition Interstitial
      : 'ca-app-pub-6994238600887611/2144286951';
      
  static String get _hintRewardedAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-6994238600887611/7037698591' // Hint Rewarded Ad
      : 'ca-app-pub-6994238600887611/7037698591';
      
  static String get _extraLivesRewardedAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-6994238600887611/7205041944' // Extra Lives Rewarded Ad
      : 'ca-app-pub-6994238600887611/7205041944';

  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      debugPrint('🚀 Starting AdMob initialization...');
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('✅ AdMob initialized successfully');
      debugPrint('📱 App ID: ca-app-pub-6994238600887611~3760620953');
      debugPrint('🏠 Home Banner: ca-app-pub-6994238600887611/1190297939');
      debugPrint('🎮 Game Top Banner: ca-app-pub-6994238600887611/7229270282');
      debugPrint('🎮 Game Bottom Banner: ca-app-pub-6994238600887611/7396613630');
      debugPrint('🏆 Game Complete Interstitial: ca-app-pub-6994238600887611/4700784646');
      debugPrint('🔄 Level Transition Interstitial: ca-app-pub-6994238600887611/2144286951');
      debugPrint('💡 Hint Rewarded: ca-app-pub-6994238600887611/7037698591');
      debugPrint('❤️ Extra Lives Rewarded: ca-app-pub-6994238600887611/7205041944');
    } catch (e) {
      debugPrint('❌ Failed to initialize AdMob: $e');
    }
  }

  // Getter methods for all ad unit IDs
  static String get homeBannerAdUnitId => _homeBannerAdUnitId;
  static String get gameTopBannerAdUnitId => _gameTopBannerAdUnitId;
  static String get gameBottomBannerAdUnitId => _gameBottomBannerAdUnitId;
  static String get gameCompleteInterstitialAdUnitId => _gameCompleteInterstitialAdUnitId;
  static String get levelTransitionInterstitialAdUnitId => _levelTransitionInterstitialAdUnitId;
  static String get hintRewardedAdUnitId => _hintRewardedAdUnitId;
  static String get extraLivesRewardedAdUnitId => _extraLivesRewardedAdUnitId;
  
  // Legacy getters for backward compatibility
  static String get bannerAdUnitId => _homeBannerAdUnitId;
  static String get interstitialAdUnitId => _gameCompleteInterstitialAdUnitId;
  static String get rewardedAdUnitId => _hintRewardedAdUnitId;
  
  static bool get isInitialized => _isInitialized;
}

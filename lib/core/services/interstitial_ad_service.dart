import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'ad_service.dart';

class InterstitialAdService {
  static InterstitialAd? _interstitialAd;
  static bool _isLoading = false;
  static int _adCounter = 0;
  static const int _adFrequency = 3; // Show ad every 3 games

  static Future<void> loadInterstitialAd() async {
    if (_isLoading || _interstitialAd != null) return;
    
    _isLoading = true;
    
    try {
      await InterstitialAd.load(
        adUnitId: AdService.gameCompleteInterstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isLoading = false;
            debugPrint('Interstitial ad loaded successfully');
          },
          onAdFailedToLoad: (error) {
            _isLoading = false;
            debugPrint('Interstitial ad failed to load: $error');
          },
        ),
      );
    } catch (e) {
      _isLoading = false;
      debugPrint('Error loading interstitial ad: $e');
    }
  }

  static Future<void> showInterstitialAd() async {
    _adCounter++;
    
    if (_adCounter < _adFrequency) {
      debugPrint('Ad counter: $_adCounter, frequency: $_adFrequency');
      return;
    }
    
    if (_interstitialAd == null) {
      await loadInterstitialAd();
      return;
    }

    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('Interstitial ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _adCounter = 0;
        loadInterstitialAd(); // Load next ad
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        debugPrint('Interstitial ad failed to show: $error');
      },
    );

    await _interstitialAd?.show();
  }

  static void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
  
  static int get adCounter => _adCounter;
  static int get adFrequency => _adFrequency;
}

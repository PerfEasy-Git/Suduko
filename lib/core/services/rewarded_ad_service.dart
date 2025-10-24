import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'ad_service.dart';

class RewardedAdService {
  static RewardedAd? _rewardedAd;
  static bool _isLoading = false;

  static Future<void> loadRewardedAd() async {
    if (_isLoading || _rewardedAd != null) return;
    
    _isLoading = true;
    
    try {
      await RewardedAd.load(
        adUnitId: AdService.hintRewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            _isLoading = false;
            debugPrint('Rewarded ad loaded successfully');
          },
          onAdFailedToLoad: (error) {
            _isLoading = false;
            debugPrint('Rewarded ad failed to load: $error');
          },
        ),
      );
    } catch (e) {
      _isLoading = false;
      debugPrint('Error loading rewarded ad: $e');
    }
  }

  static Future<bool> showRewardedAd() async {
    if (_rewardedAd == null) {
      await loadRewardedAd();
      return false;
    }

    bool rewardEarned = false;

    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('Rewarded ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd(); // Load next ad
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        debugPrint('Rewarded ad failed to show: $error');
      },
    );

    _rewardedAd?.show(
      onUserEarnedReward: (ad, reward) {
        rewardEarned = true;
        debugPrint('User earned reward: ${reward.amount} ${reward.type}');
      },
    );

    return rewardEarned;
  }

  static void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }
}

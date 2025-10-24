import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/services/ad_service.dart';

class BannerAdWidget extends StatefulWidget {
  final double height;
  final EdgeInsets margin;
  final String? adUnitId; // Allow custom ad unit ID
  
  const BannerAdWidget({
    Key? key,
    this.height = 50,
    this.margin = EdgeInsets.zero,
    this.adUnitId,
  }) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: widget.adUnitId ?? AdService.homeBannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
          debugPrint('✅ Banner ad loaded successfully');
          debugPrint('🎯 Ad Unit ID: ${widget.adUnitId ?? AdService.homeBannerAdUnitId}');
          debugPrint('📏 Ad Size: Banner (320x50)');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('❌ Banner ad failed to load: $error');
          debugPrint('🎯 Ad Unit ID: ${widget.adUnitId ?? AdService.homeBannerAdUnitId}');
          debugPrint('🔍 Error Code: ${error.code}');
          debugPrint('📝 Error Message: ${error.message}');
          debugPrint('🌐 Domain: ${error.domain}');
        },
        onAdOpened: (ad) {
          debugPrint('Banner ad opened');
        },
        onAdClosed: (ad) {
          debugPrint('Banner ad closed');
        },
      ),
    );
    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return Container(
        height: widget.height,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Loading ad...',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Container(
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}

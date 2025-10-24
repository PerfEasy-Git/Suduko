# 🔧 Technical Implementation Guide
## Google AdMob Integration for Sudoku App

---

## 📋 **Prerequisites**

### **Required Accounts**
- [ ] Google AdMob account
- [ ] Google Play Console account
- [ ] Firebase project (optional but recommended)

### **Technical Requirements**
- [ ] Flutter SDK 3.24.0+
- [ ] Android SDK 33+
- [ ] Java 17 (already configured)
- [ ] Internet connection for ad serving

---

## 🚀 **Step-by-Step Implementation**

### **Step 1: AdMob Account Setup**

#### **1.1 Create AdMob Account**
1. Go to [AdMob Console](https://apps.admob.com/)
2. Sign in with Google account
3. Accept AdMob terms and conditions
4. Complete account verification

#### **1.2 Register App**
1. Click "Add app" in AdMob console
2. Select "Android" platform
3. Enter app details:
   - **App name**: Sudoku by Perfeasy Games
   - **Package name**: com.storydoku.app
   - **Store URL**: (to be added after Play Store listing)
4. Get your **App ID**: `ca-app-pub-XXXXXXXXXX~XXXXXXXXXX`

#### **1.3 Create Ad Units**
Create the following ad units:

**Banner Ads:**
- Home Screen Banner: `ca-app-pub-XXXXXXXXXX/XXXXXXXXXX`
- Game Screen Banner: `ca-app-pub-XXXXXXXXXX/XXXXXXXXXX`

**Interstitial Ads:**
- Game Complete: `ca-app-pub-XXXXXXXXXX/XXXXXXXXXX`
- Level Transition: `ca-app-pub-XXXXXXXXXX/XXXXXXXXXX`

**Rewarded Ads:**
- Hint Rewarded: `ca-app-pub-XXXXXXXXXX/XXXXXXXXXX`
- Extra Lives: `ca-app-pub-XXXXXXXXXX/XXXXXXXXXX`

**Native Ads:**
- Difficulty Card: `ca-app-pub-XXXXXXXXXX/XXXXXXXXXX`

---

### **Step 2: Flutter Project Configuration**

#### **2.1 Add Dependencies**
Update `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Existing dependencies...
  google_fonts: ^6.3.0
  provider: ^6.0.0
  
  # AdMob integration
  google_mobile_ads: ^3.0.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

#### **2.2 Android Configuration**

**Update `android/app/src/main/AndroidManifest.xml`:**
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.storydoku.app">
    
    <!-- AdMob permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <application
        android:label="Sudoku by Perfeasy"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <!-- AdMob App ID -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-XXXXXXXXXX~XXXXXXXXXX"/>
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:orientation="portrait"
            android:screenOrientation="portrait"
            android:windowSoftInputMode="adjustResize">
            
            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme" />
            
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

#### **2.3 iOS Configuration (if needed)**
Update `ios/Runner/Info.plist`:
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXX~XXXXXXXXXX</string>
```

---

### **Step 3: Ad Service Implementation**

#### **3.1 Create Ad Service**
Create `lib/core/services/ad_service.dart`:
```dart
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdService {
  static bool _isInitialized = false;
  
  // Test Ad Unit IDs (replace with production IDs)
  static const String _bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111' // Test banner
      : 'ca-app-pub-3940256099942544/2934735716';
      
  static const String _interstitialAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712' // Test interstitial
      : 'ca-app-pub-3940256099942544/4411468910';
      
  static const String _rewardedAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917' // Test rewarded
      : 'ca-app-pub-3940256099942544/1712485313';
      
  static const String _nativeAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110' // Test native
      : 'ca-app-pub-3940256099942544/3984884518';

  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('AdMob initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize AdMob: $e');
    }
  }

  static String get bannerAdUnitId => _bannerAdUnitId;
  static String get interstitialAdUnitId => _interstitialAdUnitId;
  static String get rewardedAdUnitId => _rewardedAdUnitId;
  static String get nativeAdUnitId => _nativeAdUnitId;
}
```

#### **3.2 Banner Ad Widget**
Create `lib/shared/widgets/banner_ad_widget.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/services/ad_service.dart';

class BannerAdWidget extends StatefulWidget {
  final double height;
  final EdgeInsets margin;
  
  const BannerAdWidget({
    Key? key,
    this.height = 50,
    this.margin = EdgeInsets.zero,
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
      adUnitId: AdService.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Banner ad failed to load: $error');
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
        child: const Center(
          child: Text('Loading ad...', style: TextStyle(fontSize: 12)),
        ),
      );
    }

    return Container(
      height: widget.height,
      margin: widget.margin,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
```

#### **3.3 Interstitial Ad Service**
Create `lib/core/services/interstitial_ad_service.dart`:
```dart
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
        adUnitId: AdService.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isLoading = false;
            debugPrint('Interstitial ad loaded');
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
}
```

#### **3.4 Rewarded Ad Service**
Create `lib/core/services/rewarded_ad_service.dart`:
```dart
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
        adUnitId: AdService.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            _isLoading = false;
            debugPrint('Rewarded ad loaded');
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
```

---

### **Step 4: UI Integration**

#### **4.1 Update Home Screen**
Modify `lib/features/home/presentation/screens/home_screen.dart`:
```dart
// Add import
import '../../../shared/widgets/banner_ad_widget.dart';

// Add banner ad at the bottom of the screen
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.backgroundSaffronGradient,
            AppTheme.backgroundWarmIvory,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Existing header content...
            
            // Difficulty cards...
            
            // Spacer
            const Spacer(),
            
            // Banner Ad
            const BannerAdWidget(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Made with ❤️ in India by Perfeasy Games',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textGrey,
                    ),
                  ),
                  // Tricolor line...
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
```

#### **4.2 Update Game Screen**
Modify `lib/features/game/presentation/screens/game_screen.dart`:
```dart
// Add imports
import '../../../shared/widgets/banner_ad_widget.dart';
import '../../../core/services/interstitial_ad_service.dart';

// Add banner ads and interstitial logic
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      // Existing app bar content...
    ),
    body: Column(
      children: [
        // Top Banner Ad
        const BannerAdWidget(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        
        // Sudoku grid and controls...
        
        // Bottom Banner Ad
        const BannerAdWidget(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ],
    ),
  );
}

// Add interstitial ad on game completion
void _onGameComplete() {
  // Show interstitial ad
  InterstitialAdService.showInterstitialAd();
  
  // Navigate to next screen or show completion dialog
}
```

#### **4.3 Add Rewarded Ad Features**
Create `lib/features/game/presentation/widgets/hint_button.dart`:
```dart
import 'package:flutter/material.dart';
import '../../../../core/services/rewarded_ad_service.dart';

class HintButton extends StatelessWidget {
  final VoidCallback onHintReceived;
  
  const HintButton({
    Key? key,
    required this.onHintReceived,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showHintAd(context),
      icon: const Icon(Icons.lightbulb_outline),
      label: const Text('Get Hint'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primarySaffron,
        foregroundColor: Colors.white,
      ),
    );
  }

  Future<void> _showHintAd(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Show rewarded ad
    bool rewardEarned = await RewardedAdService.showRewardedAd();
    
    // Hide loading dialog
    Navigator.of(context).pop();

    if (rewardEarned) {
      // Give hint to user
      onHintReceived();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hint received! 🎉'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad not available. Please try again later.'),
          backgroundColor: AppTheme.warningRed,
        ),
      );
    }
  }
}
```

---

### **Step 5: Initialize AdMob**

#### **5.1 Update Main App**
Modify `lib/main.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/ad_service.dart';
import 'core/services/interstitial_ad_service.dart';
import 'core/services/rewarded_ad_service.dart';
import 'features/game/data/sudoku_generator.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'core/theme/app_theme.dart';

class StoryDokuApp extends StatelessWidget {
  const StoryDokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => SudokuGenerator()),
      ],
      child: MaterialApp(
        title: 'Sudoku by Perfeasy Games',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize AdMob
  await AdService.initialize();
  
  // Load initial ads
  await InterstitialAdService.loadInterstitialAd();
  await RewardedAdService.loadRewardedAd();
  
  runApp(const StoryDokuApp());
}
```

---

### **Step 6: Testing**

#### **6.1 Test Ad Units**
Use test ad unit IDs during development:
- Banner: `ca-app-pub-3940256099942544/6300978111`
- Interstitial: `ca-app-pub-3940256099942544/1033173712`
- Rewarded: `ca-app-pub-3940256099942544/5224354917`

#### **6.2 Test on Real Device**
```bash
flutter run --release
```

#### **6.3 Verify Ad Loading**
- Check console logs for ad loading status
- Verify ads display correctly
- Test ad interactions
- Monitor performance impact

---

### **Step 7: Production Deployment**

#### **7.1 Replace Test Ad Units**
Update `lib/core/services/ad_service.dart` with production ad unit IDs:
```dart
static const String _bannerAdUnitId = Platform.isAndroid
    ? 'ca-app-pub-YOUR_APP_ID/YOUR_BANNER_AD_UNIT_ID'
    : 'ca-app-pub-YOUR_APP_ID/YOUR_BANNER_AD_UNIT_ID';
```

#### **7.2 Update App Store Listing**
- Add privacy policy URL
- Update app description to mention ads
- Add screenshots showing ad placement

#### **7.3 Monitor Performance**
- Track ad impressions and clicks
- Monitor user retention
- Optimize ad frequency based on data

---

## 🎯 **Success Checklist**

- [ ] AdMob account created and configured
- [ ] App registered in AdMob console
- [ ] Ad units created for all ad types
- [ ] Flutter dependencies added
- [ ] Android configuration updated
- [ ] Ad services implemented
- [ ] UI integration completed
- [ ] Test ads working
- [ ] Production ad units configured
- [ ] App store listing updated
- [ ] Performance monitoring set up

---

**Document Version**: 1.0  
**Last Updated**: October 24, 2025  
**Prepared by**: AI Assistant  
**For**: Perfeasy Games - Sudoku App AdMob Integration

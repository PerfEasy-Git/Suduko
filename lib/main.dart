import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/game/data/services/sudoku_generator.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'core/services/ad_service.dart';
import 'core/services/interstitial_ad_service.dart';
import 'core/services/rewarded_ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  // Initialize AdMob
  await AdService.initialize();
  
  // Load initial ads
  await InterstitialAdService.loadInterstitialAd();
  await RewardedAdService.loadRewardedAd();
  
  runApp(const StoryDokuApp());
}

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


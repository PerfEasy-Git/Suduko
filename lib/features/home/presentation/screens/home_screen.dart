import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/difficulty.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../game/data/services/sudoku_generator.dart';
import '../../../game/presentation/screens/game_screen.dart';
import '../../../story/presentation/screens/live_action_story_screen.dart';
import '../../../../shared/widgets/banner_ad_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  // Feature flag to hide story mode for v1 launch
  static const bool _showStoryMode = false;

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Header Background Strip
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.backgroundSaffronGradient,
                        Colors.white,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Perfeasy Logo (PE)
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primarySaffron, AppTheme.accentEmerald],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primarySaffron.withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'PE',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // App Title with Hierarchy
                      Text(
                        'SUDOKU',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 36,
                              color: AppTheme.primarySaffron,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'by Perfeasy Games',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.secondaryNavy,
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Proudly Indian',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppTheme.accentEmerald,
                              fontStyle: FontStyle.italic,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Tricolor Line
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    height: 3,
                    width: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.tricolorSaffron,
                          AppTheme.tricolorWhite,
                          AppTheme.tricolorGreen,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Subtitle
                Text(
                  'CHOOSE YOUR CHALLENGE',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.secondaryNavy,
                        letterSpacing: 1,
                      ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 20),
                
                // Mode Selection
                if (_showStoryMode) ...[
                  _buildModeCard(
                    context,
                    title: 'STORY MODE',
                    subtitle: 'Experience the Codebreakers saga',
                    icon: Icons.auto_stories,
                    color: AppTheme.primarySaffron,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LiveActionStoryScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                
                _buildModeCard(
                  context,
                  title: 'CLASSIC SUDOKU',
                  subtitle: 'Pure Sudoku puzzles',
                  icon: Icons.grid_on,
                  color: AppTheme.primarySaffron,
                  onTap: () {
                    _showDifficultySelection(context);
                  },
                ),
                
                // Banner Ad
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: BannerAdWidget(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                
                // Footer with Indian Pride
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Text(
                        'Made with ❤️ in India by Perfeasy Games',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: AppTheme.textGrey,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 2,
                        width: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.tricolorSaffron,
                              AppTheme.tricolorWhite,
                              AppTheme.tricolorGreen,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDifficultySelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'SELECT DIFFICULTY',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primarySaffron,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            for (var difficulty in Difficulty.values) ...[
              _buildDifficultyCard(context, difficulty),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color, width: 1.5),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: color,
                          letterSpacing: 1.5,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyCard(BuildContext context, Difficulty difficulty) {
    Color cardColor;
    Color borderColor;
    IconData icon;
    String description;
    
    switch (difficulty) {
      case Difficulty.easy:
        cardColor = AppTheme.easyBackground;
        borderColor = AppTheme.easyGreen;
        icon = Icons.check_circle_outline;
        description = 'Perfect for beginners';
        break;
      case Difficulty.medium:
        cardColor = AppTheme.mediumBackground;
        borderColor = AppTheme.mediumSaffron;
        icon = Icons.star_outline;
        description = 'Balanced challenge';
        break;
      case Difficulty.hard:
        cardColor = AppTheme.hardBackground;
        borderColor = AppTheme.hardBlue;
        icon = Icons.diamond_outlined;
        description = 'For experienced players';
        break;
      case Difficulty.expert:
        cardColor = AppTheme.expertBackground;
        borderColor = AppTheme.expertRed;
        icon = Icons.emoji_events_outlined;
        description = 'Master level difficulty';
        break;
    }

    return GestureDetector(
      onTap: () {
        final generator = Provider.of<SudokuGenerator>(context, listen: false);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GameScreen(
              difficulty: difficulty,
              generator: generator,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor.withOpacity(0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: borderColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: borderColor,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    difficulty.displayName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: borderColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${difficulty.minClues}-${difficulty.maxClues} clues',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: borderColor,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: borderColor,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


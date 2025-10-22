import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/difficulty.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../game/data/services/sudoku_generator.dart';
import '../../../game/presentation/screens/game_screen.dart';
import '../../../story/presentation/screens/live_action_story_screen.dart';

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
              AppTheme.backgroundDark,
              AppTheme.surfaceDark.withOpacity(0.5),
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
                
                // App Logo/Title
                Text(
                  'STORYDOKU',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 36,
                        color: AppTheme.primaryCyan,
                      ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  'CODE BREAKERS',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        letterSpacing: 4,
                        color: AppTheme.primaryPurple,
                      ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 30),
                
                // Subtitle
                Text(
                  'CHOOSE YOUR CHALLENGE',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryCyan,
                        letterSpacing: 2,
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
                    color: AppTheme.primaryPurple,
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
                  color: AppTheme.primaryCyan,
                  onTap: () {
                    _showDifficultySelection(context);
                  },
                ),
                
                // Footer
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Master the grid. Challenge your mind.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppTheme.primaryCyan.withOpacity(0.6),
                        ),
                    textAlign: TextAlign.center,
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
      backgroundColor: AppTheme.surfaceDark,
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
                    color: AppTheme.primaryCyan,
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
          color: AppTheme.surfaceDark,
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
    Color borderColor;
    switch (difficulty) {
      case Difficulty.easy:
        borderColor = AppTheme.accentGreen;
        break;
      case Difficulty.medium:
        borderColor = AppTheme.primaryCyan;
        break;
      case Difficulty.hard:
        borderColor = AppTheme.primaryPurple;
        break;
      case Difficulty.expert:
        borderColor = AppTheme.warningRed;
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: Center(
                child: Text(
                  difficulty.name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: borderColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    difficulty.displayName.toUpperCase(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: borderColor,
                          letterSpacing: 1.5,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    difficulty.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: borderColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}


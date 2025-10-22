import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/difficulty.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/storage_service.dart';
import '../../../../core/services/voice_service.dart';
import '../../domain/entities/story_scene.dart';
import '../../data/models/sample_story.dart';
import '../widgets/visual_story_scene.dart';
import '../../../game/data/services/sudoku_generator.dart';
import '../../../game/presentation/screens/game_screen.dart';

class VisualStoryViewerScreen extends StatefulWidget {
  const VisualStoryViewerScreen({super.key});

  @override
  State<VisualStoryViewerScreen> createState() => _VisualStoryViewerScreenState();
}

class _VisualStoryViewerScreenState extends State<VisualStoryViewerScreen>
    with TickerProviderStateMixin {
  late Chapter chapter;
  int currentSceneIndex = 0;
  int currentDialogueIndex = 0;
  bool showContinueButton = false;
  
  // Visual story controllers
  late AnimationController _sceneTransitionController;
  late AnimationController _characterController;
  late AnimationController _dialogueController;
  
  // Visual story animations
  late Animation<double> _sceneTransitionAnimation;
  late Animation<double> _characterAnimation;
  late Animation<double> _dialogueAnimation;

  @override
  void initState() {
    super.initState();
    chapter = SampleStory.getChapter1();
    _initializeVisualStorySystem();
    _loadStoryProgress();
  }

  void _initializeVisualStorySystem() {
    _sceneTransitionController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _characterController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _dialogueController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _sceneTransitionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sceneTransitionController,
      curve: Curves.easeInOut,
    ));

    _characterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _characterController,
      curve: Curves.elasticOut,
    ));

    _dialogueAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dialogueController,
      curve: Curves.easeInOut,
    ));

    _sceneTransitionController.forward();
    _characterController.forward();
    _dialogueController.forward();
  }

  @override
  void dispose() {
    _sceneTransitionController.dispose();
    _characterController.dispose();
    _dialogueController.dispose();
    super.dispose();
  }

  Future<void> _loadStoryProgress() async {
    final progress = StorageService.getStoryProgress();
    if (progress != null) {
      setState(() {
        currentSceneIndex = progress['sceneIndex'] ?? 0;
        currentDialogueIndex = progress['dialogueIndex'] ?? 0;
        showContinueButton = progress['showContinueButton'] ?? false;
      });
    }
    await VoiceService.init();
  }

  Future<void> _saveStoryProgress() async {
    await StorageService.saveStoryProgress({
      'sceneIndex': currentSceneIndex,
      'dialogueIndex': currentDialogueIndex,
      'showContinueButton': showContinueButton,
    });
  }

  StoryScene get currentScene => chapter.scenes[currentSceneIndex];

  void _nextDialogue() {
    setState(() {
      if (currentDialogueIndex < currentScene.dialogues.length - 1) {
        currentDialogueIndex++;
        showContinueButton = false;
        
        // Save progress
        _saveStoryProgress();
        
        // Trigger new dialogue animation
        _dialogueController.reset();
        _dialogueController.forward();
        
        // Show continue button after last dialogue
        if (currentDialogueIndex == currentScene.dialogues.length - 1) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              setState(() {
                showContinueButton = true;
              });
              _saveStoryProgress();
            }
          });
        }
      }
    });
  }

  void _nextScene() {
    if (currentScene.requiresPuzzleCompletion) {
      _startPuzzle();
      return;
    }

    if (currentSceneIndex < chapter.scenes.length - 1) {
      setState(() {
        currentSceneIndex++;
        currentDialogueIndex = 0;
        showContinueButton = false;
      });
      _saveStoryProgress();
      
      // Visual story scene transition
      _sceneTransitionController.reset();
      _sceneTransitionController.forward();
      
      _characterController.reset();
      _characterController.forward();
    } else {
      _showChapterComplete();
    }
  }

  void _startPuzzle() {
    final generator = Provider.of<SudokuGenerator>(context, listen: false);
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameScreen(
          difficulty: Difficulty.easy,
          generator: generator,
        ),
      ),
    ).then((_) {
      // When returning from puzzle, show completion scene
      if (currentSceneIndex < chapter.scenes.length - 1) {
        setState(() {
          currentSceneIndex++;
          currentDialogueIndex = 0;
          showContinueButton = false;
        });
        _saveStoryProgress();
        
        // Visual story return
        _sceneTransitionController.reset();
        _sceneTransitionController.forward();
        
        _characterController.reset();
        _characterController.forward();
      }
    });
  }

  void _showChapterComplete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'CHAPTER COMPLETE',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.accentGreen,
                letterSpacing: 2,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [AppTheme.accentGreen, AppTheme.primaryCyan],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentGreen.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'You\'ve completed the visual story demo of Chapter 1: "${chapter.title}"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'More visual chapters coming soon...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryCyan,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryCyan,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('HOME'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDialogue = currentScene.dialogues[currentDialogueIndex];
    
    return Scaffold(
      body: Stack(
        children: [
          // Visual Story Scene
          Positioned.fill(
            child: VisualStoryScene(
              sceneType: currentScene.title.toLowerCase(),
              character1: _getPrimaryCharacter(),
              character2: _getSecondaryCharacter(),
              dialogue: currentDialogue.text,
              onTap: _nextDialogue,
              isActive: true,
            ),
          ),
          
          // Visual Story UI Overlay
          _buildVisualStoryUI(),
        ],
      ),
    );
  }

  String _getPrimaryCharacter() {
    switch (currentScene.title.toLowerCase()) {
      case 'awakening':
        return 'You';
      case 'first fragment':
        return 'ECHO';
      case 'fragment restored':
        return 'ECHO';
      case 'first memory':
        return 'Narrator';
      default:
        return 'You';
    }
  }

  String _getSecondaryCharacter() {
    switch (currentScene.title.toLowerCase()) {
      case 'awakening':
        return 'ECHO';
      case 'first fragment':
        return 'You';
      case 'fragment restored':
        return 'You';
      case 'first memory':
        return '';
      default:
        return 'ECHO';
    }
  }

  Widget _buildVisualStoryUI() {
    return SafeArea(
      child: Column(
        children: [
          // Visual Story Header
          _buildVisualStoryHeader(),
          
          // Visual Story Progress
          _buildVisualStoryProgress(),
          
          const Spacer(),
          
          // Visual Story Continue Button
          if (showContinueButton)
            _buildVisualStoryContinueButton(),
        ],
      ),
    );
  }

  Widget _buildVisualStoryHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Visual Story back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryCyan.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryCyan, width: 1),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppTheme.primaryCyan,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapter.title.toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryCyan,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  currentScene.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        letterSpacing: 1,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualStoryProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 6,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(3),
        ),
        child: AnimatedBuilder(
          animation: _sceneTransitionAnimation,
          builder: (context, child) {
            return Container(
              width: MediaQuery.of(context).size.width * 
                     ((currentSceneIndex + 1) / chapter.scenes.length) * 
                     _sceneTransitionAnimation.value,
              height: 6,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryCyan, AppTheme.primaryPurple],
                ),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryCyan.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVisualStoryContinueButton() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GestureDetector(
        onTap: _nextScene,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryCyan, AppTheme.primaryPurple],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryCyan.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Text(
            currentScene.requiresPuzzleCompletion
                ? 'START PUZZLE'
                : 'CONTINUE',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

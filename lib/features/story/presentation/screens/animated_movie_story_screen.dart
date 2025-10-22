import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/difficulty.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/storage_service.dart';
import '../../../../core/services/voice_service.dart';
import '../../../../core/services/animated_movie_service.dart';
import '../../domain/entities/story_scene.dart';
import '../../data/models/sample_story.dart';
import '../widgets/character_dialogue_box.dart';
import '../../../game/data/services/sudoku_generator.dart';
import '../../../game/presentation/screens/game_screen.dart';

class AnimatedMovieStoryScreen extends StatefulWidget {
  const AnimatedMovieStoryScreen({super.key});

  @override
  State<AnimatedMovieStoryScreen> createState() => _AnimatedMovieStoryScreenState();
}

class _AnimatedMovieStoryScreenState extends State<AnimatedMovieStoryScreen>
    with TickerProviderStateMixin {
  late Chapter chapter;
  int currentSceneIndex = 0;
  int currentDialogueIndex = 0;
  bool showContinueButton = false;
  late ScrollController _scrollController;
  
  // Animated movie controllers
  late AnimationController _characterController;
  late AnimationController _environmentController;
  late AnimationController _transitionController;
  late AnimationController _sceneController;
  
  // Animated movie animations
  late Animation<double> _characterAnimation;
  late Animation<double> _environmentAnimation;
  late Animation<double> _transitionAnimation;
  late Animation<double> _sceneAnimation;
  
  // Animated movie state
  CharacterAnimation _currentCharacterAnimation = const CharacterAnimation(
    type: CharacterAnimationType.idle,
    intensity: 1.0,
    duration: Duration(seconds: 2),
  );
  SceneEnvironment _currentEnvironment = const SceneEnvironment(
    type: SceneEnvironmentType.space,
    colors: [AppTheme.primaryCyan, AppTheme.primaryPurple],
    intensity: 1.0,
  );
  bool _isCharacterSpeaking = false;

  @override
  void initState() {
    super.initState();
    chapter = SampleStory.getChapter1();
    _scrollController = ScrollController();
    _initializeAnimatedMovieSystem();
    _loadStoryProgress();
  }

  void _initializeAnimatedMovieSystem() {
    _characterController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _environmentController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _sceneController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _characterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _characterController,
      curve: Curves.easeInOut,
    ));

    _environmentAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _environmentController,
      curve: Curves.linear,
    ));

    _transitionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    ));

    _sceneAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sceneController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _characterController.dispose();
    _environmentController.dispose();
    _transitionController.dispose();
    _sceneController.dispose();
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

  void _updateAnimatedMovieMood() {
    // Update animated movie elements based on scene
    switch (currentScene.title.toLowerCase()) {
      case 'awakening':
        _currentEnvironment = const SceneEnvironment(
          type: SceneEnvironmentType.space,
          colors: [AppTheme.primaryCyan, AppTheme.primaryPurple],
          intensity: 1.0,
        );
        _currentCharacterAnimation = const CharacterAnimation(
          type: CharacterAnimationType.entrance,
          intensity: 0.8,
          duration: Duration(seconds: 3),
        );
        break;
      case 'first fragment':
        _currentEnvironment = const SceneEnvironment(
          type: SceneEnvironmentType.puzzle,
          colors: [AppTheme.primaryPurple, AppTheme.warningRed],
          intensity: 1.2,
        );
        _currentCharacterAnimation = const CharacterAnimation(
          type: CharacterAnimationType.gesturing,
          intensity: 1.0,
          duration: Duration(seconds: 2),
        );
        break;
      case 'fragment restored':
        _currentEnvironment = const SceneEnvironment(
          type: SceneEnvironmentType.nexus,
          colors: [AppTheme.accentGreen, AppTheme.primaryCyan],
          intensity: 0.8,
        );
        _currentCharacterAnimation = const CharacterAnimation(
          type: CharacterAnimationType.emotional,
          intensity: 1.2,
          duration: Duration(seconds: 2),
        );
        break;
      case 'first memory':
        _currentEnvironment = const SceneEnvironment(
          type: SceneEnvironmentType.memory,
          colors: [AppTheme.primaryPurple, AppTheme.primaryCyan],
          intensity: 1.5,
        );
        _currentCharacterAnimation = const CharacterAnimation(
          type: CharacterAnimationType.speaking,
          intensity: 0.6,
          duration: Duration(seconds: 4),
        );
        break;
    }
  }

  void _onCharacterSpeak() {
    setState(() {
      _isCharacterSpeaking = true;
    });
    
    // Trigger speaking animation
    _characterController.reset();
    _characterController.forward();
    
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _isCharacterSpeaking = false;
        });
      }
    });
  }

  void _nextDialogue() {
    _onCharacterSpeak();
    setState(() {
      if (currentDialogueIndex < currentScene.dialogues.length - 1) {
        currentDialogueIndex++;
        showContinueButton = false;
        
        // Save progress
        _saveStoryProgress();
        
        // Auto-scroll to bottom when new dialogue appears
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && _scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
            );
          }
        });
        
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
      _updateAnimatedMovieMood();
      _saveStoryProgress();
      
      // Animated movie scene transition
      _transitionController.reset();
      _transitionController.forward();
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
        _updateAnimatedMovieMood();
        _saveStoryProgress();
        
        // Animated movie return
        _transitionController.reset();
        _transitionController.forward();
        
        // Auto-scroll to show the completion dialogue
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted && _scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
            );
          }
        });
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
              'You\'ve completed the animated movie demo of Chapter 1: "${chapter.title}"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'More animated chapters coming soon...',
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
    final visibleDialogues = currentScene.dialogues
        .take(currentDialogueIndex + 1)
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          // Animated movie background environment
          AnimatedMovieService.createAnimatedScene(
            child: Container(),
            environment: _currentEnvironment,
            controller: _environmentController,
          ),
          
          // Main animated movie content - FIXED: Show content directly
          _buildMainContent(visibleDialogues),
          
          // Animated movie transitions
          AnimatedMovieService.createAnimatedTransition(
            child: Container(),
            transition: const TransitionAnimation(
              type: TransitionAnimationType.dissolve,
              duration: Duration(milliseconds: 2000),
            ),
            controller: _transitionController,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(List<Dialogue> visibleDialogues) {
    return SafeArea(
      child: Column(
        children: [
          // Animated movie header
          _buildAnimatedMovieHeader(),
          
          // Animated movie progress indicator
          _buildAnimatedMovieProgress(),
          
          const SizedBox(height: 20),
          
          // Animated movie dialogues - FIXED: Show dialogues directly
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 120),
              itemCount: visibleDialogues.length,
              itemBuilder: (context, index) {
                return CharacterDialogueBox(
                  dialogue: visibleDialogues[index],
                  onTap: index == visibleDialogues.length - 1
                      ? _nextDialogue
                      : null,
                  isActive: index == visibleDialogues.length - 1,
                );
              },
            ),
          ),
          
          // Animated movie continue button
          if (showContinueButton)
            _buildAnimatedMovieContinueButton(),
        ],
      ),
    );
  }

  Widget _buildAnimatedMovieHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Animated movie back button - FIXED: Show button directly
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

  Widget _buildAnimatedMovieProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 6,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(3),
        ),
        child: AnimatedBuilder(
          animation: _sceneAnimation,
          builder: (context, child) {
            return Container(
              width: MediaQuery.of(context).size.width * 
                     ((currentSceneIndex + 1) / chapter.scenes.length) * 
                     _sceneAnimation.value,
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

  Widget _buildAnimatedMovieContinueButton() {
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

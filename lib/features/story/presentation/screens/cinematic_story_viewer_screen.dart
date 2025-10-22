import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/difficulty.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/storage_service.dart';
import '../../../../core/services/voice_service.dart';
import '../../../../core/services/cinematic_service.dart';
import '../../../../core/services/visual_service.dart';
import '../../../../core/services/interactive_visual_service.dart';
import '../../domain/entities/story_scene.dart';
import '../../data/models/sample_story.dart';
import '../widgets/character_dialogue_box.dart';
import '../../../game/data/services/sudoku_generator.dart';
import '../../../game/presentation/screens/game_screen.dart';

class CinematicStoryViewerScreen extends StatefulWidget {
  const CinematicStoryViewerScreen({super.key});

  @override
  State<CinematicStoryViewerScreen> createState() => _CinematicStoryViewerScreenState();
}

class _CinematicStoryViewerScreenState extends State<CinematicStoryViewerScreen>
    with TickerProviderStateMixin {
  late Chapter chapter;
  int currentSceneIndex = 0;
  int currentDialogueIndex = 0;
  bool showContinueButton = false;
  late ScrollController _scrollController;
  
  // Cinematic controllers
  late AnimationController _sceneTransitionController;
  late AnimationController _cameraController;
  late AnimationController _lightingController;
  late AnimationController _atmosphereController;
  
  // Cinematic animations
  late Animation<double> _sceneTransitionAnimation;
  late Animation<double> _cameraAnimation;
  late Animation<double> _lightingAnimation;
  late Animation<double> _atmosphereAnimation;
  
  // Cinematic state
  CameraMovement _currentCameraMovement = const CameraMovement(
    type: CameraType.zoomIn,
    intensity: 0.1,
    duration: Duration(seconds: 2),
  );
  SceneComposition _currentComposition = const SceneComposition(
    mood: SceneMood.mysterious,
    framing: SceneFraming.wideShot,
    accentColors: [AppTheme.primaryCyan, AppTheme.primaryPurple],
  );
  bool _isInteracting = false;

  @override
  void initState() {
    super.initState();
    chapter = SampleStory.getChapter1();
    _scrollController = ScrollController();
    _initializeCinematicSystem();
    _loadStoryProgress();
  }

  void _initializeCinematicSystem() {
    _sceneTransitionController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _cameraController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _lightingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _atmosphereController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _sceneTransitionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sceneTransitionController,
      curve: Curves.easeInOut,
    ));

    _cameraAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cameraController,
      curve: Curves.easeInOut,
    ));

    _lightingAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _lightingController,
      curve: Curves.easeInOut,
    ));

    _atmosphereAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _atmosphereController,
      curve: Curves.linear,
    ));

    _sceneTransitionController.forward();
    _cameraController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _sceneTransitionController.dispose();
    _cameraController.dispose();
    _lightingController.dispose();
    _atmosphereController.dispose();
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

  void _updateCinematicMood() {
    // Update cinematic elements based on scene
    switch (currentScene.title.toLowerCase()) {
      case 'awakening':
        _currentComposition = const SceneComposition(
          mood: SceneMood.mysterious,
          framing: SceneFraming.wideShot,
          accentColors: [AppTheme.primaryCyan, AppTheme.primaryPurple],
        );
        _currentCameraMovement = const CameraMovement(
          type: CameraType.dollyIn,
          intensity: 0.2,
          duration: Duration(seconds: 3),
        );
        break;
      case 'first fragment':
        _currentComposition = const SceneComposition(
          mood: SceneMood.tension,
          framing: SceneFraming.closeUp,
          accentColors: [AppTheme.primaryPurple, AppTheme.warningRed],
        );
        _currentCameraMovement = const CameraMovement(
          type: CameraType.zoomIn,
          intensity: 0.3,
          duration: Duration(seconds: 2),
        );
        break;
      case 'fragment restored':
        _currentComposition = const SceneComposition(
          mood: SceneMood.hopeful,
          framing: SceneFraming.wideShot,
          accentColors: [AppTheme.accentGreen, AppTheme.primaryCyan],
        );
        _currentCameraMovement = const CameraMovement(
          type: CameraType.zoomOut,
          intensity: 0.2,
          duration: Duration(seconds: 2),
        );
        break;
      case 'first memory':
        _currentComposition = const SceneComposition(
          mood: SceneMood.dramatic,
          framing: SceneFraming.extremeCloseUp,
          accentColors: [AppTheme.primaryPurple, AppTheme.primaryCyan],
        );
        _currentCameraMovement = const CameraMovement(
          type: CameraType.orbit,
          intensity: 0.1,
          duration: Duration(seconds: 4),
        );
        break;
    }
  }

  void _onInteraction() {
    setState(() {
      _isInteracting = true;
    });
    
    // Trigger cinematic interaction
    _cameraController.reset();
    _cameraController.forward();
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isInteracting = false;
        });
      }
    });
  }

  void _nextDialogue() {
    _onInteraction();
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
      _updateCinematicMood();
      _saveStoryProgress();
      
      // Cinematic scene transition
      _sceneTransitionController.reset();
      _sceneTransitionController.forward();
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
        _updateCinematicMood();
        _saveStoryProgress();
        
        // Cinematic return
        _sceneTransitionController.reset();
        _sceneTransitionController.forward();
        
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
              'You\'ve completed the demo of Chapter 1: "${chapter.title}"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'More chapters coming soon...',
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
          // Cinematic background with composition
          CinematicService.createSceneComposition(
            child: Container(),
            composition: _currentComposition,
          ),
          
          // Interactive particle effects
          InteractiveVisualService.createInteractiveParticles(
            onTap: _onInteraction,
            effectType: currentScene.title.toLowerCase(),
          ),
          
          // Main cinematic content
          CinematicService.createCinematicCamera(
            child: _buildMainContent(visibleDialogues),
            movement: _currentCameraMovement,
            controller: _cameraController,
          ),
          
          // Cinematic lighting overlay
          _buildCinematicLighting(),
          
          // Atmosphere effects
          _buildAtmosphereEffects(),
        ],
      ),
    );
  }

  Widget _buildMainContent(List<Dialogue> visibleDialogues) {
    return CinematicService.createTransition(
      child: SafeArea(
        child: Column(
          children: [
            // Cinematic header
            _buildCinematicHeader(),
            
            // Cinematic progress indicator
            _buildCinematicProgress(),
            
            const SizedBox(height: 20),
            
            // Cinematic dialogues
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 120),
                itemCount: visibleDialogues.length,
                itemBuilder: (context, index) {
                  return CinematicService.createTransition(
                    child: CharacterDialogueBox(
                      dialogue: visibleDialogues[index],
                      onTap: index == visibleDialogues.length - 1
                          ? _nextDialogue
                          : null,
                      isActive: index == visibleDialogues.length - 1,
                    ),
                    type: TransitionType.fadeIn,
                    controller: _sceneTransitionController,
                  );
                },
              ),
            ),
            
            // Cinematic continue button
            if (showContinueButton)
              _buildCinematicContinueButton(),
          ],
        ),
      ),
      type: TransitionType.fadeIn,
      controller: _sceneTransitionController,
    );
  }

  Widget _buildCinematicHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Cinematic back button
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

  Widget _buildCinematicProgress() {
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

  Widget _buildCinematicContinueButton() {
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

  Widget _buildCinematicLighting() {
    return AnimatedBuilder(
      animation: _lightingAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.0,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3 * _lightingAnimation.value),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAtmosphereEffects() {
    return AnimatedBuilder(
      animation: _atmosphereAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: CinematicAtmospherePainter(
            _atmosphereAnimation.value,
            _currentComposition,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class CinematicAtmospherePainter extends CustomPainter {
  final double animationValue;
  final SceneComposition composition;

  CinematicAtmospherePainter(this.animationValue, this.composition);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final random = math.Random(42);
    
    // Create atmospheric particles based on scene mood
    for (int i = 0; i < 80; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3 + 1;
      final opacity = (random.nextDouble() * 0.6 + 0.2) * animationValue;
      
      paint.color = composition.accentColors[
        random.nextInt(composition.accentColors.length)
      ].withOpacity(opacity);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Add mood-specific effects
    switch (composition.mood) {
      case SceneMood.mysterious:
        _drawMysteriousEffects(canvas, size);
        break;
      case SceneMood.dramatic:
        _drawDramaticEffects(canvas, size);
        break;
      case SceneMood.hopeful:
        _drawHopefulEffects(canvas, size);
        break;
      case SceneMood.tension:
        _drawTensionEffects(canvas, size);
        break;
      default:
        break;
    }
  }

  void _drawMysteriousEffects(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryCyan.withOpacity(0.3 * animationValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      final startX = (i * size.width / 3) + 50;
      final path = Path();
      path.moveTo(startX, 0);
      path.quadraticBezierTo(
        startX + 100,
        size.height / 2,
        startX,
        size.height,
      );
      canvas.drawPath(path, paint);
    }
  }

  void _drawDramaticEffects(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2 * animationValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 5; i++) {
      final startX = size.width / 6 + (i * size.width / 6);
      final path = Path();
      path.moveTo(startX, 0);
      path.lineTo(startX + 30, size.height);
      canvas.drawPath(path, paint);
    }
  }

  void _drawHopefulEffects(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentGreen.withOpacity(0.4 * animationValue)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final x = (i * size.width / 20) + 25;
      final y = size.height * 0.8;
      final radius = 2.0 + (math.sin(animationValue * 2 * math.pi + i) * 2.0);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _drawTensionEffects(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.warningRed.withOpacity(0.3 * animationValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 10; i++) {
      final x = (i * size.width / 10) + 25;
      final path = Path();
      path.moveTo(x, 0);
      path.lineTo(x + 20, size.height);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

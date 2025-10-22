import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/difficulty.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/storage_service.dart';
import '../../../../core/services/voice_service.dart';
import '../../../../core/services/live_action_video_service.dart';
import '../../../../core/services/audio_service.dart';
import '../../domain/entities/story_scene.dart';
import '../../data/models/sample_story.dart';
import '../../../game/data/services/sudoku_generator.dart';
import '../../../game/presentation/screens/game_screen.dart';

class LiveActionStoryScreen extends StatefulWidget {
  const LiveActionStoryScreen({super.key});

  @override
  State<LiveActionStoryScreen> createState() => _LiveActionStoryScreenState();
}

class _LiveActionStoryScreenState extends State<LiveActionStoryScreen>
    with TickerProviderStateMixin {
  late Chapter chapter;
  int currentSceneIndex = 0;
  int currentDialogueIndex = 0;
  bool showContinueButton = false;
  bool isShowingLiveAction = false;

  late AnimationController _liveActionController;
  late AnimationController _transitionController;
  late Animation<double> _liveActionAnimation;
  late Animation<double> _transitionAnimation;

  @override
  void initState() {
    super.initState();
    chapter = SampleStory.getChapter1();
    _initializeAnimations();
    _initializeServices();
    _loadStoryProgress();
  }

  void _initializeAnimations() {
    _liveActionController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _liveActionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _liveActionController,
      curve: Curves.easeInOut,
    ));

    _transitionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeServices() async {
    await VoiceService.init();
    await AudioService.init();
    
    // Start background music for the current scene
    _playSceneMusic();
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
    
    // Auto-speak the current dialogue after a short delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _speakCurrentDialogue();
      }
    });
  }

  Future<void> _saveStoryProgress() async {
    await StorageService.saveStoryProgress({
      'sceneIndex': currentSceneIndex,
      'dialogueIndex': currentDialogueIndex,
      'showContinueButton': showContinueButton,
    });
  }

  @override
  void dispose() {
    _liveActionController.dispose();
    _transitionController.dispose();
    VoiceService.stop();
    AudioService.dispose();
    super.dispose();
  }

  void _nextDialogue() {
    setState(() {
      if (currentDialogueIndex < currentScene.dialogues.length - 1) {
        currentDialogueIndex++;
        showContinueButton = false;
        _saveStoryProgress();
        
        // Auto-speak the new dialogue
        _speakCurrentDialogue();
      } else {
        showContinueButton = true;
        _saveStoryProgress();
      }
    });
  }

  void _speakCurrentDialogue() {
    final currentDialogue = currentScene.dialogues[currentDialogueIndex];
    VoiceService.speak(currentDialogue.text, character: currentDialogue.speaker);
    
    // Play character-specific sound effect
    AudioService.playCharacterSound(currentDialogue.speaker);
  }

  void _playSceneMusic() {
    AudioService.playSceneMusic(_getSceneType());
  }

  void _playTransitionSound() {
    AudioService.playTransitionSound('scene_change');
  }

  void _nextScene() {
    _playTransitionSound();
    _transitionController.reverse().then((_) {
      setState(() {
        if (currentScene.requiresPuzzleCompletion) {
          _startPuzzle();
        } else if (currentSceneIndex < chapter.scenes.length - 1) {
          currentSceneIndex++;
          currentDialogueIndex = 0;
          showContinueButton = false;
          _saveStoryProgress();
          
          // Play new scene music
          _playSceneMusic();
        } else {
          // End of chapter
          Navigator.of(context).pop();
        }
      });
      _transitionController.forward();
    });
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
      if (currentSceneIndex < chapter.scenes.length - 1) {
        setState(() {
          currentSceneIndex++;
          currentDialogueIndex = 0;
          showContinueButton = false;
        });
        _saveStoryProgress();
      }
    });
  }

  void _showLiveActionIntro() {
    setState(() {
      isShowingLiveAction = true;
    });
    _liveActionController.forward();
  }

  void _hideLiveActionIntro() {
    setState(() {
      isShowingLiveAction = false;
    });
    _liveActionController.reverse();
  }

  StoryScene get currentScene => chapter.scenes[currentSceneIndex];

  @override
  Widget build(BuildContext context) {
    if (isShowingLiveAction) {
      return _buildLiveActionIntro();
    }

    return Scaffold(
      body: Stack(
        children: [
          // Live-action background
          _buildLiveActionBackground(),
          
          // Main content
          _buildMainContent(),
          
          // Live-action transitions (disabled to prevent duplication)
          // _buildLiveActionTransitions(),
        ],
      ),
    );
  }

  Widget _buildLiveActionIntro() {
    return LiveActionVideoService.createCinematicIntro(
      chapterTitle: chapter.title,
      sceneDescription: currentScene.title,
      onComplete: _hideLiveActionIntro,
    );
  }

  Widget _buildLiveActionBackground() {
    return AnimatedBuilder(
      animation: _liveActionAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: _getSceneGradient(),
          ),
          child: CustomPaint(
            painter: _LiveActionBackgroundPainter(_liveActionAnimation.value),
            size: Size.infinite,
          ),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Column(
        children: [
          // Live-action header
          _buildLiveActionHeader(),
          
          // Live-action progress
          _buildLiveActionProgress(),
          
          const SizedBox(height: 20),
          
          // Live-action scene
          Expanded(
            child: _buildLiveActionScene(),
          ),
          
          // Live-action dialogue
          _buildLiveActionDialogue(),
          
          // Live-action continue button
          if (showContinueButton)
            _buildLiveActionContinueButton(),
        ],
      ),
    );
  }

  Widget _buildLiveActionHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Live-action back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryCyan.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryCyan, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryCyan.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
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
                      ),
                ),
                Text(
                  currentScene.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),
          // Live-action intro button
          GestureDetector(
            onTap: _showLiveActionIntro,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryPurple, width: 1),
              ),
              child: const Icon(
                Icons.movie,
                color: AppTheme.primaryPurple,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveActionProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (currentSceneIndex + 1) / chapter.scenes.length,
            backgroundColor: AppTheme.gridLine,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryCyan),
          ),
          const SizedBox(height: 8),
          Text(
            'Scene ${currentSceneIndex + 1} of ${chapter.scenes.length}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveActionScene() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: LiveActionVideoService.createLiveActionScene(
        sceneId: _getSceneType(),
        videoPath: _getVideoPath(),
        width: double.infinity,
        height: 300,
        isActive: true,
        onComplete: _nextDialogue,
        onTap: _nextDialogue,
      ),
    );
  }

  Widget _buildLiveActionDialogue() {
    final currentDialogue = currentScene.dialogues[currentDialogueIndex];
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: currentDialogueIndex < currentScene.dialogues.length - 1 
            ? _nextDialogue 
            : null,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getCharacterColor(currentDialogue.speaker),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _getCharacterColor(currentDialogue.speaker).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Character info
              Row(
                children: [
                  Icon(
                    _getCharacterIcon(currentDialogue.speaker),
                    color: _getCharacterColor(currentDialogue.speaker),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    currentDialogue.speaker.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _getCharacterColor(currentDialogue.speaker),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Dialogue text
              Text(
                currentDialogue.text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      height: 1.5,
                    ),
              ),
              
              // Tap to continue hint
              if (currentDialogueIndex < currentScene.dialogues.length - 1)
                GestureDetector(
                  onTap: _nextDialogue,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: _getCharacterColor(currentDialogue.speaker).withOpacity(0.6),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Tap to continue',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getCharacterColor(currentDialogue.speaker).withOpacity(0.6),
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveActionContinueButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: _nextScene,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getSceneColor(),
                _getSceneColor().withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _getSceneColor().withOpacity(0.4),
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

  // Removed _buildLiveActionTransitions() to prevent scene duplication

  String _getSceneType() {
    switch (currentScene.title.toLowerCase()) {
      case 'awakening':
        return 'awakening';
      case 'first fragment':
        return 'contact';
      case 'fragment restored':
        return 'memory';
      case 'first memory':
        return 'memory';
      default:
        return 'awakening';
    }
  }

  String _getVideoPath() {
    switch (currentScene.title.toLowerCase()) {
      case 'awakening':
        return 'assets/live_action/awakening_scene.mp4';
      case 'first fragment':
        return 'assets/live_action/contact_scene.mp4';
      case 'fragment restored':
        return 'assets/live_action/memory_reveal.mp4';
      case 'first memory':
        return 'assets/live_action/memory_scene.mp4';
      default:
        return 'assets/live_action/default_scene.mp4';
    }
  }

  // Removed unused helper methods to prevent scene duplication

  LinearGradient _getSceneGradient() {
    switch (_getSceneType()) {
      case 'awakening':
        return const LinearGradient(
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'contact':
        return const LinearGradient(
          colors: [Color(0xFF0f3460), Color(0xFF0a1929)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'memory':
        return const LinearGradient(
          colors: [Color(0xFF2d1b69), Color(0xFF11052c)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  Color _getSceneColor() {
    switch (_getSceneType()) {
      case 'awakening':
        return const Color(0xFF00FFFF);
      case 'contact':
        return const Color(0xFF00FF00);
      case 'memory':
        return const Color(0xFF8A2BE2);
      default:
        return const Color(0xFF00FFFF);
    }
  }

  Color _getCharacterColor(String speaker) {
    switch (speaker.toLowerCase()) {
      case 'echo':
        return const Color(0xFF00FFFF);
      case 'you':
        return const Color(0xFF00FF00);
      case 'narrator':
        return const Color(0xFF8A2BE2);
      case 'system':
        return const Color(0xFFFF6B6B);
      default:
        return const Color(0xFF00FFFF);
    }
  }

  IconData _getCharacterIcon(String speaker) {
    switch (speaker.toLowerCase()) {
      case 'echo':
        return Icons.psychology_alt;
      case 'you':
        return Icons.person;
      case 'narrator':
        return Icons.record_voice_over;
      case 'system':
        return Icons.settings;
      default:
        return Icons.person;
    }
  }
}

class _LiveActionBackgroundPainter extends CustomPainter {
  final double animationValue;

  _LiveActionBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withOpacity(0.3 * animationValue);

    // Draw cinematic particles
    for (int i = 0; i < 100; i++) {
      final x = (i * size.width / 100) + (animationValue * 200);
      final y = size.height * 0.2 + (i * 5);
      final radius = 1.0 + (animationValue * 2.0);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

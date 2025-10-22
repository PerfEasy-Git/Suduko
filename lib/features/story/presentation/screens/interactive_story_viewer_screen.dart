import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/difficulty.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/storage_service.dart';
import '../../../../core/services/voice_service.dart';
import '../../../../core/services/visual_service.dart';
import '../../../../core/services/interactive_visual_service.dart';
import '../../domain/entities/story_scene.dart';
import '../../data/models/sample_story.dart';
import '../widgets/character_dialogue_box.dart';
import '../../../game/data/services/sudoku_generator.dart';
import '../../../game/presentation/screens/game_screen.dart';

class InteractiveStoryViewerScreen extends StatefulWidget {
  const InteractiveStoryViewerScreen({super.key});

  @override
  State<InteractiveStoryViewerScreen> createState() => _InteractiveStoryViewerScreenState();
}

class _InteractiveStoryViewerScreenState extends State<InteractiveStoryViewerScreen>
    with TickerProviderStateMixin {
  late Chapter chapter;
  int currentSceneIndex = 0;
  int currentDialogueIndex = 0;
  bool showContinueButton = false;
  late ScrollController _scrollController;
  late AnimationController _sceneTransitionController;
  late AnimationController _interactionController;
  late Animation<double> _sceneTransitionAnimation;
  late Animation<double> _interactionAnimation;
  bool _isInteracting = false;

  @override
  void initState() {
    super.initState();
    chapter = SampleStory.getChapter1();
    _scrollController = ScrollController();
    _initializeAnimations();
    _initializeServices();
    _loadStoryProgress();
  }

  void _initializeAnimations() {
    _sceneTransitionController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _interactionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _sceneTransitionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sceneTransitionController,
      curve: Curves.easeInOut,
    ));

    _interactionAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _interactionController,
      curve: Curves.elasticOut,
    ));
  }

  Future<void> _initializeServices() async {
    await VoiceService.init();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _sceneTransitionController.dispose();
    _interactionController.dispose();
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
    _sceneTransitionController.forward();
  }

  Future<void> _saveStoryProgress() async {
    await StorageService.saveStoryProgress({
      'sceneIndex': currentSceneIndex,
      'dialogueIndex': currentDialogueIndex,
      'showContinueButton': showContinueButton,
    });
  }

  StoryScene get currentScene => chapter.scenes[currentSceneIndex];

  void _onInteraction() {
    setState(() {
      _isInteracting = true;
    });
    _interactionController.forward().then((_) {
      _interactionController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _isInteracting = false;
          });
        }
      });
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
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
        
        // Show continue button after last dialogue
        if (currentDialogueIndex == currentScene.dialogues.length - 1) {
          Future.delayed(const Duration(milliseconds: 500), () {
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
        _saveStoryProgress();
        
        // Auto-scroll to show the completion dialogue
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && _scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
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
        title: Text(
          'CHAPTER COMPLETE',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.accentGreen,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: AppTheme.accentGreen,
              size: 64,
            ),
            const SizedBox(height: 16),
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
          // Interactive animated background
          InteractiveVisualService.createInteractiveParticles(
            onTap: _onInteraction,
            effectType: currentScene.title.toLowerCase(),
          ),
          
          // Main content with scene transition
          AnimatedBuilder(
            animation: _sceneTransitionAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _sceneTransitionAnimation.value,
                child: Transform.scale(
                  scale: 0.9 + (0.1 * _sceneTransitionAnimation.value),
                  child: SafeArea(
                    child: Column(
                      children: [
                        // Interactive Header
                        _buildInteractiveHeader(),
                        
                        // Progress indicator with animation
                        _buildAnimatedProgress(),
                        
                        const SizedBox(height: 16),
                        
                        // Interactive Dialogues
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(bottom: 100),
                            itemCount: visibleDialogues.length,
                            itemBuilder: (context, index) {
                              return AnimatedBuilder(
                                animation: _interactionAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: index == visibleDialogues.length - 1 && _isInteracting
                                        ? _interactionAnimation.value
                                        : 1.0,
                                    child: CharacterDialogueBox(
                                      dialogue: visibleDialogues[index],
                                      onTap: index == visibleDialogues.length - 1
                                          ? _nextDialogue
                                          : null,
                                      isActive: index == visibleDialogues.length - 1,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        
                        // Interactive Continue Button
                        if (showContinueButton)
                          _buildInteractiveContinueButton(),
                        
                        // Interactive story elements
                        if (currentScene.title.toLowerCase().contains('discovery'))
                          _buildInteractiveStoryElements(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Animated back button
          AnimatedBuilder(
            animation: _interactionAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isInteracting ? _interactionAnimation.value : 1.0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppTheme.primaryCyan),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Character animation
                InteractiveVisualService.createCharacterAnimation(
                  character: 'echo',
                  emotion: 'neutral',
                  size: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  chapter.title.toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryCyan,
                      ),
                ),
                Text(
                  currentScene.title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedBuilder(
        animation: _sceneTransitionAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _sceneTransitionAnimation.value,
            child: LinearProgressIndicator(
              value: (currentSceneIndex + 1) / chapter.scenes.length,
              backgroundColor: AppTheme.gridLine,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryCyan),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInteractiveContinueButton() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: AnimatedBuilder(
        animation: _interactionAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isInteracting ? _interactionAnimation.value : 1.0,
            child: GestureDetector(
              onTap: _nextScene,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryCyan, AppTheme.primaryPurple],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryCyan.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  currentScene.requiresPuzzleCompletion
                      ? 'START PUZZLE'
                      : 'CONTINUE',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInteractiveStoryElements() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Memory Fragment
          InteractiveVisualService.createStoryElement(
            elementType: 'memory_fragment',
            content: 'Memory Fragment Restored',
            onInteract: _onInteraction,
          ),
          const SizedBox(height: 12),
          
          // Data Stream
          InteractiveVisualService.createStoryElement(
            elementType: 'data_stream',
            content: 'Data Stream Active',
            onInteract: _onInteraction,
          ),
          const SizedBox(height: 12),
          
          // Nexus Core
          InteractiveVisualService.createStoryElement(
            elementType: 'nexus_core',
            content: 'Nexus Core Online',
            onInteract: _onInteraction,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/difficulty.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/storage_service.dart';
import '../../../../core/services/voice_service.dart';
import '../../../../core/services/visual_service.dart';
import '../../domain/entities/story_scene.dart';
import '../../data/models/sample_story.dart';
import '../widgets/enhanced_dialogue_box.dart';
import '../../../game/data/services/sudoku_generator.dart';
import '../../../game/presentation/screens/game_screen.dart';

class StoryViewerScreen extends StatefulWidget {
  const StoryViewerScreen({super.key});

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  late Chapter chapter;
  int currentSceneIndex = 0;
  int currentDialogueIndex = 0;
  bool showContinueButton = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    chapter = SampleStory.getChapter1();
    _scrollController = ScrollController();
    _initializeServices();
    _loadStoryProgress();
  }

  Future<void> _initializeServices() async {
    await VoiceService.init();
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
    _scrollController.dispose();
    super.dispose();
  }

  StoryScene get currentScene => chapter.scenes[currentSceneIndex];

  void _nextDialogue() {
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
          // Animated background based on scene
          VisualService.createAnimatedBackground(
            sceneType: currentScene.title.toLowerCase(),
          ),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppTheme.primaryCyan),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
              ),

              // Progress indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(
                  value: (currentSceneIndex + 1) / chapter.scenes.length,
                  backgroundColor: AppTheme.gridLine,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryCyan),
                ),
              ),

              const SizedBox(height: 16),

              // Dialogues
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: visibleDialogues.length,
                  itemBuilder: (context, index) {
                    return EnhancedDialogueBox(
                      dialogue: visibleDialogues[index],
                      onTap: index == visibleDialogues.length - 1
                          ? _nextDialogue
                          : null,
                      isActive: index == visibleDialogues.length - 1,
                    );
                  },
                ),
              ),

              // Continue Button
              if (showContinueButton)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextScene,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        currentScene.requiresPuzzleCompletion
                            ? 'START PUZZLE'
                            : 'CONTINUE',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),

              // Tap to continue hint
              if (!showContinueButton &&
                  currentDialogueIndex == currentScene.dialogues.length - 1)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Tap to continue...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryCyan.withOpacity(0.6),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


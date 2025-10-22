import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/services/external_character_service.dart';
import '../../../../core/services/voice_service.dart';

class VisualStoryScene extends StatefulWidget {
  final String sceneType;
  final String character1;
  final String character2;
  final String dialogue;
  final VoidCallback? onTap;
  final bool isActive;

  const VisualStoryScene({
    super.key,
    required this.sceneType,
    required this.character1,
    required this.character2,
    required this.dialogue,
    this.onTap,
    this.isActive = false,
  });

  @override
  State<VisualStoryScene> createState() => _VisualStorySceneState();
}

class _VisualStorySceneState extends State<VisualStoryScene>
    with TickerProviderStateMixin {
  late AnimationController _sceneController;
  late AnimationController _characterController;
  late AnimationController _dialogueController;
  
  late Animation<double> _sceneAnimation;
  late Animation<double> _characterAnimation;
  late Animation<double> _dialogueAnimation;

  @override
  void initState() {
    super.initState();
    
    _sceneController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _characterController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _dialogueController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _sceneAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sceneController,
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

    _sceneController.forward();
    _characterController.forward();
    _dialogueController.forward();
    
    // Initialize voice service and speak dialogue
    _initializeVoice();
  }

  Future<void> _initializeVoice() async {
    await VoiceService.init();
    // Auto-speak the dialogue after a short delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        VoiceService.speak(widget.dialogue, character: _getSpeaker());
      }
    });
  }

  String _getSpeaker() {
    // Determine speaker based on scene type
    switch (widget.sceneType.toLowerCase()) {
      case 'awakening':
        return 'ECHO';
      case 'first fragment':
        return 'ECHO';
      case 'fragment restored':
        return 'ECHO';
      case 'first memory':
        return 'Narrator';
      default:
        return 'System';
    }
  }

  @override
  void dispose() {
    _sceneController.dispose();
    _characterController.dispose();
    _dialogueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Animated Background Scene
            _buildAnimatedBackground(),
            
            // Character Interactions
            _buildCharacterInteraction(),
            
            // Dialogue Overlay
            _buildDialogueOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _sceneAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _sceneAnimation.value,
          child: _getSceneBackground(),
        );
      },
    );
  }

  Widget _getSceneBackground() {
    switch (widget.sceneType.toLowerCase()) {
      case 'awakening':
        return _buildAwakeningScene();
      case 'first fragment':
        return _buildPuzzleScene();
      case 'fragment restored':
        return _buildCelebrationScene();
      case 'first memory':
        return _buildMemoryScene();
      default:
        return _buildDefaultScene();
    }
  }

  Widget _buildAwakeningScene() {
    return Stack(
      children: [
        // Cosmic background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0A0A0A),
                Color(0xFF1A0A2E),
                Color(0xFF2E1A4A),
              ],
            ),
          ),
        ),
        // Floating data fragments
        CustomPaint(
          painter: DataFragmentPainter(_sceneAnimation.value),
          size: Size.infinite,
        ),
        // You character awakening
        Positioned(
          bottom: 50,
          left: 20,
          child: _buildHumanCharacter('You', 'confused'),
        ),
      ],
    );
  }

  Widget _buildPuzzleScene() {
    return Stack(
      children: [
        // Digital grid background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F0F23),
                Color(0xFF1A1A2E),
                Color(0xFF16213E),
              ],
            ),
          ),
        ),
        // Animated puzzle grid
        CustomPaint(
          painter: PuzzleGridPainter(_sceneAnimation.value),
          size: Size.infinite,
        ),
        // ECHO character guiding
        Positioned(
          top: 50,
          right: 20,
          child: _buildHumanCharacter('ECHO', 'helpful'),
        ),
        // You character solving
        Positioned(
          bottom: 50,
          left: 20,
          child: _buildHumanCharacter('You', 'determined'),
        ),
      ],
    );
  }

  Widget _buildCelebrationScene() {
    return Stack(
      children: [
        // Success background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0A2E0A),
                Color(0xFF1A4A1A),
                Color(0xFF2E5A2E),
              ],
            ),
          ),
        ),
        // Celebration particles
        CustomPaint(
          painter: CelebrationPainter(_sceneAnimation.value),
          size: Size.infinite,
        ),
        // Both characters celebrating
        Positioned(
          top: 50,
          left: 20,
          child: _buildHumanCharacter('ECHO', 'hopeful'),
        ),
        Positioned(
          bottom: 50,
          right: 20,
          child: _buildHumanCharacter('You', 'realizing'),
        ),
      ],
    );
  }

  Widget _buildMemoryScene() {
    return Stack(
      children: [
        // Memory background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E0A0A),
                Color(0xFF4A1A1A),
                Color(0xFF5A2E2E),
              ],
            ),
          ),
        ),
        // Floating memories
        CustomPaint(
          painter: MemoryPainter(_sceneAnimation.value),
          size: Size.infinite,
        ),
        // Narrator character
        Positioned(
          top: 100,
          left: 100,
          child: _buildHumanCharacter('Narrator', 'dramatic'),
        ),
      ],
    );
  }

  Widget _buildDefaultScene() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0A0A),
            Color(0xFF1A1A2E),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterInteraction() {
    return AnimatedBuilder(
      animation: _characterAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _characterAnimation.value,
          child: _getCharacterInteraction(),
        );
      },
    );
  }

  Widget _getCharacterInteraction() {
    switch (widget.sceneType.toLowerCase()) {
      case 'awakening':
        return _buildAwakeningInteraction();
      case 'first fragment':
        return _buildPuzzleInteraction();
      case 'fragment restored':
        return _buildCelebrationInteraction();
      case 'first memory':
        return _buildMemoryInteraction();
      default:
        return Container();
    }
  }

  Widget _buildAwakeningInteraction() {
    return Stack(
      children: [
        // You character waking up
        Positioned(
          bottom: 100,
          left: 50,
          child: _buildHumanCharacter('You', 'confused'),
        ),
        // ECHO appearing
        Positioned(
          top: 100,
          right: 50,
          child: _buildHumanCharacter('ECHO', 'mysterious'),
        ),
      ],
    );
  }

  Widget _buildPuzzleInteraction() {
    return Stack(
      children: [
        // ECHO guiding
        Positioned(
          top: 100,
          right: 50,
          child: _buildHumanCharacter('ECHO', 'helpful'),
        ),
        // You solving
        Positioned(
          bottom: 100,
          left: 50,
          child: _buildHumanCharacter('You', 'determined'),
        ),
      ],
    );
  }

  Widget _buildCelebrationInteraction() {
    return Stack(
      children: [
        // ECHO celebrating
        Positioned(
          top: 100,
          left: 50,
          child: _buildHumanCharacter('ECHO', 'hopeful'),
        ),
        // You celebrating
        Positioned(
          bottom: 100,
          right: 50,
          child: _buildHumanCharacter('You', 'realizing'),
        ),
      ],
    );
  }

  Widget _buildMemoryInteraction() {
    return Stack(
      children: [
        // Narrator telling story
        Positioned(
          top: 200,
          left: 200,
          child: _buildHumanCharacter('Narrator', 'dramatic'),
        ),
      ],
    );
  }

  Widget _buildHumanCharacter(String character, String emotion) {
    return SizedBox(
      width: 120,
      height: 120,
      child: ExternalCharacterService.createCharacterAnimation(
        characterId: character,
        animationType: _getAnimationType(character),
        size: 100,
        isActive: widget.isActive,
      ),
    );
  }

  String _getAnimationType(String character) {
    // Determine animation type based on character
    switch (character.toLowerCase()) {
      case 'echo':
        return 'lottie'; // Use Lottie for ECHO
      case 'you':
        return 'rive'; // Use Rive for You
      case 'narrator':
        return 'video'; // Use Video for Narrator
      case 'system':
        return 'lottie'; // Use Lottie for System
      default:
        return 'lottie';
    }
  }

  List<Color> _getCharacterColors(String character) {
    switch (character.toLowerCase()) {
      case 'echo':
        return [const Color(0xFF00FFFF), const Color(0xFF0080FF)];
      case 'you':
        return [const Color(0xFF00FF00), const Color(0xFF00AA00)];
      case 'narrator':
        return [const Color(0xFF8A2BE2), const Color(0xFF4B0082)];
      default:
        return [const Color(0xFFFF6B6B), const Color(0xFFE74C3C)];
    }
  }

  Widget _buildCharacterFace(String character, String emotion) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Eyes
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEye(emotion),
            const SizedBox(width: 8),
            _buildEye(emotion),
          ],
        ),
        const SizedBox(height: 4),
        // Nose
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 2),
        // Mouth
        Container(
          width: 12,
          height: 4,
          decoration: BoxDecoration(
            color: _getMouthColor(emotion),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildEye(String emotion) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Center(
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: _getEyeColor(emotion),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Color _getMouthColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
      case 'hopeful':
      case 'celebrating':
        return Colors.green;
      case 'confused':
      case 'worried':
        return Colors.orange;
      case 'determined':
      case 'focused':
        return Colors.blue;
      default:
        return Colors.white;
    }
  }

  Color _getEyeColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'mysterious':
        return Colors.cyan;
      case 'hopeful':
        return Colors.green;
      case 'dramatic':
        return Colors.purple;
      default:
        return Colors.black;
    }
  }

  Widget _buildDialogueOverlay() {
    return AnimatedBuilder(
      animation: _dialogueAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Transform.translate(
            offset: Offset(0, (1.0 - _dialogueAnimation.value) * 200),
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyan, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.dialogue,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  if (widget.onTap != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: Colors.cyan.withOpacity(0.7),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Tap to continue',
                          style: TextStyle(
                            color: Colors.cyan.withOpacity(0.7),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom painters for visual effects
class DataFragmentPainter extends CustomPainter {
  final double animationValue;

  DataFragmentPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() * size.height + animationValue * 100) % size.height;
      final radius = random.nextDouble() * 3 + 1;
      final opacity = random.nextDouble() * 0.8 + 0.2;
      
      paint.color = Colors.cyan.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PuzzleGridPainter extends CustomPainter {
  final double animationValue;

  PuzzleGridPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.cyan.withOpacity(0.5);

    final gridSize = 30.0;
    for (int i = 0; i <= size.width / gridSize; i++) {
      final x = i * gridSize;
      final opacity = 0.3 + math.sin(animationValue * 2 * math.pi + i) * 0.2;
      paint.color = Colors.cyan.withOpacity(opacity);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    for (int i = 0; i <= size.height / gridSize; i++) {
      final y = i * gridSize;
      final opacity = 0.3 + math.sin(animationValue * 2 * math.pi + i) * 0.2;
      paint.color = Colors.cyan.withOpacity(opacity);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CelebrationPainter extends CustomPainter {
  final double animationValue;

  CelebrationPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);

    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 4 + 2;
      final opacity = random.nextDouble() * 0.8 + 0.2;
      
      final colors = [Colors.green, Colors.cyan, Colors.yellow];
      paint.color = colors[random.nextInt(colors.length)].withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MemoryPainter extends CustomPainter {
  final double animationValue;

  MemoryPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 5 + math.sin(animationValue * 2 * math.pi + i) * 3;
      final opacity = 0.3 + math.sin(animationValue * 3 * math.pi + i) * 0.3;
      
      paint.color = Colors.purple.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

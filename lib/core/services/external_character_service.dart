import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart' hide RadialGradient;
import 'package:video_player/video_player.dart';

class ExternalCharacterService {
  // Character animation types
  static Widget createCharacterAnimation({
    required String characterId,
    required String animationType,
    required double size,
    required bool isActive,
  }) {
    return _CharacterAnimationWidget(
      characterId: characterId,
      animationType: animationType,
      size: size,
      isActive: isActive,
    );
  }

  // Lottie character animation
  static Widget createLottieCharacter({
    required String animationPath,
    required double size,
    required bool isActive,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.asset(
        animationPath,
        fit: BoxFit.contain,
        repeat: isActive,
        animate: isActive,
      ),
    );
  }

  // Rive character animation
  static Widget createRiveCharacter({
    required String animationPath,
    required double size,
    required bool isActive,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: RiveAnimation.asset(
        animationPath,
        fit: BoxFit.contain,
        animations: isActive ? ['idle', 'speaking'] : ['idle'],
      ),
    );
  }

  // Video character animation
  static Widget createVideoCharacter({
    required String videoPath,
    required double size,
    required bool isActive,
  }) {
    return _VideoCharacterWidget(
      videoPath: videoPath,
      size: size,
      isActive: isActive,
    );
  }

  // Fallback character widget
  static Widget _buildFallbackCharacter(double size, String message) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF00FFFF), Color(0xFF0080FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FFFF).withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Human-like face
          Container(
            width: size * 0.6,
            height: size * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.9),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Eyes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: size * 0.08,
                      height: size * 0.08,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                    ),
                    Container(
                      width: size * 0.08,
                      height: size * 0.08,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size * 0.02),
                // Smile
                Container(
                  width: size * 0.2,
                  height: size * 0.03,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size * 0.05),
          Text(
            'HUMAN',
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.08,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CharacterAnimationWidget extends StatefulWidget {
  final String characterId;
  final String animationType;
  final double size;
  final bool isActive;

  const _CharacterAnimationWidget({
    required this.characterId,
    required this.animationType,
    required this.size,
    required this.isActive,
  });

  @override
  State<_CharacterAnimationWidget> createState() => _CharacterAnimationWidgetState();
}

class _CharacterAnimationWidgetState extends State<_CharacterAnimationWidget> {
  @override
  Widget build(BuildContext context) {
    // Determine animation type based on character and scene
    final animationPath = _getAnimationPath();
    
    // For now, always show fallback character until we have real character files
    return _buildCharacterFallback();
    
    // TODO: Uncomment when we have real character files
    // switch (widget.animationType.toLowerCase()) {
    //   case 'lottie':
    //     return ExternalCharacterService.createLottieCharacter(
    //       animationPath: animationPath,
    //       size: widget.size,
    //       isActive: widget.isActive,
    //     );
    //   case 'rive':
    //     return ExternalCharacterService.createRiveCharacter(
    //       animationPath: animationPath,
    //       size: widget.size,
    //       isActive: widget.isActive,
    //     );
    //   case 'video':
    //     return ExternalCharacterService.createVideoCharacter(
    //       videoPath: animationPath,
    //       size: widget.size,
    //       isActive: widget.isActive,
    //     );
    //   default:
    //     return _buildFallbackCharacter();
    // }
  }

  String _getAnimationPath() {
    // Return path to character animation based on character ID
    switch (widget.characterId.toLowerCase()) {
      case 'echo':
        return 'assets/characters/echo_${widget.animationType.toLowerCase()}.${_getFileExtension()}';
      case 'you':
        return 'assets/characters/you_${widget.animationType.toLowerCase()}.${_getFileExtension()}';
      case 'narrator':
        return 'assets/characters/narrator_${widget.animationType.toLowerCase()}.${_getFileExtension()}';
      case 'system':
        return 'assets/characters/system_${widget.animationType.toLowerCase()}.${_getFileExtension()}';
      default:
        return 'assets/characters/default_${widget.animationType.toLowerCase()}.${_getFileExtension()}';
    }
  }

  String _getFileExtension() {
    switch (widget.animationType.toLowerCase()) {
      case 'lottie':
        return 'json';
      case 'rive':
        return 'riv';
      case 'video':
        return 'mp4';
      default:
        return 'json';
    }
  }

  Widget _buildFallbackCharacter() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: _getCharacterColors(),
        ),
      ),
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: widget.size * 0.5,
      ),
    );
  }

  List<Color> _getCharacterColors() {
    switch (widget.characterId.toLowerCase()) {
      case 'echo':
        return [const Color(0xFF00FFFF), const Color(0xFF0080FF)];
      case 'you':
        return [const Color(0xFF00FF00), const Color(0xFF00AA00)];
      case 'narrator':
        return [const Color(0xFF8A2BE2), const Color(0xFF4B0082)];
      case 'system':
        return [const Color(0xFFFF6B6B), const Color(0xFFE74C3C)];
      default:
        return [const Color(0xFF9E9E9E), const Color(0xFF757575)];
    }
  }

  Widget _buildCharacterFallback() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: _getCharacterColors(),
        ),
        boxShadow: [
          BoxShadow(
            color: _getCharacterColors()[0].withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Human-like face
          Container(
            width: widget.size * 0.6,
            height: widget.size * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.9),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Eyes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: widget.size * 0.08,
                      height: widget.size * 0.08,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                    ),
                    Container(
                      width: widget.size * 0.08,
                      height: widget.size * 0.08,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: widget.size * 0.02),
                // Smile
                Container(
                  width: widget.size * 0.2,
                  height: widget.size * 0.03,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: widget.size * 0.05),
          Text(
            widget.characterId.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: widget.size * 0.08,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _VideoCharacterWidget extends StatefulWidget {
  final String videoPath;
  final double size;
  final bool isActive;

  const _VideoCharacterWidget({
    required this.videoPath,
    required this.size,
    required this.isActive,
  });

  @override
  State<_VideoCharacterWidget> createState() => _VideoCharacterWidgetState();
}

class _VideoCharacterWidgetState extends State<_VideoCharacterWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset(widget.videoPath);
    await _controller.initialize();
    setState(() {
      _isInitialized = true;
    });
    
    if (widget.isActive) {
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: ClipOval(
        child: VideoPlayer(_controller),
      ),
    );
  }
}

// Character animation configuration
class CharacterAnimationConfig {
  final String characterId;
  final String animationType;
  final String idleAnimation;
  final String speakingAnimation;
  final String emotionalAnimation;
  final Map<String, String> sceneAnimations;

  const CharacterAnimationConfig({
    required this.characterId,
    required this.animationType,
    required this.idleAnimation,
    required this.speakingAnimation,
    required this.emotionalAnimation,
    required this.sceneAnimations,
  });
}

// Predefined character configurations
class CharacterConfigs {
  static const CharacterAnimationConfig echo = CharacterAnimationConfig(
    characterId: 'echo',
    animationType: 'lottie',
    idleAnimation: 'echo_idle.json',
    speakingAnimation: 'echo_speaking.json',
    emotionalAnimation: 'echo_emotional.json',
    sceneAnimations: {
      'awakening': 'echo_awakening.json',
      'puzzle': 'echo_guiding.json',
      'celebration': 'echo_hopeful.json',
    },
  );

  static const CharacterAnimationConfig you = CharacterAnimationConfig(
    characterId: 'you',
    animationType: 'rive',
    idleAnimation: 'you_idle.riv',
    speakingAnimation: 'you_speaking.riv',
    emotionalAnimation: 'you_emotional.riv',
    sceneAnimations: {
      'awakening': 'you_confused.riv',
      'puzzle': 'you_determined.riv',
      'celebration': 'you_realizing.riv',
    },
  );

  static const CharacterAnimationConfig narrator = CharacterAnimationConfig(
    characterId: 'narrator',
    animationType: 'video',
    idleAnimation: 'narrator_idle.mp4',
    speakingAnimation: 'narrator_speaking.mp4',
    emotionalAnimation: 'narrator_dramatic.mp4',
    sceneAnimations: {
      'memory': 'narrator_storytelling.mp4',
    },
  );

  static const CharacterAnimationConfig system = CharacterAnimationConfig(
    characterId: 'system',
    animationType: 'lottie',
    idleAnimation: 'system_idle.json',
    speakingAnimation: 'system_helpful.json',
    emotionalAnimation: 'system_encouraging.json',
    sceneAnimations: {},
  );
}

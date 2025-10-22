import 'package:flutter/material.dart';
import '../../../../core/models/character.dart';

class CharacterAvatar extends StatefulWidget {
  final String characterId;
  final String emotion;
  final double size;
  final bool isActive;
  final VoidCallback? onTap;

  const CharacterAvatar({
    super.key,
    required this.characterId,
    this.emotion = 'neutral',
    this.size = 80.0,
    this.isActive = false,
    this.onTap,
  });

  @override
  State<CharacterAvatar> createState() => _CharacterAvatarState();
}

class _CharacterAvatarState extends State<CharacterAvatar>
    with TickerProviderStateMixin {
  late AnimationController _idleController;
  late AnimationController _emotionController;
  late AnimationController _activeController;
  late Animation<double> _idleAnimation;
  late Animation<double> _emotionAnimation;
  late Animation<double> _activeAnimation;

  @override
  void initState() {
    super.initState();
    
    _idleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _emotionController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _activeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _idleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _idleController,
      curve: Curves.easeInOut,
    ));

    _emotionAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _emotionController,
      curve: Curves.elasticOut,
    ));

    _activeAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _activeController,
      curve: Curves.easeInOut,
    ));

    // Trigger emotion animation
    _emotionController.forward();

    // Handle active state
    if (widget.isActive) {
      _activeController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(CharacterAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _activeController.repeat(reverse: true);
      } else {
        _activeController.stop();
        _activeController.reset();
      }
    }
  }

  @override
  void dispose() {
    _idleController.dispose();
    _emotionController.dispose();
    _activeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final character = CharacterDatabase.getCharacter(widget.characterId);
    final currentEmotion = character.emotions.firstWhere(
      (e) => e.name == widget.emotion,
      orElse: () => character.emotions.first,
    );

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _idleAnimation,
          _emotionAnimation,
          _activeAnimation,
        ]),
        builder: (context, child) {
          final scale = _idleAnimation.value * 
                       _emotionAnimation.value * 
                       (widget.isActive ? _activeAnimation.value : 1.0);
          
          return Transform.scale(
            scale: scale,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    character.appearance.primaryColor,
                    character.appearance.secondaryColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: currentEmotion.color.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: character.appearance.primaryColor.withOpacity(0.4),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Character face/icon
                  Center(
                    child: _buildCharacterFace(character, currentEmotion),
                  ),
                  
                  // Emotion indicator
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _buildEmotionIndicator(currentEmotion),
                  ),
                  
                  // Active indicator
                  if (widget.isActive)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: _buildActiveIndicator(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCharacterFace(Character character, CharacterEmotion emotion) {
    switch (character.id.toLowerCase()) {
      case 'echo':
        return _buildEchoFace(emotion);
      case 'you':
        return _buildYouFace(emotion);
      case 'narrator':
        return _buildNarratorFace(emotion);
      case 'system':
        return _buildSystemFace(emotion);
      default:
        return Icon(
          Icons.person,
          color: Colors.white,
          size: widget.size * 0.4,
        );
    }
  }

  Widget _buildEchoFace(CharacterEmotion emotion) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Glowing eyes
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGlowingEye(emotion.color),
            const SizedBox(width: 8),
            _buildGlowingEye(emotion.color),
          ],
        ),
        const SizedBox(height: 4),
        // Circuit pattern
        Container(
          width: widget.size * 0.3,
          height: 2,
          decoration: BoxDecoration(
            color: emotion.color,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: widget.size * 0.2,
          height: 2,
          decoration: BoxDecoration(
            color: emotion.color.withOpacity(0.7),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }

  Widget _buildYouFace(CharacterEmotion emotion) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Human eyes
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHumanEye(emotion.color),
            const SizedBox(width: 8),
            _buildHumanEye(emotion.color),
          ],
        ),
        const SizedBox(height: 4),
        // Mouth expression
        Container(
          width: widget.size * 0.2,
          height: 2,
          decoration: BoxDecoration(
            color: emotion.color,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }

  Widget _buildNarratorFace(CharacterEmotion emotion) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Mystical eyes
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMysticalEye(emotion.color),
            const SizedBox(width: 8),
            _buildMysticalEye(emotion.color),
          ],
        ),
        const SizedBox(height: 4),
        // Energy patterns
        Container(
          width: widget.size * 0.4,
          height: 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [emotion.color, emotion.color.withOpacity(0.3)],
            ),
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemFace(CharacterEmotion emotion) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Friendly face
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFriendlyEye(emotion.color),
            const SizedBox(width: 8),
            _buildFriendlyEye(emotion.color),
          ],
        ),
        const SizedBox(height: 4),
        // Smile
        Container(
          width: widget.size * 0.25,
          height: 2,
          decoration: BoxDecoration(
            color: emotion.color,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }

  Widget _buildGlowingEye(Color color) {
    return Container(
      width: widget.size * 0.08,
      height: widget.size * 0.08,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.8),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildHumanEye(Color color) {
    return Container(
      width: widget.size * 0.08,
      height: widget.size * 0.08,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1),
      ),
      child: Center(
        child: Container(
          width: widget.size * 0.04,
          height: widget.size * 0.04,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildMysticalEye(Color color) {
    return Container(
      width: widget.size * 0.08,
      height: widget.size * 0.08,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [color, color.withOpacity(0.3)],
        ),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildFriendlyEye(Color color) {
    return Container(
      width: widget.size * 0.08,
      height: widget.size * 0.08,
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildEmotionIndicator(CharacterEmotion emotion) {
    return Container(
      width: widget.size * 0.15,
      height: widget.size * 0.15,
      decoration: BoxDecoration(
        color: emotion.color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: emotion.color.withOpacity(0.6),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        _getEmotionIcon(emotion.name),
        color: Colors.white,
        size: widget.size * 0.08,
      ),
    );
  }

  Widget _buildActiveIndicator() {
    return Container(
      width: widget.size * 0.15,
      height: widget.size * 0.15,
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.6),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        Icons.mic,
        color: Colors.white,
        size: widget.size * 0.08,
      ),
    );
  }

  IconData _getEmotionIcon(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'neutral':
        return Icons.sentiment_neutral;
      case 'concerned':
        return Icons.sentiment_dissatisfied;
      case 'hopeful':
        return Icons.sentiment_very_satisfied;
      case 'confused':
        return Icons.help_outline;
      case 'determined':
        return Icons.sentiment_very_satisfied;
      case 'realizing':
        return Icons.lightbulb;
      case 'dramatic':
        return Icons.theater_comedy;
      case 'mysterious':
        return Icons.visibility_off;
      case 'helpful':
        return Icons.help;
      case 'encouraging':
        return Icons.thumb_up;
      default:
        return Icons.sentiment_neutral;
    }
  }
}

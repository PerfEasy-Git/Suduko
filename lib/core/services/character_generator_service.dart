import 'package:flutter/material.dart';
import 'dart:math' as math;

class CharacterGeneratorService {
  // Generate human-like character with customizable features
  static Widget generateHumanCharacter({
    required String characterId,
    required String emotion,
    required double size,
    required bool isActive,
    CharacterPersonality? personality,
  }) {
    return _HumanCharacterWidget(
      characterId: characterId,
      emotion: emotion,
      size: size,
      isActive: isActive,
      personality: personality,
    );
  }

  // Generate character with specific features
  static Widget generateCharacterWithFeatures({
    required String characterId,
    required CharacterFeatures features,
    required String emotion,
    required double size,
    required bool isActive,
  }) {
    return _CustomCharacterWidget(
      characterId: characterId,
      features: features,
      emotion: emotion,
      size: size,
      isActive: isActive,
    );
  }
}

class CharacterFeatures {
  final String skinTone;
  final String hairColor;
  final String hairStyle;
  final String eyeColor;
  final String faceShape;
  final String gender;
  final int age;
  final String ethnicity;
  final List<String> accessories;

  const CharacterFeatures({
    required this.skinTone,
    required this.hairColor,
    required this.hairStyle,
    required this.eyeColor,
    required this.faceShape,
    required this.gender,
    required this.age,
    required this.ethnicity,
    required this.accessories,
  });
}

class CharacterPersonality {
  final String name;
  final String description;
  final String speakingStyle;
  final List<String> traits;
  final String motivation;

  const CharacterPersonality({
    required this.name,
    required this.description,
    required this.speakingStyle,
    required this.traits,
    required this.motivation,
  });
}

class _HumanCharacterWidget extends StatefulWidget {
  final String characterId;
  final String emotion;
  final double size;
  final bool isActive;
  final CharacterPersonality? personality;

  const _HumanCharacterWidget({
    required this.characterId,
    required this.emotion,
    required this.size,
    required this.isActive,
    this.personality,
  });

  @override
  State<_HumanCharacterWidget> createState() => _HumanCharacterWidgetState();
}

class _HumanCharacterWidgetState extends State<_HumanCharacterWidget>
    with TickerProviderStateMixin {
  late AnimationController _idleController;
  late AnimationController _emotionController;
  late AnimationController _speakingController;
  
  late Animation<double> _idleAnimation;
  late Animation<double> _emotionAnimation;
  late Animation<double> _speakingAnimation;

  @override
  void initState() {
    super.initState();
    
    _idleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _emotionController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _speakingController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _idleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _idleController,
      curve: Curves.easeInOut,
    ));

    _emotionAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _emotionController,
      curve: Curves.elasticOut,
    ));

    _speakingAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _speakingController,
      curve: Curves.easeInOut,
    ));

    _emotionController.forward();
    
    if (widget.isActive) {
      _speakingController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _idleController.dispose();
    _emotionController.dispose();
    _speakingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final features = _getCharacterFeatures();
    
    return AnimatedBuilder(
      animation: Listenable.merge([
        _idleAnimation,
        _emotionAnimation,
        _speakingAnimation,
      ]),
      builder: (context, child) {
        final scale = _idleAnimation.value * 
                     _emotionAnimation.value * 
                     (widget.isActive ? _speakingAnimation.value : 1.0);
        
        return Transform.scale(
          scale: scale,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: _getCharacterColors(),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getEmotionColor().withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Stack(
                  children: [
                    // Human face
                    _buildHumanFace(features),
                    
                    // Emotion indicator
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _buildEmotionIndicator(),
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
            ),
          ),
        );
      },
    );
  }

  CharacterFeatures _getCharacterFeatures() {
    switch (widget.characterId.toLowerCase()) {
      case 'echo':
        return const CharacterFeatures(
          skinTone: 'fair',
          hairColor: 'silver',
          hairStyle: 'short',
          eyeColor: 'cyan',
          faceShape: 'oval',
          gender: 'neutral',
          age: 30,
          ethnicity: 'mixed',
          accessories: ['circuit_patterns'],
        );
      case 'you':
        return const CharacterFeatures(
          skinTone: 'medium',
          hairColor: 'brown',
          hairStyle: 'medium',
          eyeColor: 'brown',
          faceShape: 'round',
          gender: 'neutral',
          age: 25,
          ethnicity: 'mixed',
          accessories: ['tech_implants'],
        );
      case 'narrator':
        return const CharacterFeatures(
          skinTone: 'fair',
          hairColor: 'white',
          hairStyle: 'long',
          eyeColor: 'blue',
          faceShape: 'square',
          gender: 'male',
          age: 60,
          ethnicity: 'caucasian',
          accessories: ['beard', 'glasses'],
        );
      case 'system':
        return const CharacterFeatures(
          skinTone: 'medium',
          hairColor: 'black',
          hairStyle: 'short',
          eyeColor: 'green',
          faceShape: 'oval',
          gender: 'neutral',
          age: 35,
          ethnicity: 'mixed',
          accessories: ['headset'],
        );
      default:
        return const CharacterFeatures(
          skinTone: 'medium',
          hairColor: 'brown',
          hairStyle: 'short',
          eyeColor: 'brown',
          faceShape: 'oval',
          gender: 'neutral',
          age: 30,
          ethnicity: 'mixed',
          accessories: [],
        );
    }
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

  Color _getEmotionColor() {
    switch (widget.emotion.toLowerCase()) {
      case 'happy':
      case 'hopeful':
        return Colors.green;
      case 'confused':
      case 'worried':
        return Colors.orange;
      case 'determined':
      case 'focused':
        return Colors.blue;
      case 'mysterious':
        return Colors.purple;
      case 'dramatic':
        return Colors.red;
      default:
        return Colors.cyan;
    }
  }

  Widget _buildHumanFace(CharacterFeatures features) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hair
        if (features.hairStyle != 'bald')
          _buildHair(features),
        
        // Face
        _buildFace(features),
        
        // Eyes
        _buildEyes(features),
        
        // Nose
        _buildNose(features),
        
        // Mouth
        _buildMouth(features),
        
        // Accessories
        ...features.accessories.map((accessory) => _buildAccessory(accessory)),
      ],
    );
  }

  Widget _buildHair(CharacterFeatures features) {
    return Positioned(
      top: widget.size * 0.1,
      child: Container(
        width: widget.size * 0.8,
        height: widget.size * 0.3,
        decoration: BoxDecoration(
          color: _getHairColor(features.hairColor),
          borderRadius: BorderRadius.circular(widget.size * 0.4),
        ),
      ),
    );
  }

  Widget _buildFace(CharacterFeatures features) {
    return Container(
      width: widget.size * 0.7,
      height: widget.size * 0.7,
      decoration: BoxDecoration(
        color: _getSkinColor(features.skinTone),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
          width: 1,
        ),
      ),
    );
  }

  Widget _buildEyes(CharacterFeatures features) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildEye(features),
        SizedBox(width: widget.size * 0.1),
        _buildEye(features),
      ],
    );
  }

  Widget _buildEye(CharacterFeatures features) {
    return Container(
      width: widget.size * 0.08,
      height: widget.size * 0.08,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Container(
          width: widget.size * 0.04,
          height: widget.size * 0.04,
          decoration: BoxDecoration(
            color: _getEyeColor(features.eyeColor),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildNose(CharacterFeatures features) {
    return Container(
      width: widget.size * 0.06,
      height: widget.size * 0.06,
      decoration: BoxDecoration(
        color: _getSkinColor(features.skinTone).withOpacity(0.8),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildMouth(CharacterFeatures features) {
    return Container(
      width: widget.size * 0.1,
      height: widget.size * 0.03,
      decoration: BoxDecoration(
        color: _getMouthColor(),
        borderRadius: BorderRadius.circular(widget.size * 0.015),
      ),
    );
  }

  Widget _buildAccessory(String accessory) {
    switch (accessory) {
      case 'beard':
        return Positioned(
          bottom: widget.size * 0.2,
          child: Container(
            width: widget.size * 0.3,
            height: widget.size * 0.05,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(widget.size * 0.025),
            ),
          ),
        );
      case 'glasses':
        return Positioned(
          top: widget.size * 0.3,
          child: Container(
            width: widget.size * 0.4,
            height: widget.size * 0.1,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(widget.size * 0.05),
            ),
          ),
        );
      case 'circuit_patterns':
        return Positioned(
          top: widget.size * 0.4,
          left: widget.size * 0.1,
          child: Container(
            width: widget.size * 0.1,
            height: 1,
            color: Colors.cyan.withOpacity(0.6),
          ),
        );
      default:
        return Container();
    }
  }

  Widget _buildEmotionIndicator() {
    return Container(
      width: widget.size * 0.15,
      height: widget.size * 0.15,
      decoration: BoxDecoration(
        color: _getEmotionColor(),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _getEmotionColor().withOpacity(0.6),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        _getEmotionIcon(),
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

  Color _getHairColor(String hairColor) {
    switch (hairColor.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'brown':
        return Colors.brown;
      case 'blonde':
        return Colors.yellow[300]!;
      case 'silver':
        return Colors.grey[400]!;
      case 'white':
        return Colors.white;
      default:
        return Colors.brown;
    }
  }

  Color _getSkinColor(String skinTone) {
    switch (skinTone.toLowerCase()) {
      case 'fair':
        return const Color(0xFFFDBCB4);
      case 'medium':
        return const Color(0xFFE8A87C);
      case 'dark':
        return const Color(0xFF8D5524);
      default:
        return const Color(0xFFE8A87C);
    }
  }

  Color _getEyeColor(String eyeColor) {
    switch (eyeColor.toLowerCase()) {
      case 'brown':
        return Colors.brown;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'cyan':
        return Colors.cyan;
      default:
        return Colors.brown;
    }
  }

  Color _getMouthColor() {
    switch (widget.emotion.toLowerCase()) {
      case 'happy':
      case 'hopeful':
        return Colors.red;
      case 'confused':
      case 'worried':
        return Colors.orange;
      default:
        return Colors.pink;
    }
  }

  IconData _getEmotionIcon() {
    switch (widget.emotion.toLowerCase()) {
      case 'happy':
      case 'hopeful':
        return Icons.sentiment_very_satisfied;
      case 'confused':
        return Icons.help_outline;
      case 'determined':
        return Icons.sentiment_very_satisfied;
      case 'mysterious':
        return Icons.visibility_off;
      case 'dramatic':
        return Icons.theater_comedy;
      default:
        return Icons.sentiment_neutral;
    }
  }
}

class _CustomCharacterWidget extends StatefulWidget {
  final String characterId;
  final CharacterFeatures features;
  final String emotion;
  final double size;
  final bool isActive;

  const _CustomCharacterWidget({
    required this.characterId,
    required this.features,
    required this.emotion,
    required this.size,
    required this.isActive,
  });

  @override
  State<_CustomCharacterWidget> createState() => _CustomCharacterWidgetState();
}

class _CustomCharacterWidgetState extends State<_CustomCharacterWidget> {
  @override
  Widget build(BuildContext context) {
    return CharacterGeneratorService.generateHumanCharacter(
      characterId: widget.characterId,
      emotion: widget.emotion,
      size: widget.size,
      isActive: widget.isActive,
    );
  }
}

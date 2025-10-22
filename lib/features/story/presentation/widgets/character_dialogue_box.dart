import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/voice_service.dart';
import '../../../../core/models/character.dart';
import '../../domain/entities/story_scene.dart';
import 'human_character_avatar.dart';

class CharacterDialogueBox extends StatefulWidget {
  final Dialogue dialogue;
  final VoidCallback? onTap;
  final bool isActive;

  const CharacterDialogueBox({
    super.key,
    required this.dialogue,
    this.onTap,
    this.isActive = false,
  });

  @override
  State<CharacterDialogueBox> createState() => _CharacterDialogueBoxState();
}

class _CharacterDialogueBoxState extends State<CharacterDialogueBox>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late AnimationController _characterController;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _characterAnimation;
  bool _hasSpoken = false;

  @override
  void initState() {
    super.initState();
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _characterController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _characterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _characterController,
      curve: Curves.elasticOut,
    ));

    // Trigger character animation
    _characterController.forward();

    // Auto-speak after a short delay
    if (widget.isActive) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !_hasSpoken) {
          _speakDialogue();
        }
      });
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    _characterController.dispose();
    super.dispose();
  }

  void _speakDialogue() {
    if (!_hasSpoken) {
      _hasSpoken = true;
      VoiceService.speak(widget.dialogue.text, character: widget.dialogue.speaker);
    }
  }

  Character get character => CharacterDatabase.getCharacter(widget.dialogue.speaker);

  String get emotion {
    // Determine emotion based on dialogue content
    final text = widget.dialogue.text.toLowerCase();
    if (text.contains('?')) return 'confused';
    if (text.contains('!')) return 'determined';
    if (text.contains('...')) return 'mysterious';
    if (text.contains('ready') || text.contains('excellent')) return 'hopeful';
    return 'neutral';
  }

  Color _getBorderColor() {
    return character.appearance.primaryColor;
  }

  Color _getBackgroundColor() {
    return character.appearance.primaryColor.withOpacity(0.1);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _getBorderColor();
    final backgroundColor = _getBackgroundColor();

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_glowAnimation, _pulseAnimation, _characterAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isActive ? _pulseAnimation.value : 1.0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: borderColor.withOpacity(_glowAnimation.value),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: borderColor.withOpacity(0.3 * _glowAnimation.value),
                    blurRadius: 15 * _glowAnimation.value,
                    spreadRadius: 2 * _glowAnimation.value,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Human Character Avatar
                  AnimatedBuilder(
                    animation: _characterAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _characterAnimation.value,
                        child: HumanCharacterAvatar(
                          characterId: widget.dialogue.speaker,
                          emotion: emotion,
                          size: 60,
                          isActive: widget.isActive,
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Dialogue Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Character name with personality
                        Row(
                          children: [
                            Icon(
                              _getSpeakerIcon(),
                              color: borderColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  widget.dialogue.speaker.toUpperCase(),
                                  textStyle: TextStyle(
                                    color: borderColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                  speed: const Duration(milliseconds: 100),
                                ),
                              ],
                              totalRepeatCount: 1,
                            ),
                            const SizedBox(width: 8),
                            // Character personality indicator
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: borderColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                character.personality.traits.first,
                                style: TextStyle(
                                  color: borderColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Character description
                        Text(
                          character.description,
                          style: TextStyle(
                            color: borderColor.withOpacity(0.7),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Dialogue text with typewriter effect
                        AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              widget.dialogue.text,
                              textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    height: 1.4,
                                  ),
                              speed: const Duration(milliseconds: 30),
                            ),
                          ],
                          totalRepeatCount: 1,
                          onFinished: () {
                            if (widget.isActive && !_hasSpoken) {
                              _speakDialogue();
                            }
                          },
                        ),
                        
                        // Character speaking style indicator
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.record_voice_over,
                              color: borderColor.withOpacity(0.5),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              character.personality.speakingStyle,
                              style: TextStyle(
                                color: borderColor.withOpacity(0.5),
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        
                        // Tap to continue hint
                        if (widget.onTap != null && widget.isActive)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.touch_app,
                                  color: borderColor.withOpacity(0.7),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Tap to continue',
                                  style: TextStyle(
                                    color: borderColor.withOpacity(0.7),
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getSpeakerIcon() {
    switch (widget.dialogue.speaker.toLowerCase()) {
      case 'echo':
        return Icons.smart_toy;
      case 'you':
        return Icons.person;
      case 'narrator':
        return Icons.auto_stories;
      case 'system':
        return Icons.info;
      default:
        return Icons.chat;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/voice_service.dart';
import '../../domain/entities/story_scene.dart';

class EnhancedDialogueBox extends StatefulWidget {
  final Dialogue dialogue;
  final VoidCallback? onTap;
  final bool isActive;

  const EnhancedDialogueBox({
    super.key,
    required this.dialogue,
    this.onTap,
    this.isActive = false,
  });

  @override
  State<EnhancedDialogueBox> createState() => _EnhancedDialogueBoxState();
}

class _EnhancedDialogueBoxState extends State<EnhancedDialogueBox>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;
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
    super.dispose();
  }

  void _speakDialogue() {
    if (!_hasSpoken) {
      _hasSpoken = true;
      VoiceService.speak(widget.dialogue.text, character: widget.dialogue.speaker);
    }
  }

  Color _getBorderColor() {
    switch (widget.dialogue.speaker.toLowerCase()) {
      case 'echo':
        return AppTheme.primaryCyan;
      case 'you':
        return AppTheme.accentGreen;
      case 'narrator':
        return AppTheme.primaryPurple;
      case 'system':
        return AppTheme.warningRed;
      default:
        return AppTheme.primaryCyan;
    }
  }

  Color _getBackgroundColor() {
    switch (widget.dialogue.speaker.toLowerCase()) {
      case 'echo':
        return AppTheme.primaryCyan.withOpacity(0.1);
      case 'you':
        return AppTheme.accentGreen.withOpacity(0.1);
      case 'narrator':
        return AppTheme.primaryPurple.withOpacity(0.1);
      case 'system':
        return AppTheme.warningRed.withOpacity(0.1);
      default:
        return AppTheme.primaryCyan.withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _getBorderColor();
    final backgroundColor = _getBackgroundColor();

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_glowAnimation, _pulseAnimation]),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Speaker name with animation
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
                    ],
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

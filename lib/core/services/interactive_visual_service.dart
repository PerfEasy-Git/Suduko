import 'package:flutter/material.dart';
import 'dart:math' as math;

class InteractiveVisualService {
  // Create interactive particle effects
  static Widget createInteractiveParticles({
    required VoidCallback onTap,
    required String effectType,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: InteractiveParticleField(
        effectType: effectType,
      ),
    );
  }

  // Create character animations
  static Widget createCharacterAnimation({
    required String character,
    required String emotion,
    required double size,
  }) {
    return CharacterAnimator(
      character: character,
      emotion: emotion,
      size: size,
    );
  }

  // Create interactive story elements
  static Widget createStoryElement({
    required String elementType,
    required VoidCallback onInteract,
    required String content,
  }) {
    switch (elementType.toLowerCase()) {
      case 'memory_fragment':
        return MemoryFragment(
          content: content,
          onTap: onInteract,
        );
      case 'data_stream':
        return DataStream(
          content: content,
          onTap: onInteract,
        );
      case 'nexus_core':
        return NexusCore(
          content: content,
          onTap: onInteract,
        );
      default:
        return InteractiveElement(
          content: content,
          onTap: onInteract,
        );
    }
  }
}

class InteractiveParticleField extends StatefulWidget {
  final String effectType;

  const InteractiveParticleField({
    super.key,
    required this.effectType,
  });

  @override
  State<InteractiveParticleField> createState() => _InteractiveParticleFieldState();
}

class _InteractiveParticleFieldState extends State<InteractiveParticleField>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _interactionController;
  List<InteractiveParticle> particles = [];
  bool _isInteracting = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _interactionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _initializeParticles();
  }

  void _initializeParticles() {
    final random = math.Random();
    particles = List.generate(30, (index) {
      return InteractiveParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        vx: (random.nextDouble() - 0.5) * 0.002,
        vy: (random.nextDouble() - 0.5) * 0.002,
        color: _getParticleColor(),
        size: random.nextDouble() * 4 + 2,
        opacity: random.nextDouble() * 0.8 + 0.2,
        isInteractive: random.nextBool(),
      );
    });
  }

  Color _getParticleColor() {
    switch (widget.effectType.toLowerCase()) {
      case 'awakening':
        return const Color(0xFF00FFFF);
      case 'puzzle':
        return const Color(0xFF8A2BE2);
      case 'completion':
        return const Color(0xFF00FF00);
      case 'discovery':
        return const Color(0xFFFF00FF);
      default:
        return const Color(0xFF00FFFF);
    }
  }

  void _onTap() {
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

  @override
  void dispose() {
    _controller.dispose();
    _interactionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_controller, _interactionController]),
        builder: (context, child) {
          return CustomPaint(
            painter: InteractiveParticlePainter(
              particles,
              _controller.value,
              _interactionController.value,
              _isInteracting,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class InteractiveParticle {
  double x, y, vx, vy;
  final Color color;
  final double size;
  final double opacity;
  final bool isInteractive;

  InteractiveParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.opacity,
    required this.isInteractive,
  });
}

class InteractiveParticlePainter extends CustomPainter {
  final List<InteractiveParticle> particles;
  final double animationValue;
  final double interactionValue;
  final bool isInteracting;

  InteractiveParticlePainter(
    this.particles,
    this.animationValue,
    this.interactionValue,
    this.isInteracting,
  );

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Update particle position
      particle.x += particle.vx;
      particle.y += particle.vy;

      // Wrap around screen
      if (particle.x < 0) particle.x = 1;
      if (particle.x > 1) particle.x = 0;
      if (particle.y < 0) particle.y = 1;
      if (particle.y > 1) particle.y = 0;

      // Interactive effects
      double currentSize = particle.size;
      double currentOpacity = particle.opacity;

      if (isInteracting && particle.isInteractive) {
        currentSize *= (1 + interactionValue * 2);
        currentOpacity *= (1 + interactionValue);
      }

      // Draw particle with glow effect
      final paint = Paint()
        ..color = particle.color.withOpacity(currentOpacity)
        ..style = PaintingStyle.fill;

      // Add glow effect
      final glowPaint = Paint()
        ..color = particle.color.withOpacity(currentOpacity * 0.3)
        ..style = PaintingStyle.fill;

      // Draw glow
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        currentSize * 2,
        glowPaint,
      );

      // Draw main particle
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        currentSize,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CharacterAnimator extends StatefulWidget {
  final String character;
  final String emotion;
  final double size;

  const CharacterAnimator({
    super.key,
    required this.character,
    required this.emotion,
    required this.size,
  });

  @override
  State<CharacterAnimator> createState() => _CharacterAnimatorState();
}

class _CharacterAnimatorState extends State<CharacterAnimator>
    with TickerProviderStateMixin {
  late AnimationController _idleController;
  late AnimationController _emotionController;
  late Animation<double> _idleAnimation;
  late Animation<double> _emotionAnimation;

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

    // Trigger emotion animation
    _emotionController.forward();
  }

  @override
  void dispose() {
    _idleController.dispose();
    _emotionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_idleAnimation, _emotionAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _idleAnimation.value * _emotionAnimation.value,
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
                  color: _getCharacterColors().first.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              _getCharacterIcon(),
              size: widget.size * 0.6,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  List<Color> _getCharacterColors() {
    switch (widget.character.toLowerCase()) {
      case 'echo':
        return [const Color(0xFF00FFFF), const Color(0xFF0080FF)];
      case 'you':
        return [const Color(0xFF00FF00), const Color(0xFF00AA00)];
      case 'narrator':
        return [const Color(0xFF8A2BE2), const Color(0xFF4B0082)];
      default:
        return [const Color(0xFF00FFFF), const Color(0xFF0080FF)];
    }
  }

  IconData _getCharacterIcon() {
    switch (widget.character.toLowerCase()) {
      case 'echo':
        return Icons.smart_toy;
      case 'you':
        return Icons.person;
      case 'narrator':
        return Icons.auto_stories;
      default:
        return Icons.chat;
    }
  }
}

class MemoryFragment extends StatefulWidget {
  final String content;
  final VoidCallback onTap;

  const MemoryFragment({
    super.key,
    required this.content,
    required this.onTap,
  });

  @override
  State<MemoryFragment> createState() => _MemoryFragmentState();
}

class _MemoryFragmentState extends State<MemoryFragment>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00FFFF), Color(0xFF0080FF)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FFFF).withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                widget.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DataStream extends StatefulWidget {
  final String content;
  final VoidCallback onTap;

  const DataStream({
    super.key,
    required this.content,
    required this.onTap,
  });

  @override
  State<DataStream> createState() => _DataStreamState();
}

class _DataStreamState extends State<DataStream>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF8A2BE2),
                  const Color(0xFF4B0082),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8A2BE2).withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.data_usage,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white.withOpacity(0.7),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NexusCore extends StatefulWidget {
  final String content;
  final VoidCallback onTap;

  const NexusCore({
    super.key,
    required this.content,
    required this.onTap,
  });

  @override
  State<NexusCore> createState() => _NexusCoreState();
}

class _NexusCoreState extends State<NexusCore>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF00FF),
                    const Color(0xFF8A2BE2),
                    const Color(0xFF4B0082),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF00FF).withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InteractiveElement extends StatefulWidget {
  final String content;
  final VoidCallback onTap;

  const InteractiveElement({
    super.key,
    required this.content,
    required this.onTap,
  });

  @override
  State<InteractiveElement> createState() => _InteractiveElementState();
}

class _InteractiveElementState extends State<InteractiveElement>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00FFFF), Color(0xFF0080FF)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FFFF).withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                widget.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

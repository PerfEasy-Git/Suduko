import 'package:flutter/material.dart';
import 'dart:math' as math;

class VisualService {
  static const List<Color> _particleColors = [
    Color(0xFF00FFFF), // Cyan
    Color(0xFF8A2BE2), // Purple
    Color(0xFF00FF00), // Green
    Color(0xFFFF00FF), // Magenta
  ];

  static Widget createAnimatedBackground({required String sceneType}) {
    switch (sceneType.toLowerCase()) {
      case 'awakening':
        return _createAwakeningBackground();
      case 'puzzle':
        return _createPuzzleBackground();
      case 'completion':
        return _createCompletionBackground();
      case 'discovery':
        return _createDiscoveryBackground();
      default:
        return _createDefaultBackground();
    }
  }

  static Widget _createAwakeningBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0A0A),
            Color(0xFF1A0A2E),
            Color(0xFF16213E),
          ],
        ),
      ),
      child: const ParticleField(
        particleCount: 50,
        speed: 0.5,
        colors: _particleColors,
      ),
    );
  }

  static Widget _createPuzzleBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F0F23),
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
          ],
        ),
      ),
      child: const ParticleField(
        particleCount: 30,
        speed: 0.3,
        colors: _particleColors,
      ),
    );
  }

  static Widget _createCompletionBackground() {
    return Container(
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
      child: const ParticleField(
        particleCount: 80,
        speed: 1.0,
        colors: [Color(0xFF00FF00), Color(0xFF00FFFF)],
      ),
    );
  }

  static Widget _createDiscoveryBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E1A4A),
            Color(0xFF4A2E6A),
            Color(0xFF6A4A8A),
          ],
        ),
      ),
      child: const ParticleField(
        particleCount: 60,
        speed: 0.7,
        colors: _particleColors,
      ),
    );
  }

  static Widget _createDefaultBackground() {
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
      child: const ParticleField(
        particleCount: 40,
        speed: 0.4,
        colors: _particleColors,
      ),
    );
  }
}

class ParticleField extends StatefulWidget {
  final int particleCount;
  final double speed;
  final List<Color> colors;

  const ParticleField({
    super.key,
    required this.particleCount,
    required this.speed,
    required this.colors,
  });

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _initializeParticles();
  }

  void _initializeParticles() {
    final random = math.Random();
    particles = List.generate(widget.particleCount, (index) {
      return Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        vx: (random.nextDouble() - 0.5) * widget.speed,
        vy: (random.nextDouble() - 0.5) * widget.speed,
        color: widget.colors[random.nextInt(widget.colors.length)],
        size: random.nextDouble() * 3 + 1,
        opacity: random.nextDouble() * 0.8 + 0.2,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(particles, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x, y, vx, vy;
  final Color color;
  final double size;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Update particle position
      particle.x += particle.vx * 0.01;
      particle.y += particle.vy * 0.01;

      // Wrap around screen
      if (particle.x < 0) particle.x = 1;
      if (particle.x > 1) particle.x = 0;
      if (particle.y < 0) particle.y = 1;
      if (particle.y > 1) particle.y = 0;

      // Draw particle
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

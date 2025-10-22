import 'package:flutter/material.dart';
import 'dart:math' as math;

class CinematicService {
  // Camera movement types
  static Widget createCinematicCamera({
    required Widget child,
    required CameraMovement movement,
    required AnimationController controller,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return _applyCameraMovement(child!, movement, controller.value);
      },
      child: child,
    );
  }

  static Widget _applyCameraMovement(Widget child, CameraMovement movement, double progress) {
    switch (movement.type) {
      case CameraType.zoomIn:
        return Transform.scale(
          scale: 1.0 + (movement.intensity * progress),
          child: child,
        );
      case CameraType.zoomOut:
        return Transform.scale(
          scale: 1.0 - (movement.intensity * progress),
          child: child,
        );
      case CameraType.panLeft:
        return Transform.translate(
          offset: Offset(-movement.intensity * progress * 100, 0),
          child: child,
        );
      case CameraType.panRight:
        return Transform.translate(
          offset: Offset(movement.intensity * progress * 100, 0),
          child: child,
        );
      case CameraType.tiltUp:
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(movement.intensity * progress * 0.1),
          child: child,
        );
      case CameraType.tiltDown:
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(-movement.intensity * progress * 0.1),
          child: child,
        );
      case CameraType.dollyIn:
        return Transform.scale(
          scale: 1.0 + (movement.intensity * progress * 0.5),
          child: Transform.translate(
            offset: Offset(0, -movement.intensity * progress * 50),
            child: child,
          ),
        );
      case CameraType.dollyOut:
        return Transform.scale(
          scale: 1.0 - (movement.intensity * progress * 0.3),
          child: Transform.translate(
            offset: Offset(0, movement.intensity * progress * 50),
            child: child,
          ),
        );
      case CameraType.orbit:
        return Transform.rotate(
          angle: movement.intensity * progress * 2 * math.pi,
          child: child,
        );
      default:
        return child;
    }
  }

  // Scene composition types
  static Widget createSceneComposition({
    required Widget child,
    required SceneComposition composition,
  }) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: _getSceneGradient(composition),
      ),
      child: Stack(
        children: [
          // Background atmosphere
          _createAtmosphere(composition),
          // Main content
          _positionContent(child, composition),
        ],
      ),
    );
  }

  static LinearGradient _getSceneGradient(SceneComposition composition) {
    switch (composition.mood) {
      case SceneMood.dramatic:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0A0A),
            Color(0xFF1A0A2E),
            Color(0xFF2E1A4A),
          ],
        );
      case SceneMood.mysterious:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F0F23),
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
          ],
        );
      case SceneMood.hopeful:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A2E0A),
            Color(0xFF1A4A1A),
            Color(0xFF2E5A2E),
          ],
        );
      case SceneMood.tension:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E0A0A),
            Color(0xFF4A1A1A),
            Color(0xFF5A2E2E),
          ],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0A0A),
            Color(0xFF1A1A2E),
          ],
        );
    }
  }

  static Widget _createAtmosphere(SceneComposition composition) {
    return Positioned.fill(
      child: CustomPaint(
        painter: AtmospherePainter(composition),
        size: Size.infinite,
      ),
    );
  }

  static Widget _positionContent(Widget child, SceneComposition composition) {
    switch (composition.framing) {
      case SceneFraming.wideShot:
        return Center(child: child);
      case SceneFraming.closeUp:
        return Center(
          child: Transform.scale(
            scale: 1.5,
            child: child,
          ),
        );
      case SceneFraming.extremeCloseUp:
        return Center(
          child: Transform.scale(
            scale: 2.0,
            child: child,
          ),
        );
      case SceneFraming.lowAngle:
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(0.1),
            child: child,
          ),
        );
      case SceneFraming.highAngle:
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(-0.1),
            child: child,
          ),
        );
      default:
        return Center(child: child);
    }
  }

  // Transition effects
  static Widget createTransition({
    required Widget child,
    required TransitionType type,
    required AnimationController controller,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return _applyTransition(child!, type, controller.value);
      },
      child: child,
    );
  }

  static Widget _applyTransition(Widget child, TransitionType type, double progress) {
    switch (type) {
      case TransitionType.fadeIn:
        return Opacity(
          opacity: progress,
          child: child,
        );
      case TransitionType.fadeOut:
        return Opacity(
          opacity: 1.0 - progress,
          child: child,
        );
      case TransitionType.slideInLeft:
        return Transform.translate(
          offset: Offset(-(1.0 - progress) * 300, 0),
          child: child,
        );
      case TransitionType.slideInRight:
        return Transform.translate(
          offset: Offset((1.0 - progress) * 300, 0),
          child: child,
        );
      case TransitionType.slideInUp:
        return Transform.translate(
          offset: Offset(0, -(1.0 - progress) * 300),
          child: child,
        );
      case TransitionType.slideInDown:
        return Transform.translate(
          offset: Offset(0, (1.0 - progress) * 300),
          child: child,
        );
      case TransitionType.zoomIn:
        return Transform.scale(
          scale: 0.5 + (progress * 0.5),
          child: child,
        );
      case TransitionType.zoomOut:
        return Transform.scale(
          scale: 1.5 - (progress * 0.5),
          child: child,
        );
      case TransitionType.spinIn:
        return Transform.rotate(
          angle: (1.0 - progress) * 2 * math.pi,
          child: child,
        );
      default:
        return child;
    }
  }
}

// Enums for cinematic elements
enum CameraType {
  zoomIn,
  zoomOut,
  panLeft,
  panRight,
  tiltUp,
  tiltDown,
  dollyIn,
  dollyOut,
  orbit,
}

enum SceneMood {
  dramatic,
  mysterious,
  hopeful,
  tension,
  peaceful,
}

enum SceneFraming {
  wideShot,
  closeUp,
  extremeCloseUp,
  lowAngle,
  highAngle,
  dutchAngle,
}

enum TransitionType {
  fadeIn,
  fadeOut,
  slideInLeft,
  slideInRight,
  slideInUp,
  slideInDown,
  zoomIn,
  zoomOut,
  spinIn,
  wipeLeft,
  wipeRight,
}

class CameraMovement {
  final CameraType type;
  final double intensity;
  final Duration duration;

  const CameraMovement({
    required this.type,
    required this.intensity,
    required this.duration,
  });
}

class SceneComposition {
  final SceneMood mood;
  final SceneFraming framing;
  final List<Color> accentColors;
  final double atmosphereIntensity;

  const SceneComposition({
    required this.mood,
    required this.framing,
    required this.accentColors,
    this.atmosphereIntensity = 1.0,
  });
}

class AtmospherePainter extends CustomPainter {
  final SceneComposition composition;

  AtmospherePainter(this.composition);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Create atmospheric particles
    final random = math.Random(42);
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3 + 1;
      final opacity = random.nextDouble() * 0.5 + 0.1;

      paint.color = composition.accentColors[
        random.nextInt(composition.accentColors.length)
      ].withOpacity(opacity * composition.atmosphereIntensity);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Create light rays or energy streams
    if (composition.mood == SceneMood.mysterious) {
      _drawEnergyStreams(canvas, size);
    } else if (composition.mood == SceneMood.dramatic) {
      _drawLightRays(canvas, size);
    }
  }

  void _drawEnergyStreams(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 5; i++) {
      final startX = (i * size.width / 5) + 50;
      final path = Path();
      path.moveTo(startX, 0);
      path.quadraticBezierTo(
        startX + 50,
        size.height / 2,
        startX,
        size.height,
      );
      canvas.drawPath(path, paint);
    }
  }

  void _drawLightRays(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 3; i++) {
      final startX = size.width / 4 + (i * size.width / 4);
      final path = Path();
      path.moveTo(startX, 0);
      path.lineTo(startX + 20, size.height);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

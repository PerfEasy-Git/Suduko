import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedMovieService {
  // Animated character movements
  static Widget createAnimatedCharacter({
    required Widget child,
    required CharacterAnimation animation,
    required AnimationController controller,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return _applyCharacterAnimation(child!, animation, controller.value);
      },
      child: child,
    );
  }

  static Widget _applyCharacterAnimation(Widget child, CharacterAnimation animation, double progress) {
    switch (animation.type) {
      case CharacterAnimationType.idle:
        return _createIdleAnimation(child, progress);
      case CharacterAnimationType.speaking:
        return _createSpeakingAnimation(child, progress);
      case CharacterAnimationType.gesturing:
        return _createGesturingAnimation(child, progress);
      case CharacterAnimationType.emotional:
        return _createEmotionalAnimation(child, progress);
      case CharacterAnimationType.entrance:
        return _createEntranceAnimation(child, progress);
      case CharacterAnimationType.exit:
        return _createExitAnimation(child, progress);
      default:
        return child;
    }
  }

  static Widget _createIdleAnimation(Widget child, double progress) {
    // Gentle breathing animation
    final breathe = math.sin(progress * 2 * math.pi) * 0.02;
    return Transform.scale(
      scale: 1.0 + breathe,
      child: child,
    );
  }

  static Widget _createSpeakingAnimation(Widget child, double progress) {
    // Mouth movement and slight head nod
    final mouthMovement = math.sin(progress * 8 * math.pi) * 0.05;
    final headNod = math.sin(progress * 4 * math.pi) * 0.02;
    
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translate(0.0, headNod)
        ..scale(1.0 + mouthMovement),
      child: child,
    );
  }

  static Widget _createGesturingAnimation(Widget child, double progress) {
    // Hand gestures and body movement
    final gesture = math.sin(progress * 3 * math.pi) * 0.1;
    final sway = math.sin(progress * 2 * math.pi) * 0.05;
    
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translate(gesture, sway)
        ..rotateZ(gesture * 0.1),
      child: child,
    );
  }

  static Widget _createEmotionalAnimation(Widget child, double progress) {
    // Emotional body language
    final emotion = math.sin(progress * 6 * math.pi) * 0.08;
    final intensity = math.sin(progress * 2 * math.pi) * 0.05;
    
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translate(0.0, emotion)
        ..scale(1.0 + intensity),
      child: child,
    );
  }

  static Widget _createEntranceAnimation(Widget child, double progress) {
    // Character entrance with dramatic effect
    final slideIn = Curves.easeOutCubic.transform(progress);
    final fadeIn = progress;
    final scaleIn = 0.5 + (progress * 0.5);
    
    return Transform.translate(
      offset: Offset(0, (1.0 - slideIn) * 200),
      child: Transform.scale(
        scale: scaleIn,
        child: Opacity(
          opacity: fadeIn,
          child: child,
        ),
      ),
    );
  }

  static Widget _createExitAnimation(Widget child, double progress) {
    // Character exit with dramatic effect
    final slideOut = Curves.easeInCubic.transform(progress);
    final fadeOut = 1.0 - progress;
    final scaleOut = 1.0 - (progress * 0.3);
    
    return Transform.translate(
      offset: Offset(0, slideOut * 200),
      child: Transform.scale(
        scale: scaleOut,
        child: Opacity(
          opacity: fadeOut,
          child: child,
        ),
      ),
    );
  }

  // Animated scene environments
  static Widget createAnimatedScene({
    required Widget child,
    required SceneEnvironment environment,
    required AnimationController controller,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return _applySceneAnimation(child!, environment, controller.value);
      },
      child: child,
    );
  }

  static Widget _applySceneAnimation(Widget child, SceneEnvironment environment, double progress) {
    switch (environment.type) {
      case SceneEnvironmentType.space:
        return _createSpaceEnvironment(child, progress);
      case SceneEnvironmentType.nexus:
        return _createNexusEnvironment(child, progress);
      case SceneEnvironmentType.memory:
        return _createMemoryEnvironment(child, progress);
      case SceneEnvironmentType.puzzle:
        return _createPuzzleEnvironment(child, progress);
      default:
        return child;
    }
  }

  static Widget _createSpaceEnvironment(Widget child, double progress) {
    return Stack(
      children: [
        // Animated starfield
        _createStarfield(progress),
        child,
      ],
    );
  }

  static Widget _createNexusEnvironment(Widget child, double progress) {
    return Stack(
      children: [
        // Animated data streams
        _createDataStreams(progress),
        // Animated core
        _createNexusCore(progress),
        child,
      ],
    );
  }

  static Widget _createMemoryEnvironment(Widget child, double progress) {
    return Stack(
      children: [
        // Animated memory fragments
        _createMemoryFragments(progress),
        child,
      ],
    );
  }

  static Widget _createPuzzleEnvironment(Widget child, double progress) {
    return Stack(
      children: [
        // Animated puzzle grid
        _createPuzzleGrid(progress),
        child,
      ],
    );
  }

  static Widget _createStarfield(double progress) {
    return CustomPaint(
      painter: StarfieldPainter(progress),
      size: Size.infinite,
    );
  }

  static Widget _createDataStreams(double progress) {
    return CustomPaint(
      painter: DataStreamPainter(progress),
      size: Size.infinite,
    );
  }

  static Widget _createNexusCore(double progress) {
    return CustomPaint(
      painter: NexusCorePainter(progress),
      size: Size.infinite,
    );
  }

  static Widget _createMemoryFragments(double progress) {
    return CustomPaint(
      painter: MemoryFragmentPainter(progress),
      size: Size.infinite,
    );
  }

  static Widget _createPuzzleGrid(double progress) {
    return CustomPaint(
      painter: PuzzleGridPainter(progress),
      size: Size.infinite,
    );
  }

  // Animated transitions between scenes
  static Widget createAnimatedTransition({
    required Widget child,
    required TransitionAnimation transition,
    required AnimationController controller,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return _applyTransitionAnimation(child!, transition, controller.value);
      },
      child: child,
    );
  }

  static Widget _applyTransitionAnimation(Widget child, TransitionAnimation transition, double progress) {
    switch (transition.type) {
      case TransitionAnimationType.dissolve:
        return _createDissolveTransition(child, progress);
      case TransitionAnimationType.wipe:
        return _createWipeTransition(child, progress);
      case TransitionAnimationType.iris:
        return _createIrisTransition(child, progress);
      case TransitionAnimationType.spiral:
        return _createSpiralTransition(child, progress);
      default:
        return child;
    }
  }

  static Widget _createDissolveTransition(Widget child, double progress) {
    return Opacity(
      opacity: progress,
      child: child,
    );
  }

  static Widget _createWipeTransition(Widget child, double progress) {
    return ClipRect(
      child: Align(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: child,
      ),
    );
  }

  static Widget _createIrisTransition(Widget child, double progress) {
    return ClipOval(
      child: Transform.scale(
        scale: progress * 2,
        child: child,
      ),
    );
  }

  static Widget _createSpiralTransition(Widget child, double progress) {
    return Transform.rotate(
      angle: progress * 2 * math.pi,
      child: Transform.scale(
        scale: progress,
        child: child,
      ),
    );
  }
}

// Enums for animated movie elements
enum CharacterAnimationType {
  idle,
  speaking,
  gesturing,
  emotional,
  entrance,
  exit,
}

enum SceneEnvironmentType {
  space,
  nexus,
  memory,
  puzzle,
}

enum TransitionAnimationType {
  dissolve,
  wipe,
  iris,
  spiral,
}

class CharacterAnimation {
  final CharacterAnimationType type;
  final double intensity;
  final Duration duration;

  const CharacterAnimation({
    required this.type,
    required this.intensity,
    required this.duration,
  });
}

class SceneEnvironment {
  final SceneEnvironmentType type;
  final List<Color> colors;
  final double intensity;

  const SceneEnvironment({
    required this.type,
    required this.colors,
    required this.intensity,
  });
}

class TransitionAnimation {
  final TransitionAnimationType type;
  final Duration duration;

  const TransitionAnimation({
    required this.type,
    required this.duration,
  });
}

// Custom painters for animated environments
class StarfieldPainter extends CustomPainter {
  final double animationValue;

  StarfieldPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);

    for (int i = 0; i < 200; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() * size.height + animationValue * 100) % size.height;
      final radius = random.nextDouble() * 2 + 0.5;
      final opacity = random.nextDouble() * 0.8 + 0.2;
      
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DataStreamPainter extends CustomPainter {
  final double animationValue;

  DataStreamPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 10; i++) {
      final x = (i * size.width / 10) + 50;
      final path = Path();
      path.moveTo(x, 0);
      path.quadraticBezierTo(
        x + 50,
        size.height / 2,
        x,
        size.height,
      );
      
      paint.color = Colors.cyan.withOpacity(0.6);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NexusCorePainter extends CustomPainter {
  final double animationValue;

  NexusCorePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Rotating core
    final rotation = animationValue * 2 * math.pi;
    final coreRadius = 50 + math.sin(animationValue * 4 * math.pi) * 10;
    
    paint.color = Colors.purple.withOpacity(0.8);
    canvas.drawCircle(center, coreRadius, paint);
    
    // Energy rings
    for (int i = 0; i < 3; i++) {
      final ringRadius = 80.0 + i * 30.0;
      paint.color = Colors.cyan.withOpacity(0.3);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 2;
      canvas.drawCircle(center, ringRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MemoryFragmentPainter extends CustomPainter {
  final double animationValue;

  MemoryFragmentPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 3 + math.sin(animationValue * 2 * math.pi + i) * 2;
      final opacity = 0.3 + math.sin(animationValue * 3 * math.pi + i) * 0.3;
      
      paint.color = Colors.green.withOpacity(opacity);
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

    // Animated grid lines
    final gridSize = 30;
    for (int i = 0; i <= size.width / gridSize; i++) {
      final x = i * gridSize.toDouble();
      final opacity = 0.3 + math.sin(animationValue * 2 * math.pi + i) * 0.2;
      paint.color = Colors.cyan.withOpacity(opacity);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    for (int i = 0; i <= size.height / gridSize; i++) {
      final y = i * gridSize.toDouble();
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

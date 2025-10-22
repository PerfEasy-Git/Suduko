import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/cinematic_service.dart';
import '../../../../core/services/voice_service.dart';

class MovieOpeningScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const MovieOpeningScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<MovieOpeningScreen> createState() => _MovieOpeningScreenState();
}

class _MovieOpeningScreenState extends State<MovieOpeningScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _zoomController;
  late AnimationController _particleController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _zoomAnimation;
  late Animation<double> _particleAnimation;

  int _currentSequence = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _zoomController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _zoomAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _zoomController,
      curve: Curves.easeOutCubic,
    ));

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.linear,
    ));

    _startOpeningSequence();
  }

  void _startOpeningSequence() async {
    setState(() {
      _isPlaying = true;
    });

    // Sequence 1: Fade in with particles
    _fadeController.forward();
    _particleController.forward();
    await Future.delayed(const Duration(seconds: 3));

    // Sequence 2: Title slide in
    _currentSequence = 1;
    setState(() {});
    _slideController.forward();
    await Future.delayed(const Duration(seconds: 2));

    // Sequence 3: Zoom and dramatic effect
    _currentSequence = 2;
    setState(() {});
    _zoomController.forward();
    await Future.delayed(const Duration(seconds: 3));

    // Sequence 4: Final sequence
    _currentSequence = 3;
    setState(() {});
    await Future.delayed(const Duration(seconds: 2));

    // Complete
    widget.onComplete();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _zoomController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Cinematic background
          _buildCinematicBackground(),
          
          // Particle effects
          _buildParticleEffects(),
          
          // Opening sequences
          _buildOpeningSequences(),
        ],
      ),
    );
  }

  Widget _buildCinematicBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0A0A),
            Color(0xFF1A0A2E),
            Color(0xFF2E1A4A),
            Color(0xFF0A0A0A),
          ],
        ),
      ),
    );
  }

  Widget _buildParticleEffects() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: OpeningParticlePainter(_particleAnimation.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildOpeningSequences() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _fadeAnimation,
        _slideAnimation,
        _zoomAnimation,
      ]),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value * 100),
            child: Transform.scale(
              scale: _zoomAnimation.value,
              child: _getCurrentSequence(),
            ),
          ),
        );
      },
    );
  }

  Widget _getCurrentSequence() {
    switch (_currentSequence) {
      case 0:
        return _buildSequence1();
      case 1:
        return _buildSequence2();
      case 2:
        return _buildSequence3();
      case 3:
        return _buildSequence4();
      default:
        return _buildSequence1();
    }
  }

  Widget _buildSequence1() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Studio logo
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [AppTheme.primaryCyan, AppTheme.primaryPurple],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryCyan.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.movie,
              color: Colors.white,
              size: 60,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'NEXUS STUDIOS',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.primaryCyan,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSequence2() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main title
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'STORYDOKU',
                textStyle: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppTheme.primaryCyan,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6,
                    ),
                speed: const Duration(milliseconds: 200),
              ),
            ],
            totalRepeatCount: 1,
          ),
          const SizedBox(height: 20),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'CODE BREAKERS',
                textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryPurple,
                      fontSize: 24,
                      letterSpacing: 3,
                    ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            totalRepeatCount: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildSequence3() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tagline
          AnimatedTextKit(
            animatedTexts: [
              FadeAnimatedText(
                'Decrypt the grid.',
                textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                    ),
                duration: const Duration(seconds: 2),
              ),
              FadeAnimatedText(
                'Restore the memories.',
                textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryCyan,
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                    ),
                duration: const Duration(seconds: 2),
              ),
            ],
            totalRepeatCount: 1,
          ),
          const SizedBox(height: 40),
          // Character preview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCharacterPreview('ECHO', AppTheme.primaryCyan),
              _buildCharacterPreview('YOU', AppTheme.accentGreen),
              _buildCharacterPreview('NEXUS', AppTheme.primaryPurple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSequence4() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Final message
          AnimatedTextKit(
            animatedTexts: [
              FadeAnimatedText(
                'A Story-Driven Sudoku Adventure',
                textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                      fontSize: 18,
                      letterSpacing: 2,
                    ),
                duration: const Duration(seconds: 3),
              ),
            ],
            totalRepeatCount: 1,
          ),
          const SizedBox(height: 20),
          // Loading indicator
          Container(
            width: 200,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Container(
                  width: 200 * _fadeAnimation.value,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryCyan, AppTheme.primaryPurple],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterPreview(String name, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color, color.withOpacity(0.3)],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class OpeningParticlePainter extends CustomPainter {
  final double animationValue;

  OpeningParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final random = math.Random(42);
    
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 1;
      final opacity = (random.nextDouble() * 0.8 + 0.2) * animationValue;
      
      final colors = [
        AppTheme.primaryCyan,
        AppTheme.primaryPurple,
        AppTheme.accentGreen,
      ];
      
      paint.color = colors[random.nextInt(colors.length)].withOpacity(opacity);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

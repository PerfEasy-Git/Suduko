import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CinematicVideoService {
  // Cinematic video types
  static Widget createCinematicScene({
    required String sceneType,
    required String videoPath,
    required double width,
    required double height,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return _CinematicVideoWidget(
      sceneType: sceneType,
      videoPath: videoPath,
      width: width,
      height: height,
      isActive: isActive,
      onTap: onTap,
    );
  }

  // Create cinematic intro sequence
  static Widget createCinematicIntro({
    required String chapterTitle,
    required String sceneDescription,
    required VoidCallback onComplete,
  }) {
    return _CinematicIntroWidget(
      chapterTitle: chapterTitle,
      sceneDescription: sceneDescription,
      onComplete: onComplete,
    );
  }

  // Create cinematic transition
  static Widget createCinematicTransition({
    required String transitionType,
    required Widget child,
    required Duration duration,
  }) {
    return _CinematicTransitionWidget(
      transitionType: transitionType,
      child: child,
      duration: duration,
    );
  }
}

class _CinematicVideoWidget extends StatefulWidget {
  final String sceneType;
  final String videoPath;
  final double width;
  final double height;
  final bool isActive;
  final VoidCallback? onTap;

  const _CinematicVideoWidget({
    required this.sceneType,
    required this.videoPath,
    required this.width,
    required this.height,
    required this.isActive,
    this.onTap,
  });

  @override
  State<_CinematicVideoWidget> createState() => _CinematicVideoWidgetState();
}

class _CinematicVideoWidgetState extends State<_CinematicVideoWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
      
      if (widget.isActive) {
        _controller.play();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildFallbackScene();
    }

    if (!_isInitialized) {
      return _buildLoadingScene();
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }

  Widget _buildFallbackScene() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: _getSceneGradient(),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _getSceneColor().withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getSceneIcon(),
              color: Colors.white,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              _getSceneTitle(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getSceneDescription(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScene() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: _getSceneGradient(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  LinearGradient _getSceneGradient() {
    switch (widget.sceneType.toLowerCase()) {
      case 'awakening':
        return const LinearGradient(
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'puzzle':
        return const LinearGradient(
          colors: [Color(0xFF0f3460), Color(0xFF0a1929)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'memory':
        return const LinearGradient(
          colors: [Color(0xFF2d1b69), Color(0xFF11052c)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  Color _getSceneColor() {
    switch (widget.sceneType.toLowerCase()) {
      case 'awakening':
        return const Color(0xFF00FFFF);
      case 'puzzle':
        return const Color(0xFF00FF00);
      case 'memory':
        return const Color(0xFF8A2BE2);
      default:
        return const Color(0xFF00FFFF);
    }
  }

  IconData _getSceneIcon() {
    switch (widget.sceneType.toLowerCase()) {
      case 'awakening':
        return Icons.visibility;
      case 'puzzle':
        return Icons.grid_on;
      case 'memory':
        return Icons.psychology;
      default:
        return Icons.movie;
    }
  }

  String _getSceneTitle() {
    switch (widget.sceneType.toLowerCase()) {
      case 'awakening':
        return 'AWAKENING';
      case 'puzzle':
        return 'PUZZLE';
      case 'memory':
        return 'MEMORY';
      default:
        return 'SCENE';
    }
  }

  String _getSceneDescription() {
    switch (widget.sceneType.toLowerCase()) {
      case 'awakening':
        return 'You awaken in a world of fragments...';
      case 'puzzle':
        return 'Decrypt the pattern, restore the memories...';
      case 'memory':
        return 'The first memory returns...';
      default:
        return 'Cinematic scene loading...';
    }
  }
}

class _CinematicIntroWidget extends StatefulWidget {
  final String chapterTitle;
  final String sceneDescription;
  final VoidCallback onComplete;

  const _CinematicIntroWidget({
    required this.chapterTitle,
    required this.sceneDescription,
    required this.onComplete,
  });

  @override
  State<_CinematicIntroWidget> createState() => _CinematicIntroWidgetState();
}

class _CinematicIntroWidgetState extends State<_CinematicIntroWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _startIntro();
  }

  void _startIntro() async {
    await _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 1000));
    await _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 2000));
    widget.onComplete();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Animated background particles
          _buildAnimatedBackground(),
          
          // Title sequence
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      widget.chapterTitle.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    widget.sceneDescription,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return CustomPaint(
          painter: _CinematicBackgroundPainter(_fadeController.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _CinematicTransitionWidget extends StatefulWidget {
  final String transitionType;
  final Widget child;
  final Duration duration;

  const _CinematicTransitionWidget({
    required this.transitionType,
    required this.child,
    required this.duration,
  });

  @override
  State<_CinematicTransitionWidget> createState() => _CinematicTransitionWidgetState();
}

class _CinematicTransitionWidgetState extends State<_CinematicTransitionWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.transitionType.toLowerCase()) {
      case 'fade':
        return FadeTransition(
          opacity: _animation,
          child: widget.child,
        );
      case 'slide':
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(_animation),
          child: widget.child,
        );
      case 'scale':
        return ScaleTransition(
          scale: _animation,
          child: widget.child,
        );
      default:
        return widget.child;
    }
  }
}

class _CinematicBackgroundPainter extends CustomPainter {
  final double animationValue;

  _CinematicBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withOpacity(0.3 * animationValue);

    // Draw animated particles
    for (int i = 0; i < 50; i++) {
      final x = (i * size.width / 50) + (animationValue * 100);
      final y = size.height * 0.3 + (i * 10);
      final radius = 2.0 + (animationValue * 3.0);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

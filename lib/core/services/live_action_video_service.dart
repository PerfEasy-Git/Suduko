import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LiveActionVideoService {
  // Live-action video types
  static Widget createLiveActionScene({
    required String sceneId,
    required String videoPath,
    required double width,
    required double height,
    required bool isActive,
    VoidCallback? onComplete,
    VoidCallback? onTap,
  }) {
    return _LiveActionVideoWidget(
      sceneId: sceneId,
      videoPath: videoPath,
      width: width,
      height: height,
      isActive: isActive,
      onComplete: onComplete,
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

  // Create interactive story flow
  static Widget createInteractiveStoryFlow({
    required List<String> videoPaths,
    required List<String> sceneTypes,
    required VoidCallback onPuzzleTrigger,
    required VoidCallback onChoiceTrigger,
  }) {
    return _InteractiveStoryFlowWidget(
      videoPaths: videoPaths,
      sceneTypes: sceneTypes,
      onPuzzleTrigger: onPuzzleTrigger,
      onChoiceTrigger: onChoiceTrigger,
    );
  }
}

class _LiveActionVideoWidget extends StatefulWidget {
  final String sceneId;
  final String videoPath;
  final double width;
  final double height;
  final bool isActive;
  final VoidCallback? onComplete;
  final VoidCallback? onTap;

  const _LiveActionVideoWidget({
    required this.sceneId,
    required this.videoPath,
    required this.width,
    required this.height,
    required this.isActive,
    this.onComplete,
    this.onTap,
  });

  @override
  State<_LiveActionVideoWidget> createState() => _LiveActionVideoWidgetState();
}

class _LiveActionVideoWidgetState extends State<_LiveActionVideoWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isPlaying = false;

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
      
      // Auto-play when active
      if (widget.isActive) {
        _playVideo();
      }
      
      // Listen for video completion
      _controller.addListener(_onVideoStateChanged);
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  void _onVideoStateChanged() {
    if (_controller.value.position >= _controller.value.duration) {
      // Video completed
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    }
  }

  void _playVideo() {
    if (_controller.value.isInitialized) {
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _pauseVideo() {
    if (_controller.value.isInitialized) {
      _controller.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoStateChanged);
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
          child: Stack(
            children: [
              // Video player
              VideoPlayer(_controller),
              
              // Play/Pause overlay
              if (!_isPlaying)
                Center(
                  child: GestureDetector(
                    onTap: _playVideo,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              
              // Scene info overlay
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getSceneTitle(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              // Progress indicator
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: LinearProgressIndicator(
                    value: _controller.value.position.inMilliseconds / 
                           _controller.value.duration.inMilliseconds,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
                  ),
                ),
              ),
            ],
          ),
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: _getSceneColor(),
                foregroundColor: Colors.white,
              ),
              child: const Text('Continue'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'Loading cinematic scene...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getSceneGradient() {
    switch (widget.sceneId.toLowerCase()) {
      case 'awakening':
        return const LinearGradient(
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'contact':
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
    switch (widget.sceneId.toLowerCase()) {
      case 'awakening':
        return const Color(0xFF00FFFF);
      case 'contact':
        return const Color(0xFF00FF00);
      case 'memory':
        return const Color(0xFF8A2BE2);
      default:
        return const Color(0xFF00FFFF);
    }
  }

  IconData _getSceneIcon() {
    switch (widget.sceneId.toLowerCase()) {
      case 'awakening':
        return Icons.visibility;
      case 'contact':
        return Icons.contact_support;
      case 'memory':
        return Icons.psychology;
      default:
        return Icons.movie;
    }
  }

  String _getSceneTitle() {
    switch (widget.sceneId.toLowerCase()) {
      case 'awakening':
        return 'AWAKENING';
      case 'contact':
        return 'FIRST CONTACT';
      case 'memory':
        return 'MEMORY REVEAL';
      default:
        return 'LIVE ACTION';
    }
  }

  String _getSceneDescription() {
    switch (widget.sceneId.toLowerCase()) {
      case 'awakening':
        return 'ECHO awakens you from stasis...';
      case 'contact':
        return 'First contact with the system...';
      case 'memory':
        return 'Dr. Chen\'s memory returns...';
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
          painter: _LiveActionBackgroundPainter(_fadeController.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _InteractiveStoryFlowWidget extends StatefulWidget {
  final List<String> videoPaths;
  final List<String> sceneTypes;
  final VoidCallback onPuzzleTrigger;
  final VoidCallback onChoiceTrigger;

  const _InteractiveStoryFlowWidget({
    required this.videoPaths,
    required this.sceneTypes,
    required this.onPuzzleTrigger,
    required this.onChoiceTrigger,
  });

  @override
  State<_InteractiveStoryFlowWidget> createState() => _InteractiveStoryFlowWidgetState();
}

class _InteractiveStoryFlowWidgetState extends State<_InteractiveStoryFlowWidget> {
  int _currentSceneIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LiveActionVideoService.createLiveActionScene(
      sceneId: widget.sceneTypes[_currentSceneIndex],
      videoPath: widget.videoPaths[_currentSceneIndex],
      width: double.infinity,
      height: 300,
      isActive: true,
      onComplete: _nextScene,
    );
  }

  void _nextScene() {
    if (_currentSceneIndex < widget.videoPaths.length - 1) {
      setState(() {
        _currentSceneIndex++;
      });
    } else {
      // End of story flow
      widget.onChoiceTrigger();
    }
  }
}

class _LiveActionBackgroundPainter extends CustomPainter {
  final double animationValue;

  _LiveActionBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withOpacity(0.3 * animationValue);

    // Draw cinematic particles
    for (int i = 0; i < 100; i++) {
      final x = (i * size.width / 100) + (animationValue * 200);
      final y = size.height * 0.2 + (i * 5);
      final radius = 1.0 + (animationValue * 2.0);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

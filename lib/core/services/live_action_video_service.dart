import 'package:flutter/material.dart';

class LiveActionVideoService {
  // Live-action video types
  static Widget createLiveActionScene({
    required String sceneId,
    required String videoPath,
    required double width,
    required double height,
    VoidCallback? onComplete,
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    return _LiveActionVideoWidget(
      videoPath: videoPath,
      width: width,
      height: height,
      onComplete: onComplete,
      onTap: onTap,
    );
  }

  static Widget createCinematicIntro({
    double width = 400,
    double height = 300,
    VoidCallback? onComplete,
    String? chapterTitle,
    String? sceneDescription,
  }) {
    return createLiveActionScene(
      sceneId: 'cinematic_intro',
      videoPath: 'assets/live_action/default_scene.mp4',
      width: width,
      height: height,
      onComplete: onComplete,
    );
  }

  static Widget createAwakeningScene({
    required double width,
    required double height,
    VoidCallback? onComplete,
  }) {
    return createLiveActionScene(
      sceneId: 'awakening',
      videoPath: 'assets/live_action/awakening_scene.mp4',
      width: width,
      height: height,
      onComplete: onComplete,
    );
  }

  static Widget createContactScene({
    required double width,
    required double height,
    VoidCallback? onComplete,
  }) {
    return createLiveActionScene(
      sceneId: 'contact',
      videoPath: 'assets/live_action/contact_scene.mp4',
      width: width,
      height: height,
      onComplete: onComplete,
    );
  }

  static Widget createMemoryScene({
    required double width,
    required double height,
    VoidCallback? onComplete,
  }) {
    return createLiveActionScene(
      sceneId: 'memory',
      videoPath: 'assets/live_action/memory_scene.mp4',
      width: width,
      height: height,
      onComplete: onComplete,
    );
  }

  static Widget createMemoryRevealScene({
    required double width,
    required double height,
    VoidCallback? onComplete,
  }) {
    return createLiveActionScene(
      sceneId: 'memory_reveal',
      videoPath: 'assets/live_action/memory_reveal.mp4',
      width: width,
      height: height,
      onComplete: onComplete,
    );
  }

  static Widget createDefaultScene({
    required double width,
    required double height,
    VoidCallback? onComplete,
  }) {
    return createLiveActionScene(
      sceneId: 'default',
      videoPath: 'assets/live_action/default_scene.mp4',
      width: width,
      height: height,
      onComplete: onComplete,
    );
  }
}

class _LiveActionVideoWidget extends StatefulWidget {
  final String videoPath;
  final double width;
  final double height;
  final VoidCallback? onComplete;
  final VoidCallback? onTap;

  const _LiveActionVideoWidget({
    required this.videoPath,
    required this.width,
    required this.height,
    this.onComplete,
    this.onTap,
  });

  @override
  State<_LiveActionVideoWidget> createState() => _LiveActionVideoWidgetState();
}

class _LiveActionVideoWidgetState extends State<_LiveActionVideoWidget> {
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // Stub implementation - Video functionality disabled
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Video initialization failed: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorWidget();
    }

    if (!_isInitialized) {
      return _buildLoadingWidget();
    }

    return _buildVideoWidget();
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'Video not available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              '(Video functionality disabled)',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Video Player',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Video: ${widget.videoPath.split('/').last}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '(Video functionality disabled)',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                widget.onTap?.call();
                widget.onComplete?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
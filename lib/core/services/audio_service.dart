import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static AudioPlayer? _backgroundMusicPlayer;
  static AudioPlayer? _soundEffectPlayer;
  static bool _isInitialized = false;
  static bool _isMusicEnabled = true;
  static bool _isSoundEnabled = true;

  static Future<void> init() async {
    if (_isInitialized) return;

    _backgroundMusicPlayer = AudioPlayer();
    _soundEffectPlayer = AudioPlayer();
    
    // Set volume levels
    await _backgroundMusicPlayer!.setVolume(0.3); // Lower volume for background
    await _soundEffectPlayer!.setVolume(0.7); // Higher volume for effects
    
    _isInitialized = true;
  }

  // Background Music
  static Future<void> playBackgroundMusic(String musicPath) async {
    if (!_isMusicEnabled || !_isInitialized) return;
    
    try {
      await _backgroundMusicPlayer!.stop();
      await _backgroundMusicPlayer!.play(AssetSource(musicPath));
      await _backgroundMusicPlayer!.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  static Future<void> stopBackgroundMusic() async {
    if (_isInitialized) {
      await _backgroundMusicPlayer!.stop();
    }
  }

  static Future<void> pauseBackgroundMusic() async {
    if (_isInitialized) {
      await _backgroundMusicPlayer!.pause();
    }
  }

  static Future<void> resumeBackgroundMusic() async {
    if (_isInitialized) {
      await _backgroundMusicPlayer!.resume();
    }
  }

  // Sound Effects
  static Future<void> playSoundEffect(String soundPath) async {
    if (!_isSoundEnabled || !_isInitialized) return;
    
    try {
      await _soundEffectPlayer!.play(AssetSource(soundPath));
    } catch (e) {
      print('Error playing sound effect: $e');
    }
  }

  // Character-specific sounds
  static Future<void> playCharacterSound(String character) async {
    switch (character.toLowerCase()) {
      case 'echo':
        await playSoundEffect('audio/sfx/echo_voice.mp3');
        break;
      case 'you':
        await playSoundEffect('audio/sfx/you_voice.mp3');
        break;
      case 'narrator':
        await playSoundEffect('audio/sfx/narrator_voice.mp3');
        break;
      case 'system':
        await playSoundEffect('audio/sfx/system_voice.mp3');
        break;
      default:
        await playSoundEffect('audio/sfx/default_voice.mp3');
    }
  }

  // Scene-specific music
  static Future<void> playSceneMusic(String sceneType) async {
    switch (sceneType.toLowerCase()) {
      case 'awakening':
        await playBackgroundMusic('audio/music/awakening_theme.mp3');
        break;
      case 'contact':
        await playBackgroundMusic('audio/music/contact_theme.mp3');
        break;
      case 'memory':
        await playBackgroundMusic('audio/music/memory_theme.mp3');
        break;
      case 'puzzle':
        await playBackgroundMusic('audio/music/puzzle_theme.mp3');
        break;
      default:
        await playBackgroundMusic('audio/music/default_theme.mp3');
    }
  }

  // Puzzle-specific sounds
  static Future<void> playPuzzleSound(String soundType) async {
    switch (soundType.toLowerCase()) {
      case 'cell_fill':
        await playSoundEffect('audio/sfx/cell_fill.mp3');
        break;
      case 'cell_clear':
        await playSoundEffect('audio/sfx/cell_clear.mp3');
        break;
      case 'puzzle_complete':
        await playSoundEffect('audio/sfx/puzzle_complete.mp3');
        break;
      case 'puzzle_hint':
        await playSoundEffect('audio/sfx/puzzle_hint.mp3');
        break;
      case 'error':
        await playSoundEffect('audio/sfx/error.mp3');
        break;
      default:
        await playSoundEffect('audio/sfx/default.mp3');
    }
  }

  // Transition sounds
  static Future<void> playTransitionSound(String transitionType) async {
    switch (transitionType.toLowerCase()) {
      case 'fade_in':
        await playSoundEffect('audio/sfx/fade_in.mp3');
        break;
      case 'fade_out':
        await playSoundEffect('audio/sfx/fade_out.mp3');
        break;
      case 'scene_change':
        await playSoundEffect('audio/sfx/scene_change.mp3');
        break;
      case 'video_start':
        await playSoundEffect('audio/sfx/video_start.mp3');
        break;
      default:
        await playSoundEffect('audio/sfx/transition.mp3');
    }
  }

  // Settings
  static void setMusicEnabled(bool enabled) {
    _isMusicEnabled = enabled;
    if (!enabled) {
      stopBackgroundMusic();
    }
  }

  static void setSoundEnabled(bool enabled) {
    _isSoundEnabled = enabled;
  }

  static bool get isMusicEnabled => _isMusicEnabled;
  static bool get isSoundEnabled => _isSoundEnabled;

  // Cleanup
  static Future<void> dispose() async {
    if (_isInitialized) {
      await _backgroundMusicPlayer!.dispose();
      await _soundEffectPlayer!.dispose();
      _isInitialized = false;
    }
  }
}

// Audio configuration for different scenes
class AudioConfig {
  final String backgroundMusic;
  final String ambientSound;
  final double musicVolume;
  final double soundVolume;

  const AudioConfig({
    required this.backgroundMusic,
    required this.ambientSound,
    this.musicVolume = 0.3,
    this.soundVolume = 0.7,
  });
}

// Predefined audio configurations for scenes
class SceneAudioConfigs {
  static const AudioConfig awakening = AudioConfig(
    backgroundMusic: 'audio/music/awakening_theme.mp3',
    ambientSound: 'audio/sfx/awakening_ambient.mp3',
    musicVolume: 0.2,
    soundVolume: 0.8,
  );

  static const AudioConfig contact = AudioConfig(
    backgroundMusic: 'audio/music/contact_theme.mp3',
    ambientSound: 'audio/sfx/contact_ambient.mp3',
    musicVolume: 0.3,
    soundVolume: 0.7,
  );

  static const AudioConfig memory = AudioConfig(
    backgroundMusic: 'audio/music/memory_theme.mp3',
    ambientSound: 'audio/sfx/memory_ambient.mp3',
    musicVolume: 0.4,
    soundVolume: 0.6,
  );

  static const AudioConfig puzzle = AudioConfig(
    backgroundMusic: 'audio/music/puzzle_theme.mp3',
    ambientSound: 'audio/sfx/puzzle_ambient.mp3',
    musicVolume: 0.2,
    soundVolume: 0.9,
  );
}

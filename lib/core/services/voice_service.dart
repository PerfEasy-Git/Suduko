import 'package:flutter/material.dart';

class VoiceService {
  static bool _isInitialized = false;
  static bool _isEnabled = true;

  static Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      // Stub implementation - TTS functionality disabled
      _isInitialized = true;
    } catch (e) {
      debugPrint('VoiceService initialization failed: $e');
    }
  }

  static Future<void> speak(String text, {String? character}) async {
    if (!_isEnabled || !_isInitialized) return;
    
    try {
      // Stub implementation - TTS functionality disabled
      debugPrint('TTS (disabled): $text${character != null ? ' [$character]' : ''}');
    } catch (e) {
      debugPrint('VoiceService speak failed: $e');
    }
  }

  static Future<void> stop() async {
    if (!_isInitialized) return;
    
    try {
      // Stub implementation - TTS functionality disabled
    } catch (e) {
      debugPrint('VoiceService stop failed: $e');
    }
  }

  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  static bool get isEnabled => _isEnabled;
  static bool get isInitialized => _isInitialized;
}
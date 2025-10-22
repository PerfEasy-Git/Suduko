import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  static FlutterTts? _flutterTts;
  static bool _isInitialized = false;
  static bool _isEnabled = true;

  static Future<void> init() async {
    if (_isInitialized) return;
    
    _flutterTts = FlutterTts();
    
    // Get available voices
    final voices = await _flutterTts!.getVoices;
    
    // Try to find a more human-sounding voice
    String? humanVoice;
    if (voices != null) {
      // Look for high-quality, human-sounding voices
      for (var voice in voices) {
        final voiceName = voice['name']?.toString().toLowerCase() ?? '';
        if (voiceName.contains('neural') || 
            voiceName.contains('premium') || 
            voiceName.contains('enhanced') ||
            voiceName.contains('natural')) {
          humanVoice = voice['name'];
          break;
        }
      }
    }
    
    // Set language and voice
    await _flutterTts!.setLanguage("en-US");
    if (humanVoice != null) {
      await _flutterTts!.setVoice({"name": humanVoice, "locale": "en-US"});
    }
    
    // More human-like settings
    await _flutterTts!.setSpeechRate(0.6); // More natural pace
    await _flutterTts!.setVolume(0.9);
    await _flutterTts!.setPitch(1.1); // Slightly higher for warmth
    
    _isInitialized = true;
  }

  static Future<void> speak(String text, {String? character}) async {
    if (!_isEnabled || !_isInitialized) return;
    
    // Stop any current speech
    await _flutterTts!.stop();
    
    // Adjust voice based on character for more human-like experience
    if (character != null) {
      switch (character.toLowerCase()) {
        case 'echo':
          // ECHO: Mysterious but human-like AI voice
          await _flutterTts!.setPitch(0.9); // Slightly deeper, but not robotic
          await _flutterTts!.setSpeechRate(0.55); // Thoughtful pace
          await _flutterTts!.setVolume(0.85);
          break;
        case 'you':
          // You: Warm, human protagonist voice
          await _flutterTts!.setPitch(1.15); // Warm and natural
          await _flutterTts!.setSpeechRate(0.65); // Conversational pace
          await _flutterTts!.setVolume(0.9);
          break;
        case 'narrator':
          // Narrator: Rich, storytelling voice
          await _flutterTts!.setPitch(1.05); // Slightly deeper for gravitas
          await _flutterTts!.setSpeechRate(0.6); // Storytelling pace
          await _flutterTts!.setVolume(0.9);
          break;
        case 'system':
          // System: Clear, informative voice
          await _flutterTts!.setPitch(1.0); // Neutral and clear
          await _flutterTts!.setSpeechRate(0.7); // Slightly faster for info
          await _flutterTts!.setVolume(0.8);
          break;
        default:
          // Default: Natural human voice
          await _flutterTts!.setPitch(1.1);
          await _flutterTts!.setSpeechRate(0.6);
          await _flutterTts!.setVolume(0.9);
      }
    }
    
    // Preprocess text for more natural speech
    String processedText = _preprocessTextForSpeech(text, character);
    await _flutterTts!.speak(processedText);
  }

  static Future<void> stop() async {
    if (_isInitialized) {
      await _flutterTts!.stop();
    }
  }

  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  static bool get isEnabled => _isEnabled;

  // Preprocess text for more natural, human-like speech
  static String _preprocessTextForSpeech(String text, String? character) {
    String processed = text;
    
    // Add natural pauses and emphasis
    processed = processed.replaceAll('...', '... '); // Pause for ellipses
    processed = processed.replaceAll('!', '! '); // Pause for exclamations
    processed = processed.replaceAll('?', '? '); // Pause for questions
    processed = processed.replaceAll('.', '. '); // Pause for periods
    processed = processed.replaceAll(',', ', '); // Brief pause for commas
    
    // Add character-specific speech patterns
    if (character != null) {
      switch (character.toLowerCase()) {
        case 'echo':
          // ECHO: Add mysterious pauses and emphasis
          processed = processed.replaceAll('The Nexus', 'The... Nexus');
          processed = processed.replaceAll('data', 'data...');
          break;
        case 'you':
          // You: Add natural hesitation and emotion
          processed = processed.replaceAll('Where', 'Where...');
          processed = processed.replaceAll('I can', 'I... I can');
          break;
        case 'narrator':
          // Narrator: Add dramatic pauses
          processed = processed.replaceAll('memory', 'memory...');
          processed = processed.replaceAll('world', 'world...');
          break;
      }
    }
    
    // Clean up multiple spaces
    processed = processed.replaceAll(RegExp(r'\s+'), ' ');
    
    return processed.trim();
  }
}

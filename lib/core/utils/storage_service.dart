import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save game progress
  static Future<bool> saveGameState(String puzzleId, String gridData) async {
    if (_prefs == null) await init();
    return await _prefs!.setString('game_$puzzleId', gridData);
  }

  // Load game state
  static String? loadGameState(String puzzleId) {
    return _prefs?.getString('game_$puzzleId');
  }

  // Save user stats
  static Future<bool> saveStat(String key, int value) async {
    if (_prefs == null) await init();
    return await _prefs!.setInt('stat_$key', value);
  }

  // Get user stat
  static int getStat(String key) {
    return _prefs?.getInt('stat_$key') ?? 0;
  }

  // Increment stat
  static Future<void> incrementStat(String key) async {
    final current = getStat(key);
    await saveStat(key, current + 1);
  }

  // Save settings
  static Future<bool> saveSetting(String key, bool value) async {
    if (_prefs == null) await init();
    return await _prefs!.setBool('setting_$key', value);
  }

  // Get setting
  static bool getSetting(String key, {bool defaultValue = true}) {
    return _prefs?.getBool('setting_$key') ?? defaultValue;
  }

  // Clear all data
  static Future<bool> clearAll() async {
    if (_prefs == null) await init();
    return await _prefs!.clear();
  }

  // Story Progress
  static Future<bool> saveStoryProgress(Map<String, dynamic> progress) async {
    if (_prefs == null) await init();
    return await _prefs!.setString('story_progress', jsonEncode(progress));
  }

  static Map<String, dynamic>? getStoryProgress() {
    final progressString = _prefs?.getString('story_progress');
    if (progressString != null) {
      return jsonDecode(progressString) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<bool> clearStoryProgress() async {
    if (_prefs == null) await init();
    return await _prefs!.remove('story_progress');
  }
}

// Common stat keys
class StatKeys {
  static const String totalGamesPlayed = 'total_games_played';
  static const String totalGamesCompleted = 'total_games_completed';
  static const String easyCompleted = 'easy_completed';
  static const String mediumCompleted = 'medium_completed';
  static const String hardCompleted = 'hard_completed';
  static const String expertCompleted = 'expert_completed';
  static const String totalHintsUsed = 'total_hints_used';
  static const String totalMistakes = 'total_mistakes';
}

// Settings keys
class SettingsKeys {
  static const String soundEnabled = 'sound_enabled';
  static const String musicEnabled = 'music_enabled';
  static const String vibrationEnabled = 'vibration_enabled';
}


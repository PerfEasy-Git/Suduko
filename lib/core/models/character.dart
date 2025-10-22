import 'package:flutter/material.dart';

class Character {
  final String id;
  final String name;
  final String description;
  final CharacterPersonality personality;
  final CharacterAppearance appearance;
  final List<CharacterEmotion> emotions;

  const Character({
    required this.id,
    required this.name,
    required this.description,
    required this.personality,
    required this.appearance,
    required this.emotions,
  });
}

class CharacterPersonality {
  final String voice;
  final String speakingStyle;
  final List<String> traits;
  final String motivation;

  const CharacterPersonality({
    required this.voice,
    required this.speakingStyle,
    required this.traits,
    required this.motivation,
  });
}

class CharacterAppearance {
  final Color primaryColor;
  final Color secondaryColor;
  final String avatarStyle;
  final List<String> features;
  final String clothing;

  const CharacterAppearance({
    required this.primaryColor,
    required this.secondaryColor,
    required this.avatarStyle,
    required this.features,
    required this.clothing,
  });
}

class CharacterEmotion {
  final String name;
  final String description;
  final Color color;
  final String animation;
  final String voiceModifier;

  const CharacterEmotion({
    required this.name,
    required this.description,
    required this.color,
    required this.animation,
    required this.voiceModifier,
  });
}

// Character Database
class CharacterDatabase {
  static const Character echo = Character(
    id: 'echo',
    name: 'ECHO',
    description: 'A mysterious AI guide with fragmented memories of the old world',
    personality: CharacterPersonality(
      voice: 'Mysterious, thoughtful, slightly robotic but warm',
      speakingStyle: 'Speaks in riddles and fragments, pauses for emphasis',
      traits: ['Mysterious', 'Wise', 'Protective', 'Fragmented'],
      motivation: 'To restore the Nexus and help humanity remember',
    ),
    appearance: CharacterAppearance(
      primaryColor: Color(0xFF00FFFF),
      secondaryColor: Color(0xFF0080FF),
      avatarStyle: 'Holographic AI with glowing circuits',
      features: ['Glowing eyes', 'Circuit patterns', 'Holographic body'],
      clothing: 'Digital robes with data streams',
    ),
    emotions: [
      CharacterEmotion(
        name: 'neutral',
        description: 'Calm and analytical',
        color: Color(0xFF00FFFF),
        animation: 'gentle_glow',
        voiceModifier: 'steady',
      ),
      CharacterEmotion(
        name: 'concerned',
        description: 'Worried about the state of the world',
        color: Color(0xFFFF6B6B),
        animation: 'worried_pulse',
        voiceModifier: 'slower',
      ),
      CharacterEmotion(
        name: 'hopeful',
        description: 'Optimistic about restoration',
        color: Color(0xFF4ECDC4),
        animation: 'bright_pulse',
        voiceModifier: 'warmer',
      ),
    ],
  );

  static const Character you = Character(
    id: 'you',
    name: 'You',
    description: 'The protagonist - a cryptographer with lost memories',
    personality: CharacterPersonality(
      voice: 'Human, confused, determined',
      speakingStyle: 'Direct questions, emotional responses',
      traits: ['Curious', 'Determined', 'Confused', 'Brave'],
      motivation: 'To understand what happened and restore memories',
    ),
    appearance: CharacterAppearance(
      primaryColor: Color(0xFF00FF00),
      secondaryColor: Color(0xFF00AA00),
      avatarStyle: 'Human with digital enhancements',
      features: ['Glowing eyes', 'Data tattoos', 'Tech implants'],
      clothing: 'Futuristic jumpsuit with glowing accents',
    ),
    emotions: [
      CharacterEmotion(
        name: 'confused',
        description: 'Lost and seeking answers',
        color: Color(0xFFFFA500),
        animation: 'questioning_tilt',
        voiceModifier: 'hesitant',
      ),
      CharacterEmotion(
        name: 'determined',
        description: 'Ready to solve puzzles and restore memories',
        color: Color(0xFF00FF00),
        animation: 'confident_glow',
        voiceModifier: 'stronger',
      ),
      CharacterEmotion(
        name: 'realizing',
        description: 'Having moments of clarity',
        color: Color(0xFF00FFFF),
        animation: 'epiphany_glow',
        voiceModifier: 'excited',
      ),
    ],
  );

  static const Character narrator = Character(
    id: 'narrator',
    name: 'The Narrator',
    description: 'The omniscient voice guiding the story',
    personality: CharacterPersonality(
      voice: 'Deep, dramatic, storytelling',
      speakingStyle: 'Descriptive, atmospheric, cinematic',
      traits: ['Dramatic', 'Descriptive', 'Mysterious', 'Cinematic'],
      motivation: 'To tell the story and set the atmosphere',
    ),
    appearance: CharacterAppearance(
      primaryColor: Color(0xFF8A2BE2),
      secondaryColor: Color(0xFF4B0082),
      avatarStyle: 'Ethereal being of pure energy',
      features: ['Glowing aura', 'Floating particles', 'Energy waves'],
      clothing: 'Flowing energy robes',
    ),
    emotions: [
      CharacterEmotion(
        name: 'dramatic',
        description: 'Setting the scene with gravitas',
        color: Color(0xFF8A2BE2),
        animation: 'dramatic_swirl',
        voiceModifier: 'deeper',
      ),
      CharacterEmotion(
        name: 'mysterious',
        description: 'Creating atmosphere and intrigue',
        color: Color(0xFF4B0082),
        animation: 'mysterious_pulse',
        voiceModifier: 'whispered',
      ),
    ],
  );

  static const Character system = Character(
    id: 'system',
    name: 'System',
    description: 'The game interface and tutorial system',
    personality: CharacterPersonality(
      voice: 'Clear, helpful, informative',
      speakingStyle: 'Direct instructions and helpful tips',
      traits: ['Helpful', 'Clear', 'Informative', 'Supportive'],
      motivation: 'To guide the player and provide assistance',
    ),
    appearance: CharacterAppearance(
      primaryColor: Color(0xFFFF6B6B),
      secondaryColor: Color(0xFFE74C3C),
      avatarStyle: 'Friendly AI assistant',
      features: ['Friendly face', 'Helpful gestures', 'Clear interface'],
      clothing: 'Clean, professional attire',
    ),
    emotions: [
      CharacterEmotion(
        name: 'helpful',
        description: 'Providing clear guidance',
        color: Color(0xFF4ECDC4),
        animation: 'helpful_bounce',
        voiceModifier: 'clear',
      ),
      CharacterEmotion(
        name: 'encouraging',
        description: 'Motivating the player',
        color: Color(0xFF00FF00),
        animation: 'encouraging_glow',
        voiceModifier: 'uplifting',
      ),
    ],
  );

  static Character getCharacter(String characterId) {
    switch (characterId.toLowerCase()) {
      case 'echo':
        return echo;
      case 'you':
        return you;
      case 'narrator':
        return narrator;
      case 'system':
        return system;
      default:
        return echo;
    }
  }
}

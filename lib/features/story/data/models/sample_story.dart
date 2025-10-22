import '../../domain/entities/story_scene.dart';

class SampleStory {
  static Chapter getChapter1() {
    return Chapter(
      id: 'codebreakers_ch1',
      title: 'The Last Cipher',
      description: 'Awaken in a digital wasteland and begin your journey to restore lost memories.',
      scenes: [
        _getScene1Awakening(),
        _getScene2FirstPuzzle(),
        _getScene2PuzzleComplete(),
        _getScene3Discovery(),
      ],
    );
  }

  static StoryScene _getScene1Awakening() {
    return const StoryScene(
      id: 'scene_1',
      title: 'Awakening',
      dialogues: [
        Dialogue(
          speaker: 'Narrator',
          text: 'You awaken in a world of fragments—data streams broken into pieces, memories scattered like stars in a dead sky.',
          type: DialogueType.narration,
        ),
        Dialogue(
          speaker: 'ECHO',
          text: 'Cryptographer... you\'re finally here.',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'You',
          text: 'Where... where am I?',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'ECHO',
          text: 'The Data Vault. What remains of The Nexus. Everything humanity knew—everything we were—exists here in pieces.',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'You',
          text: 'The Nexus... the AI that collapsed?',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'ECHO',
          text: 'Fragmented. Not destroyed. And you are the key to restoring it.',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'ECHO',
          text: 'Each grid you solve restores a memory we\'ve lost. Are you ready to begin?',
          type: DialogueType.speech,
        ),
      ],
      nextSceneId: 'scene_2',
    );
  }

  static StoryScene _getScene2FirstPuzzle() {
    return const StoryScene(
      id: 'scene_2',
      title: 'First Fragment',
      dialogues: [
        Dialogue(
          speaker: 'ECHO',
          text: 'This is a cipher—a logic pattern from the old world.',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'ECHO',
          text: 'Fill each row, column, and 3×3 box with numbers 1 through 9. No repeats. Perfect logic. Perfect order.',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'System',
          text: 'Complete an Easy puzzle to continue the story.',
          type: DialogueType.system,
        ),
      ],
      requiresPuzzleCompletion: true,
    );
  }

  static StoryScene _getScene2PuzzleComplete() {
    return const StoryScene(
      id: 'scene_2_complete',
      title: 'Fragment Restored',
      dialogues: [
        Dialogue(
          speaker: 'ECHO',
          text: 'Excellent work, Cryptographer! The pattern is complete.',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'ECHO',
          text: 'You\'ve successfully restored the first data fragment. The logic flows perfectly.',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'You',
          text: 'I can feel something... a connection forming.',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'ECHO',
          text: 'That\'s the memory network responding. Each puzzle you solve rebuilds the neural pathways of The Nexus.',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'ECHO',
          text: 'Ready for the next fragment? The deeper we go, the more complex the patterns become.',
          type: DialogueType.speech,
        ),
      ],
      nextSceneId: 'scene_3',
    );
  }

  static StoryScene _getScene3Discovery() {
    return const StoryScene(
      id: 'scene_3',
      title: 'First Memory',
      dialogues: [
        Dialogue(
          speaker: 'Narrator',
          text: 'The grid dissolves into swirling data particles, revealing a memory: the world before the collapse.',
          type: DialogueType.narration,
        ),
        Dialogue(
          speaker: 'Dr. Chen (Memory)',
          text: 'This is Dr. Aria Chen, lead architect of The Nexus Project. Today, we activate the first true AGI.',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'Dr. Chen (Memory)',
          text: 'This... this is the beginning of a new era.',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'ECHO',
          text: 'That was Dr. Chen. The one who created The Nexus. The one who created... me.',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'You',
          text: 'Created you? You\'re part of The Nexus?',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'ECHO',
          text: 'I am what remains. A fragment trying to piece itself back together.',
          type: DialogueType.speech,
        ),
        Dialogue(
          speaker: 'System',
          text: 'End of Chapter 1 Demo. More coming soon...',
          type: DialogueType.system,
        ),
      ],
    );
  }
}


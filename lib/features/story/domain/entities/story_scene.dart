class StoryScene {
  final String id;
  final String title;
  final List<Dialogue> dialogues;
  final String? nextSceneId;
  final bool requiresPuzzleCompletion;

  const StoryScene({
    required this.id,
    required this.title,
    required this.dialogues,
    this.nextSceneId,
    this.requiresPuzzleCompletion = false,
  });
}

class Dialogue {
  final String speaker;
  final String text;
  final DialogueType type;

  const Dialogue({
    required this.speaker,
    required this.text,
    this.type = DialogueType.speech,
  });
}

enum DialogueType {
  narration,
  speech,
  system,
}

class Chapter {
  final String id;
  final String title;
  final String description;
  final List<StoryScene> scenes;

  const Chapter({
    required this.id,
    required this.title,
    required this.description,
    required this.scenes,
  });
}


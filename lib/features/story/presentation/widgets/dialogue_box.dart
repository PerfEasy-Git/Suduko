import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/story_scene.dart';

class DialogueBox extends StatelessWidget {
  final Dialogue dialogue;
  final VoidCallback? onTap;

  const DialogueBox({
    super.key,
    required this.dialogue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color speakerColor;
    switch (dialogue.type) {
      case DialogueType.narration:
        speakerColor = AppTheme.primaryPurple;
        break;
      case DialogueType.system:
        speakerColor = AppTheme.accentGreen;
        break;
      case DialogueType.speech:
      default:
        speakerColor = _getSpeakerColor(dialogue.speaker);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: speakerColor.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: speakerColor.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dialogue.type != DialogueType.narration) ...[
              Text(
                dialogue.speaker.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: speakerColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              dialogue.text,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: dialogue.type == DialogueType.narration
                    ? Colors.white.withOpacity(0.9)
                    : Colors.white,
                fontStyle: dialogue.type == DialogueType.narration
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSpeakerColor(String speaker) {
    if (speaker.toLowerCase().contains('echo')) {
      return AppTheme.primaryCyan;
    } else if (speaker.toLowerCase().contains('you')) {
      return AppTheme.accentGreen;
    } else if (speaker.toLowerCase().contains('chen')) {
      return AppTheme.primaryPurple;
    } else {
      return AppTheme.primaryCyan;
    }
  }
}


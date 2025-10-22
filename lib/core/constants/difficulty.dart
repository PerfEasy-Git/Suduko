enum Difficulty {
  easy,
  medium,
  hard,
  expert;

  String get displayName {
    switch (this) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
      case Difficulty.expert:
        return 'Expert';
    }
  }

  String get description {
    switch (this) {
      case Difficulty.easy:
        return '40-45 clues • Perfect for beginners';
      case Difficulty.medium:
        return '30-35 clues • Moderate challenge';
      case Difficulty.hard:
        return '24-28 clues • Advanced techniques';
      case Difficulty.expert:
        return '20-23 clues • Master level';
    }
  }

  int get minClues {
    switch (this) {
      case Difficulty.easy:
        return 40;
      case Difficulty.medium:
        return 30;
      case Difficulty.hard:
        return 24;
      case Difficulty.expert:
        return 20;
    }
  }

  int get maxClues {
    switch (this) {
      case Difficulty.easy:
        return 45;
      case Difficulty.medium:
        return 35;
      case Difficulty.hard:
        return 28;
      case Difficulty.expert:
        return 23;
    }
  }
}


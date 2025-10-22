import '../../../../core/constants/difficulty.dart';

class Puzzle {
  final String id;
  final List<List<int>> grid;
  final List<List<int>> solution;
  final Difficulty difficulty;
  final int clueCount;
  final DateTime createdAt;

  Puzzle({
    required this.id,
    required this.grid,
    required this.solution,
    required this.difficulty,
    required this.clueCount,
    required this.createdAt,
  });

  // Deep copy of grid
  List<List<int>> copyGrid() {
    return grid.map((row) => List<int>.from(row)).toList();
  }

  // Check if a cell is a fixed clue (original puzzle cell)
  bool isFixedCell(int row, int col) {
    return grid[row][col] != 0;
  }

  // Check if puzzle is complete
  bool isComplete() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (grid[i][j] == 0) return false;
      }
    }
    return true;
  }
}


import 'dart:math';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/difficulty.dart';
import '../../domain/entities/puzzle.dart';

class SudokuGenerator {
  final Random _random = Random();
  final Uuid _uuid = const Uuid();

  /// Generate a complete Sudoku puzzle with specified difficulty
  Puzzle generate(Difficulty difficulty) {
    // Step 1: Generate a complete valid solution
    final solution = _generateCompleteSolution();
    
    // Step 2: Create puzzle by removing numbers based on difficulty
    final grid = _createPuzzleFromSolution(solution, difficulty);
    
    // Step 3: Count clues
    int clueCount = 0;
    for (var row in grid) {
      clueCount += row.where((cell) => cell != 0).length;
    }
    
    return Puzzle(
      id: _uuid.v4(),
      grid: grid,
      solution: solution,
      difficulty: difficulty,
      clueCount: clueCount,
      createdAt: DateTime.now(),
    );
  }

  /// Generate a complete valid 9x9 Sudoku solution using backtracking
  List<List<int>> _generateCompleteSolution() {
    List<List<int>> grid = List.generate(9, (_) => List.filled(9, 0));
    _fillGrid(grid);
    return grid;
  }

  /// Fill grid using backtracking algorithm with randomization
  bool _fillGrid(List<List<int>> grid) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == 0) {
          // Get numbers 1-9 in random order
          List<int> numbers = List.generate(9, (i) => i + 1);
          numbers.shuffle(_random);
          
          for (int num in numbers) {
            if (isValidPlacement(grid, row, col, num)) {
              grid[row][col] = num;
              
              if (_fillGrid(grid)) {
                return true;
              }
              
              // Backtrack
              grid[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true; // Grid is complete
  }

  /// Check if a number can be placed at the given position
  bool isValidPlacement(List<List<int>> grid, int row, int col, int num) {
    // Check row
    for (int x = 0; x < 9; x++) {
      if (grid[row][x] == num) return false;
    }
    
    // Check column
    for (int x = 0; x < 9; x++) {
      if (grid[x][col] == num) return false;
    }
    
    // Check 3x3 box
    int boxRow = (row ~/ 3) * 3;
    int boxCol = (col ~/ 3) * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[boxRow + i][boxCol + j] == num) return false;
      }
    }
    
    return true;
  }

  /// Create puzzle by removing numbers from complete solution
  List<List<int>> _createPuzzleFromSolution(
    List<List<int>> solution,
    Difficulty difficulty,
  ) {
    // Deep copy the solution
    List<List<int>> grid = solution.map((row) => List<int>.from(row)).toList();
    
    // Calculate how many cells to remove
    int totalCells = 81;
    int targetClues = difficulty.minClues + 
        _random.nextInt(difficulty.maxClues - difficulty.minClues + 1);
    int cellsToRemove = totalCells - targetClues;
    
    // Remove cells with symmetry pattern for aesthetic appeal
    List<List<int>> positions = [];
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        positions.add([i, j]);
      }
    }
    positions.shuffle(_random);
    
    int removed = 0;
    for (var pos in positions) {
      if (removed >= cellsToRemove) break;
      
      int row = pos[0];
      int col = pos[1];
      
      if (grid[row][col] != 0) {
        grid[row][col] = 0;
        removed++;
        
        // Apply rotational symmetry for better aesthetics
        int symRow = 8 - row;
        int symCol = 8 - col;
        if (grid[symRow][symCol] != 0 && removed < cellsToRemove) {
          grid[symRow][symCol] = 0;
          removed++;
        }
      }
    }
    
    return grid;
  }

  /// Validate if a move is correct (for hints/validation)
  bool validateMove(Puzzle puzzle, int row, int col, int value) {
    return puzzle.solution[row][col] == value;
  }

  /// Get a hint for the current puzzle state
  List<int>? getHint(List<List<int>> currentGrid, List<List<int>> solution) {
    List<List<int>> emptyCells = [];
    
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (currentGrid[i][j] == 0) {
          emptyCells.add([i, j]);
        }
      }
    }
    
    if (emptyCells.isEmpty) return null;
    
    // Return a random empty cell's solution
    emptyCells.shuffle(_random);
    int row = emptyCells[0][0];
    int col = emptyCells[0][1];
    int value = solution[row][col];
    
    return [row, col, value];
  }
}


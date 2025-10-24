import 'package:flutter/material.dart';
import '../../../../core/constants/difficulty.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/services/sudoku_generator.dart';
import '../../domain/entities/puzzle.dart';
import '../widgets/sudoku_grid.dart';
import '../widgets/number_pad.dart';
import '../widgets/game_controls.dart';

class GameScreen extends StatefulWidget {
  final Difficulty difficulty;
  final SudokuGenerator generator;

  const GameScreen({
    super.key,
    required this.difficulty,
    required this.generator,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Puzzle puzzle;
  late List<List<int>> currentGrid;
  int? selectedRow;
  int? selectedCol;
  int mistakes = 0;
  int hintsUsed = 0;
  bool isComplete = false;
  
  // Move history for undo
  List<Map<String, int>> moveHistory = [];

  @override
  void initState() {
    super.initState();
    _generateNewPuzzle();
  }

  void _generateNewPuzzle() {
    puzzle = widget.generator.generate(widget.difficulty);
    currentGrid = puzzle.copyGrid();
    selectedRow = null;
    selectedCol = null;
    mistakes = 0;
    hintsUsed = 0;
    isComplete = false;
    moveHistory = [];
  }

  void _onCellTap(int row, int col) {
    if (puzzle.isFixedCell(row, col)) {
      // Can't select fixed cells
      return;
    }
    
    setState(() {
      if (selectedRow == row && selectedCol == col) {
        // Deselect if tapping same cell
        selectedRow = null;
        selectedCol = null;
      } else {
        selectedRow = row;
        selectedCol = col;
      }
    });
  }

  void _onNumberSelected(int number) {
    if (selectedRow == null || selectedCol == null) return;
    if (puzzle.isFixedCell(selectedRow!, selectedCol!)) return;

    setState(() {
      // Save move for undo
      moveHistory.add({
        'row': selectedRow!,
        'col': selectedCol!,
        'oldValue': currentGrid[selectedRow!][selectedCol!],
      });

      // Place number
      currentGrid[selectedRow!][selectedCol!] = number;

      // Validate move
      if (!widget.generator.validateMove(puzzle, selectedRow!, selectedCol!, number)) {
        mistakes++;
      }

      // Check if puzzle is complete
      _checkCompletion();
    });
  }

  void _onClearCell() {
    if (selectedRow == null || selectedCol == null) return;
    if (puzzle.isFixedCell(selectedRow!, selectedCol!)) return;

    setState(() {
      moveHistory.add({
        'row': selectedRow!,
        'col': selectedCol!,
        'oldValue': currentGrid[selectedRow!][selectedCol!],
      });
      currentGrid[selectedRow!][selectedCol!] = 0;
    });
  }

  void _onUndo() {
    if (moveHistory.isEmpty) return;

    setState(() {
      final lastMove = moveHistory.removeLast();
      currentGrid[lastMove['row']!][lastMove['col']!] = lastMove['oldValue']!;
    });
  }

  void _onHint() {
    final hint = widget.generator.getHint(currentGrid, puzzle.solution);
    if (hint == null) return;

    setState(() {
      hintsUsed++;
      currentGrid[hint[0]][hint[1]] = hint[2];
      selectedRow = hint[0];
      selectedCol = hint[1];
      _checkCompletion();
    });

    // Auto-deselect after a moment
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          selectedRow = null;
          selectedCol = null;
        });
      }
    });
  }

  void _checkCompletion() {
    bool gridFilled = true;
    bool allCorrect = true;

    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (currentGrid[i][j] == 0) {
          gridFilled = false;
        } else if (currentGrid[i][j] != puzzle.solution[i][j]) {
          allCorrect = false;
        }
      }
    }

    if (gridFilled && allCorrect) {
      isComplete = true;
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceWhite,
        title: Text(
          'PUZZLE COMPLETE!',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.accentEmerald,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Difficulty: ${widget.difficulty.displayName}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Mistakes: $mistakes',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Hints Used: $hintsUsed',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('HOME'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _generateNewPuzzle();
              });
            },
            child: const Text('NEW PUZZLE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWarmIvory,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sudoku by Perfeasy Games',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primarySaffron,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Proudly Indian',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.primarySaffron,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                widget.difficulty.displayName.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.secondaryNavy,
                    ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Stats bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('MISTAKES', mistakes.toString(), AppTheme.warningRed),
                  _buildStat('HINTS', hintsUsed.toString(), AppTheme.primarySaffron),
                  _buildStat('CLUES', puzzle.clueCount.toString(), AppTheme.accentEmerald),
                ],
              ),
            ),
            
            
            // Sudoku Grid
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: SudokuGrid(
                    currentGrid: currentGrid,
                    solution: puzzle.solution,
                    fixedCells: puzzle.grid,
                    selectedRow: selectedRow,
                    selectedCol: selectedCol,
                    onCellTap: _onCellTap,
                  ),
                ),
              ),
            ),
            
            // Game Controls
            GameControls(
              onUndo: moveHistory.isNotEmpty ? _onUndo : null,
              onHint: _onHint,
              onClear: (selectedRow != null && selectedCol != null) ? _onClearCell : null,
            ),
            
            const SizedBox(height: 8),
            
            // Number Pad
            NumberPad(
              onNumberSelected: (selectedRow != null && selectedCol != null) ? _onNumberSelected : null,
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontSize: 24,
              ),
        ),
      ],
    );
  }
}


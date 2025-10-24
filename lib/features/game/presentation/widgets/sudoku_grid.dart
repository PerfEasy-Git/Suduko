import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SudokuGrid extends StatelessWidget {
  final List<List<int>> currentGrid;
  final List<List<int>> solution;
  final List<List<int>> fixedCells;
  final int? selectedRow;
  final int? selectedCol;
  final Function(int row, int col) onCellTap;

  const SudokuGrid({
    super.key,
    required this.currentGrid,
    required this.solution,
    required this.fixedCells,
    required this.selectedRow,
    required this.selectedCol,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxSize = screenHeight * 0.4; // Use 40% of screen height
    final gridSize = (screenWidth * 0.9) > maxSize ? maxSize : (screenWidth * 0.9);
    final cellSize = gridSize / 9;

    return Container(
      width: gridSize,
      height: gridSize,
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.gridLine, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Grid lines
          CustomPaint(
            size: Size(gridSize, gridSize),
            painter: GridPainter(),
          ),
          
          // Cells
          for (int row = 0; row < 9; row++)
            for (int col = 0; col < 9; col++)
              Positioned(
                left: col * cellSize,
                top: row * cellSize,
                width: cellSize,
                height: cellSize,
                child: _buildCell(row, col, cellSize),
              ),
        ],
      ),
    );
  }

  Widget _buildCell(int row, int col, double size) {
    final isSelected = row == selectedRow && col == selectedCol;
    final isFixed = fixedCells[row][col] != 0;
    final value = currentGrid[row][col];
    final isCorrect = value == 0 || value == solution[row][col];
    
    // Highlight same row/column as selected
    final isHighlighted = (selectedRow != null && (row == selectedRow || col == selectedCol));

    return GestureDetector(
      onTap: () => onCellTap(row, col),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primarySaffron.withOpacity(0.3)
              : isHighlighted
                  ? AppTheme.primarySaffron.withOpacity(0.1)
                  : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? AppTheme.primarySaffron
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: value != 0
              ? Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: size * 0.5,
                    fontWeight: isFixed ? FontWeight.bold : FontWeight.normal,
                    color: isFixed
                        ? AppTheme.textDark
                        : isCorrect
                            ? AppTheme.primarySaffron
                            : AppTheme.warningRed,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = AppTheme.gridLine;

    final thickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = AppTheme.primarySaffron.withOpacity(0.5);

    final cellSize = size.width / 9;

    // Draw grid lines
    for (int i = 0; i <= 9; i++) {
      final isThick = i % 3 == 0;
      final currentPaint = isThick ? thickPaint : paint;

      // Horizontal lines
      canvas.drawLine(
        Offset(0, i * cellSize),
        Offset(size.width, i * cellSize),
        currentPaint,
      );

      // Vertical lines
      canvas.drawLine(
        Offset(i * cellSize, 0),
        Offset(i * cellSize, size.height),
        currentPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


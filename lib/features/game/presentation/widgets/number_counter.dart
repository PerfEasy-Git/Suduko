import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NumberCounter extends StatelessWidget {
  final List<List<int?>> grid;
  final bool Function(int, int, int) isValidPlacement;

  const NumberCounter({
    super.key,
    required this.grid,
    required this.isValidPlacement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryCyan, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryCyan.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NUMBERS NEEDED',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.primaryCyan,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final itemWidth = 36.0;
              final spacing = 6.0;
              final itemsPerRow = ((availableWidth + spacing) / (itemWidth + spacing)).floor();
              final actualItemsPerRow = itemsPerRow > 0 ? itemsPerRow : 3; // Fallback to 3
              
              return Column(
                children: [
                  // First row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      actualItemsPerRow,
                      (index) => _buildNumberBadge(
                        context,
                        number: index + 1,
                        needed: 9 - _getNumberCount(index + 1),
                        isComplete: _getNumberCount(index + 1) == 9,
                      ),
                    ),
                  ),
                  if (9 > actualItemsPerRow) ...[
                    const SizedBox(height: 6),
                    // Second row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        9 - actualItemsPerRow,
                        (index) => _buildNumberBadge(
                          context,
                          number: actualItemsPerRow + index + 1,
                          needed: 9 - _getNumberCount(actualItemsPerRow + index + 1),
                          isComplete: _getNumberCount(actualItemsPerRow + index + 1) == 9,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNumberBadge(
    BuildContext context, {
    required int number,
    required int needed,
    required bool isComplete,
  }) {
    Color badgeColor;
    Color textColor;
    
    if (isComplete) {
      badgeColor = AppTheme.accentGreen;
      textColor = Colors.white;
    } else if (needed <= 2) {
      badgeColor = AppTheme.primaryCyan;
      textColor = Colors.white;
    } else {
      badgeColor = AppTheme.surfaceDark;
      textColor = AppTheme.primaryCyan;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isComplete ? AppTheme.accentGreen : AppTheme.primaryCyan,
          width: 1.5,
        ),
        boxShadow: isComplete ? [
          BoxShadow(
            color: AppTheme.accentGreen.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ] : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$number',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            '$needed',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  int _getNumberCount(int number) {
    int count = 0;
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == number) {
          count++;
        }
      }
    }
    return count;
  }
}

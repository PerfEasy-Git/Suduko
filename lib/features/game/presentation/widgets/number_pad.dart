import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NumberPad extends StatelessWidget {
  final Function(int)? onNumberSelected;

  const NumberPad({
    super.key,
    required this.onNumberSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(9, (index) {
          final number = index + 1;
          return _buildNumberButton(context, number);
        }),
      ),
    );
  }

  Widget _buildNumberButton(BuildContext context, int number) {
    final isEnabled = onNumberSelected != null;
    
    return GestureDetector(
      onTap: isEnabled ? () => onNumberSelected!(number) : null,
      child: Container(
        width: 36,
        height: 48,
        decoration: BoxDecoration(
          color: isEnabled ? AppTheme.surfaceDark : AppTheme.surfaceDark.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isEnabled ? AppTheme.primaryCyan : AppTheme.gridLine,
            width: 1,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppTheme.primaryCyan.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isEnabled ? AppTheme.primaryCyan : AppTheme.gridLine,
            ),
          ),
        ),
      ),
    );
  }
}


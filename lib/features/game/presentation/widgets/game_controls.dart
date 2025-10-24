import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class GameControls extends StatelessWidget {
  final VoidCallback? onUndo;
  final VoidCallback? onHint;
  final VoidCallback? onClear;

  const GameControls({
    super.key,
    required this.onUndo,
    required this.onHint,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            context,
            icon: Icons.undo,
            label: 'UNDO',
            onTap: onUndo,
          ),
          _buildControlButton(
            context,
            icon: Icons.lightbulb_outline,
            label: 'HINT',
            onTap: onHint,
            color: AppTheme.accentEmerald,
          ),
          _buildControlButton(
            context,
            icon: Icons.backspace_outlined,
            label: 'CLEAR',
            onTap: onClear,
            color: AppTheme.warningRed,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    Color? color,
  }) {
    final isEnabled = onTap != null;
    final buttonColor = color ?? AppTheme.primarySaffron;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isEnabled ? AppTheme.surfaceWhite : AppTheme.surfaceLightGrey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isEnabled ? buttonColor : AppTheme.gridLine,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isEnabled ? buttonColor : AppTheme.gridLine,
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isEnabled ? buttonColor : AppTheme.gridLine,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PerfeasyLogo extends StatelessWidget {
  final double size;
  final bool showText;
  
  const PerfeasyLogo({
    Key? key,
    this.size = 60,
    this.showText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Perfeasy Logo with transparent background - custom recreation
        Container(
          width: size * 1.2,
          height: size * 1.2,
          decoration: BoxDecoration(
            // No background color - completely transparent
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/Logo-new.png', // Use your new transparent PNG logo
            width: size * 1.2,
            height: size * 1.2,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Logo image failed to load: $error');
              // Fallback to custom logo if image fails to load
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Blue swoosh background - positioned at bottom
                  Positioned(
                    bottom: size * 0.15,
                    child: CustomPaint(
                      size: Size(size * 1.0, size * 0.4),
                      painter: BlueSwooshPainter(),
                    ),
                  ),
                  // PE text with orange color
                  Text(
                    'PE',
                    style: TextStyle(
                      fontSize: size * 0.5,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFE67E22), // Orange color
                      letterSpacing: -2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        
        if (showText) ...[
          const SizedBox(height: 8),
          // Perfeasy text
          Text(
            'PERFEASY',
            style: TextStyle(
              fontSize: size * 0.2,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryNavy,
              letterSpacing: 1,
            ),
          ),
        ],
      ],
    );
  }
}

class BlueSwooshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF4A90E2), // Light blue
          const Color(0xFF2E5BBA), // Dark blue
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    
    // Create a curved swoosh shape
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.2, size.height * 0.1,
      size.width * 0.5, size.height * 0.2,
    );
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.3,
      size.width, size.height * 0.1,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
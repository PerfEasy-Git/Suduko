import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Perfeasy Games Color Palette - Contrast Optimized
  static const Color primarySaffron = Color(0xFFE67E22);      // Deeper, richer saffron
  static const Color secondaryNavy = Color(0xFF2C3E50);       // Deep navy blue
  static const Color accentEmerald = Color(0xFF27AE60);       // Deep emerald green
  static const Color backgroundWarmIvory = Color(0xFFF9F7F1); // Warm ivory background
  static const Color textDark = Color(0xFF1A1A1A);           // Premium dark text
  static const Color textGrey = Color(0xFF7D7D7D);           // Subtext grey
  static const Color surfaceWhite = Color(0xFFFFFFFF);        // Pure white cards
  static const Color surfaceLightGrey = Color(0xFFF5F5F5);    // Soft grey cards
  static const Color gridLine = Color(0xFFE5E7EB);            // Subtle grid lines
  static const Color warningRed = Color(0xFFC0392B);         // Deep red
  static const Color successGreen = Color(0xFF27AE60);       // Success green
  
  // Tricolor Gradient Colors
  static const Color tricolorSaffron = Color(0xFFF5B041);
  static const Color tricolorWhite = Color(0xFFFFFFFF);
  static const Color tricolorGreen = Color(0xFF2ECC71);
  
  // Enhanced Brand Colors
  static const Color backgroundSaffronGradient = Color(0xFFFFF4E3);
  static const Color surfaceGlass = Color(0x80FFFFFF);
  
  // Difficulty Level Colors (Contrast Optimized)
  static const Color easyGreen = Color(0xFF27AE60);
  static const Color easyBackground = Color(0xFFECFDF5);
  static const Color mediumSaffron = Color(0xFFE67E22);
  static const Color mediumBackground = Color(0xFFFFF9E6);
  static const Color hardBlue = Color(0xFF2C3E50);
  static const Color hardBackground = Color(0xFFEBF5FF);
  static const Color expertRed = Color(0xFFC0392B);
  static const Color expertBackground = Color(0xFFFDECEA);
  
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primarySaffron,
      scaffoldBackgroundColor: backgroundWarmIvory,
      colorScheme: const ColorScheme.light(
        primary: primarySaffron,
        secondary: secondaryNavy,
        surface: surfaceWhite,
        background: backgroundWarmIvory,
        error: warningRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
        onBackground: textDark,
      ),
      textTheme: TextTheme(
        // Titles / Headings - Poppins SemiBold
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: secondaryNavy,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: secondaryNavy,
          letterSpacing: -0.25,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: secondaryNavy,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: primarySaffron,
        ),
        // Body / Descriptions - Nunito Sans
        bodyLarge: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textDark,
        ),
        bodyMedium: GoogleFonts.nunitoSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textGrey,
        ),
        bodySmall: GoogleFonts.nunitoSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textGrey,
        ),
        // Numbers (Grid) - Roboto Mono
        labelLarge: GoogleFonts.robotoMono(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        // Accent Text - Montserrat Medium Italic
        labelMedium: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          color: accentEmerald,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarySaffron,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Pill shape
          ),
          elevation: 2,
          shadowColor: primarySaffron.withOpacity(0.3),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceWhite,
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}


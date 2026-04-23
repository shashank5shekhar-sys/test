// lib/utils/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Colour Palette ──────────────────────────────────────────────────────────
  static const Color bg           = Color(0xFF0A0E1A);  // deep navy black
  static const Color surface      = Color(0xFF121828);  // card bg
  static const Color surfaceAlt   = Color(0xFF1A2235);  // elevated card
  static const Color accent       = Color(0xFF4F8EF7);  // electric blue
  static const Color accentGlow   = Color(0xFF7EB3FF);  // lighter blue glow
  static const Color success      = Color(0xFF2DD4BF);  // teal green
  static const Color error        = Color(0xFFFF5370);  // red
  static const Color warning      = Color(0xFFFFB74D);  // amber
  static const Color textPrimary  = Color(0xFFEAEEF8);  // near white
  static const Color textSecondary= Color(0xFF7A8BAD);  // muted blue-grey
  static const Color border       = Color(0xFF1F2E47);  // subtle border

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        background: bg,
        surface: surface,
        primary: accent,
        secondary: success,
        error: error,
        onBackground: textPrimary,
        onSurface: textPrimary,
        onPrimary: Colors.white,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme().apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ).copyWith(
        displayLarge: GoogleFonts.orbitron(
          color: textPrimary, fontWeight: FontWeight.w700, fontSize: 32,
        ),
        headlineLarge: GoogleFonts.orbitron(
          color: textPrimary, fontWeight: FontWeight.w600, fontSize: 24,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          color: textPrimary, fontWeight: FontWeight.w600, fontSize: 20,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          color: textPrimary, fontWeight: FontWeight.w600, fontSize: 18,
        ),
        bodyLarge: GoogleFonts.spaceGrotesk(
          color: textPrimary, fontSize: 16,
        ),
        bodyMedium: GoogleFonts.spaceGrotesk(
          color: textSecondary, fontSize: 14,
        ),
        labelLarge: GoogleFonts.spaceGrotesk(
          color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          color: textPrimary, fontWeight: FontWeight.w600, fontSize: 18,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: error),
        ),
        hintStyle: GoogleFonts.spaceGrotesk(color: textSecondary, fontSize: 14),
        labelStyle: GoogleFonts.spaceGrotesk(color: textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w600, fontSize: 16,
          ),
          elevation: 0,
        ),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceAlt,
        contentTextStyle: GoogleFonts.spaceGrotesk(color: textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: const DividerThemeData(color: border),
    );
  }
}

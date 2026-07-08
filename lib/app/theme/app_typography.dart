import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Lifora's typography system.
///
/// Uses Inter Tight (geometric, highly legible) for all roles.
/// Single font family — no decorative or serif fonts.
/// Configured as a complete Material 3 TextTheme.
class AppTypography {
  AppTypography._();

  /// Builds the full text theme with Inter Tight.
  ///
  /// [baseColor] is applied as the default text color so the theme
  /// adapts to light/dark without per-widget overrides.
  static TextTheme textTheme(Color baseColor) {
    return TextTheme(
      // ── Display ────────────────────────────────────────────────────
      displayLarge: GoogleFonts.interTight(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: baseColor,
      ),
      displayMedium: GoogleFonts.interTight(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: baseColor,
      ),
      displaySmall: GoogleFonts.interTight(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: baseColor,
      ),

      // ── Headline ───────────────────────────────────────────────────
      headlineLarge: GoogleFonts.interTight(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: baseColor,
      ),
      headlineMedium: GoogleFonts.interTight(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: baseColor,
      ),
      headlineSmall: GoogleFonts.interTight(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: baseColor,
      ),

      // ── Title ──────────────────────────────────────────────────────
      titleLarge: GoogleFonts.interTight(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: baseColor,
      ),
      titleMedium: GoogleFonts.interTight(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: baseColor,
      ),
      titleSmall: GoogleFonts.interTight(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: baseColor,
      ),

      // ── Body ───────────────────────────────────────────────────────
      bodyLarge: GoogleFonts.interTight(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: baseColor,
      ),
      bodyMedium: GoogleFonts.interTight(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: baseColor,
      ),
      bodySmall: GoogleFonts.interTight(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: baseColor,
      ),

      // ── Label ──────────────────────────────────────────────────────
      labelLarge: GoogleFonts.interTight(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: baseColor,
      ),
      labelMedium: GoogleFonts.interTight(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: baseColor,
      ),
      labelSmall: GoogleFonts.interTight(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: baseColor,
      ),
    );
  }
}

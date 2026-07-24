import 'package:flutter/material.dart';

/// Lifora's centralized color constants.
///
/// 3 hues only:
///   1. Navy (primary) — authority, calm, trust
///   2. Sand/stone (secondary) — warmth, completion, positive states
///   3. Deep red (alert) — SOS only, never decorative
///
/// Surface/on-surface variants are standard Material ColorScheme plumbing
/// for those hues, not additional colors.
class LiforaColors {
  LiforaColors._();

  // ── Hue 1: Navy ──────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1B2A4A);
  static const Color primaryLight = Color(0xFF2C3E6B);

  // ── Hue 2: Warm Sand ─────────────────────────────────────────────────
  static const Color secondary = Color(0xFFC9A96E);

  // ── Hue 3: Alert Red (SOS only — standalone, NOT in ColorScheme) ────
  /// Reserved exclusively for active SOS state. Must not appear in
  /// nav bars, icons, or any decorative accent.
  static const Color alert = Color(0xFFC0392B);

  // ── Surfaces ──────────────────────────────────────────────────────────
  static const Color surface = Color(0xFFF5F3EF);
  static const Color surfaceDark = Color(0xFF121826);

  // ── On-colors (contrast text/icons) ───────────────────────────────────
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1A1A2E);
  static const Color onSurfaceDark = Color(0xFFE8E6E1);

  // ── Light ColorScheme ─────────────────────────────────────────────────
  static ColorScheme get lightScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryLight,
        onPrimaryContainer: onPrimary,
        secondary: secondary,
        onSecondary: primary,
        secondaryContainer: Color(0xFFE8D5B0),
        onSecondaryContainer: primary,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: Color(0xFF4A4A5A),
        error: Color(0xFFBA1A1A),
        onError: onPrimary,
        outline: Color(0xFFB0AEAD),
        outlineVariant: Color(0xFFD8D6D2),
        shadow: Color(0xFF000000),
      );

  // ── Dark ColorScheme ──────────────────────────────────────────────────
  static ColorScheme get darkScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF8DA4CF),
        onPrimary: primary,
        primaryContainer: primaryLight,
        onPrimaryContainer: onPrimary,
        secondary: secondary,
        onSecondary: primary,
        secondaryContainer: Color(0xFF7A6A3E),
        onSecondaryContainer: Color(0xFFE8D5B0),
        surface: surfaceDark,
        onSurface: onSurfaceDark,
        onSurfaceVariant: Color(0xFF9A9AAA),
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
        outline: Color(0xFF5A5A6A),
        outlineVariant: Color(0xFF3A3A4A),
        shadow: Color(0xFF000000),
      );
}

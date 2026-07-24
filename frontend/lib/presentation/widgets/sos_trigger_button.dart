import 'package:flutter/material.dart';

import 'package:lifora/app/theme/app_colors.dart';

/// The signature SOS trigger button for Lifora.
///
/// Designed to look like real emergency hardware — not a stock Material
/// button. Draws from fire alarm pull stations and industrial emergency
/// stops: a thick guard ring around a recessed, high-contrast activation
/// surface. The alert color ([LiforaColors.alert]) appears ONLY here.
///
/// This is a reusable widget used on the [HomeScreen]. It accepts an
/// [onPressed] callback and an optional [enabled] flag.
///
/// Design references:
/// - Industrial E-Stop buttons (mushroom-head with guard ring)
/// - Fire alarm pull stations (bold red, clear perimeter)
/// - Marine distress signage (high contrast, unambiguous)
class SosTriggerButton extends StatelessWidget {
  const SosTriggerButton({
    super.key,
    required this.onPressed,
    this.enabled = true,
    this.size = 180,
  });

  /// Called when the button is tapped. Will not fire if [enabled] is false.
  final VoidCallback onPressed;

  /// Whether the button is interactive. When false, the button appears
  /// dimmed and does not respond to taps.
  final bool enabled;

  /// Diameter of the button in logical pixels. Defaults to 180.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: GestureDetector(
        onTap: enabled ? onPressed : null,
        child: CustomPaint(
          painter: _SosButtonPainter(
            enabled: enabled,
            brightness: Theme.of(context).brightness,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.crisis_alert,
                  size: size * 0.2,
                  color: enabled
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.4),
                ),
                SizedBox(height: size * 0.02),
                Text(
                  'SOS',
                  style: TextStyle(
                    fontSize: size * 0.18,
                    fontWeight: FontWeight.w800,
                    color: enabled
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.4),
                    letterSpacing: 4,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the SOS button.
///
/// Renders concentric rings inspired by industrial emergency stop buttons:
/// 1. Outer guard ring — thick dark border (navy), like the protective
///    collar around an E-Stop mushroom head.
/// 2. Hazard band — a narrow ring of diagonal-line texture between the
///    guard and the activation surface, signaling "danger zone."
/// 3. Inner activation surface — the recessed button face in alert red,
///    with a subtle radial gradient to suggest depth/physicality.
class _SosButtonPainter extends CustomPainter {
  _SosButtonPainter({
    required this.enabled,
    required this.brightness,
  });

  final bool enabled;
  final Brightness brightness;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // ── Layer 1: Outer guard ring (navy) ─────────────────────────────
    final guardColor = brightness == Brightness.dark
        ? LiforaColors.primaryLight
        : LiforaColors.primary;

    final guardPaint = Paint()
      ..color = enabled ? guardColor : guardColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, guardPaint);

    // ── Layer 2: Hazard band (dark amber/sand) ───────────────────────
    // A narrow ring between guard and activation surface.
    final hazardRadius = radius * 0.85;
    final hazardPaint = Paint()
      ..color = enabled
          ? LiforaColors.secondary.withValues(alpha: 0.7)
          : LiforaColors.secondary.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.08;

    canvas.drawCircle(center, hazardRadius, hazardPaint);

    // ── Layer 3: Inner activation surface (alert red) ────────────────
    final innerRadius = radius * 0.72;

    final alertColor =
        enabled ? LiforaColors.alert : LiforaColors.alert.withValues(alpha: 0.25);
    final alertHighlight = enabled
        ? const Color(0xFFE74C3C)
        : const Color(0xFFE74C3C).withValues(alpha: 0.15);

    final innerPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 1.0,
        colors: [alertHighlight, alertColor],
        stops: const [0.0, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: innerRadius),
      )
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, innerRadius, innerPaint);

    // ── Layer 4: Inner shadow / depth ring ───────────────────────────
    // Subtle dark edge around the inner circle for a recessed look.
    final shadowPaint = Paint()
      ..color = enabled
          ? Colors.black.withValues(alpha: 0.25)
          : Colors.black.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, innerRadius, shadowPaint);

    // ── Layer 5: Highlight arc (top-left) ────────────────────────────
    // A subtle specular highlight suggesting a convex glass surface.
    if (enabled) {
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..style = PaintingStyle.fill;

      final highlightPath = Path()
        ..addArc(
          Rect.fromCircle(
            center: Offset(center.dx - innerRadius * 0.15,
                center.dy - innerRadius * 0.15),
            radius: innerRadius * 0.55,
          ),
          -2.4, // start angle
          1.6, // sweep angle
        )
        ..lineTo(center.dx - innerRadius * 0.15,
            center.dy - innerRadius * 0.15)
        ..close();

      canvas.drawPath(highlightPath, highlightPaint);
    }
  }

  @override
  bool shouldRepaint(_SosButtonPainter oldDelegate) {
    return oldDelegate.enabled != enabled ||
        oldDelegate.brightness != brightness;
  }
}

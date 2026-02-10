import 'dart:math';

import 'package:flutter/material.dart';

/// Custom painter to draw glitter/sparkle effect on profile card background.
/// Sparkle positions use fractional coordinates (0.0–1.0) so they adapt
/// to any widget size. Radii and stroke widths scale relative to the
/// shorter canvas dimension, keeping sparkles proportionate on all screens.
class GlitterPainter extends CustomPainter {
  final double scale;

  GlitterPainter({this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    // Base unit = 1% of the shorter side, so sparkles stay proportionate
    final double unit = min(size.width, size.height) * 0.006 * scale;

    final sparkles = [
      // Left side – brighter sparkles
      _Sparkle(0.08, 0.10, 3.5, 0.95),
      _Sparkle(0.18, 0.25, 3.0, 0.9),
      _Sparkle(0.05, 0.40, 3.2, 0.92),
      _Sparkle(0.22, 0.55, 2.8, 0.85),
      _Sparkle(0.12, 0.70, 3.5, 0.95),
      _Sparkle(0.25, 0.85, 3.0, 0.9),
      _Sparkle(0.15, 0.95, 2.5, 0.8),
      _Sparkle(0.30, 0.15, 2.8, 0.85),
      _Sparkle(0.35, 0.45, 2.5, 0.8),
      _Sparkle(0.28, 0.65, 3.0, 0.88),
      // Right side – medium sparkles
      _Sparkle(0.75, 0.12, 2.2, 0.65),
      _Sparkle(0.88, 0.22, 2.0, 0.6),
      _Sparkle(0.65, 0.35, 2.0, 0.6),
      _Sparkle(0.92, 0.45, 2.2, 0.65),
      _Sparkle(0.70, 0.58, 2.0, 0.6),
      _Sparkle(0.85, 0.70, 2.0, 0.6),
      _Sparkle(0.78, 0.85, 2.2, 0.65),
      _Sparkle(0.60, 0.20, 1.8, 0.55),
      _Sparkle(0.95, 0.65, 1.8, 0.55),
    ];

    for (final sparkle in sparkles) {
      final x = size.width * sparkle.x;
      final y = size.height * sparkle.y;
      final radius = sparkle.radius * unit;

      // Outer glow
      final glowPaint = Paint()
        ..color = Colors.white.withValues(alpha: sparkle.opacity * 0.4)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.8);
      canvas.drawCircle(Offset(x, y), radius * 1.5, glowPaint);

      // Main sparkle dot
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: sparkle.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), radius, paint);

      // Star rays for brighter sparkles
      if (sparkle.opacity > 0.5) {
        final rayPaint = Paint()
          ..color = Colors.white.withValues(alpha: sparkle.opacity * 0.6)
          ..strokeWidth = 0.8 * unit
          ..style = PaintingStyle.stroke;

        final rayLength = radius * 1.8;
        canvas.drawLine(
          Offset(x - rayLength, y),
          Offset(x + rayLength, y),
          rayPaint,
        );
        canvas.drawLine(
          Offset(x, y - rayLength),
          Offset(x, y + rayLength),
          rayPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant GlitterPainter oldDelegate) =>
      scale != oldDelegate.scale;
}

class _Sparkle {
  final double x;
  final double y;
  final double radius;
  final double opacity;

  const _Sparkle(this.x, this.y, this.radius, this.opacity);
}

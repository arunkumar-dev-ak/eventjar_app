import 'dart:math';

import 'package:eventjar/model/contact/contact_ui_model.dart';
import 'package:flutter/material.dart';

class CircularPieChartPainter extends CustomPainter {
  final List<PieChartModel> stages;
  final double animationValue;
  final bool showText;
  final int? activeStageIndex;

  CircularPieChartPainter({
    required this.stages,
    required this.animationValue,
    this.showText = true,
    this.activeStageIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = radius * 0.38;
    final gapAngle = 0.10;

    final totalGapAngle = gapAngle * stages.length;
    final availableAngle = (2 * pi) - totalGapAngle;
    final segmentAngle = availableAngle / stages.length;

    // Start from the bottom (6 o'clock position) going clockwise
    double startAngle = pi / 2 - segmentAngle / 2;

    final innerRadius = radius - strokeWidth;
    final outerRadius = radius;

    // First pass: draw all non-active segments
    double tempStartAngle = startAngle;
    for (int i = 0; i < stages.length; i++) {
      if (i != activeStageIndex) {
        final stage = stages[i];
        final sweepAngle = segmentAngle * animationValue;

        _drawSegment(
          canvas,
          center,
          innerRadius,
          outerRadius,
          tempStartAngle,
          sweepAngle,
          stage.color,
          false,
        );

        if (showText && animationValue > 0.5) {
          _drawCurvedText(
            canvas,
            center,
            radius - strokeWidth / 2,
            tempStartAngle,
            sweepAngle,
            stage.name,
            stage.isEnabled,
          );
        }
      }
      tempStartAngle += segmentAngle * animationValue + gapAngle;
    }

    // Second pass: draw active segment on top with glow effect
    tempStartAngle = startAngle;
    for (int i = 0; i < stages.length; i++) {
      if (i == activeStageIndex) {
        final stage = stages[i];
        final sweepAngle = segmentAngle * animationValue;

        // Draw glow effect behind active segment
        final glowExpand = 12.0;
        final glowPaint = Paint()
          ..color = stage.color.withAlpha(80)
          ..style = PaintingStyle.fill
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15);

        _drawSegmentPath(
          canvas,
          center,
          innerRadius - glowExpand,
          outerRadius + glowExpand,
          tempStartAngle - 0.02,
          sweepAngle + 0.04,
          glowPaint,
        );

        // Draw expanded active segment
        final expandAmount = 8.0;
        _drawSegment(
          canvas,
          center,
          innerRadius - expandAmount,
          outerRadius + expandAmount,
          tempStartAngle - 0.015,
          sweepAngle + 0.03,
          stage.color,
          true,
        );

        if (showText && animationValue > 0.5) {
          _drawCurvedText(
            canvas,
            center,
            radius - strokeWidth / 2,
            tempStartAngle,
            sweepAngle,
            stage.name,
            stage.isEnabled,
          );
        }
      }
      tempStartAngle += segmentAngle * animationValue + gapAngle;
    }
  }

  void _drawSegment(
    Canvas canvas,
    Offset center,
    double innerRadius,
    double outerRadius,
    double startAngle,
    double sweepAngle,
    Color color,
    bool isActive,
  ) {
    final path = Path();

    final innerStartX = center.dx + innerRadius * cos(startAngle);
    final innerStartY = center.dy + innerRadius * sin(startAngle);
    path.moveTo(innerStartX, innerStartY);

    final outerRect = Rect.fromCircle(center: center, radius: outerRadius);
    path.arcTo(outerRect, startAngle, sweepAngle, false);

    final innerEndX = center.dx + innerRadius * cos(startAngle + sweepAngle);
    final innerEndY = center.dy + innerRadius * sin(startAngle + sweepAngle);
    path.lineTo(innerEndX, innerEndY);

    final innerRect = Rect.fromCircle(center: center, radius: innerRadius);
    path.arcTo(innerRect, startAngle + sweepAngle, -sweepAngle, false);

    path.close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (isActive) {
      // Add gradient for active segment
      paint.shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [color, Color.lerp(color, Colors.white, 0.2)!],
      ).createShader(Rect.fromCircle(center: center, radius: outerRadius));
    }

    canvas.drawPath(path, paint);

    // Add highlight border for active segment
    if (isActive) {
      final borderPaint = Paint()
        ..color = Colors.white.withAlpha(200)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawPath(path, borderPaint);
    }
  }

  void _drawSegmentPath(
    Canvas canvas,
    Offset center,
    double innerRadius,
    double outerRadius,
    double startAngle,
    double sweepAngle,
    Paint paint,
  ) {
    final path = Path();

    final innerStartX = center.dx + innerRadius * cos(startAngle);
    final innerStartY = center.dy + innerRadius * sin(startAngle);
    path.moveTo(innerStartX, innerStartY);

    final outerRect = Rect.fromCircle(center: center, radius: outerRadius);
    path.arcTo(outerRect, startAngle, sweepAngle, false);

    final innerEndX = center.dx + innerRadius * cos(startAngle + sweepAngle);
    final innerEndY = center.dy + innerRadius * sin(startAngle + sweepAngle);
    path.lineTo(innerEndX, innerEndY);

    final innerRect = Rect.fromCircle(center: center, radius: innerRadius);
    path.arcTo(innerRect, startAngle + sweepAngle, -sweepAngle, false);

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawCurvedText(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
    String text,
    bool isEnabled,
  ) {
    final textStyle = TextStyle(
      color: isEnabled ? Colors.white : Colors.white70,
      fontSize: 10,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    );

    final midAngle = startAngle + sweepAngle / 2;
    final charCount = text.length;

    final anglePerChar = sweepAngle * 0.65 / charCount;

    double normalizedMidAngle = midAngle % (2 * pi);
    if (normalizedMidAngle < 0) normalizedMidAngle += 2 * pi;

    // Text orientation based on position
    // NEW CONTACT, 7D FOLLOWUP, and QUALIFIED LEAD need to be flipped
    bool isOutwardFacing;

    if (text == "NEW CONTACT" ||
        text == "7D FOLLOWUP" ||
        text == "QUALIFIED LEAD") {
      // Flip these texts
      isOutwardFacing =
          !(normalizedMidAngle > pi / 2 && normalizedMidAngle < 3 * pi / 2);
    } else {
      // All others keep normal orientation
      isOutwardFacing =
          normalizedMidAngle > pi / 2 && normalizedMidAngle < 3 * pi / 2;
    }

    double textStartAngle;
    double angleDirection;

    if (isOutwardFacing) {
      textStartAngle = midAngle + (charCount - 1) * anglePerChar / 2;
      angleDirection = -1;
    } else {
      textStartAngle = midAngle - (charCount - 1) * anglePerChar / 2;
      angleDirection = 1;
    }

    for (int i = 0; i < charCount; i++) {
      final charAngle = textStartAngle + i * anglePerChar * angleDirection;

      final charX = center.dx + radius * cos(charAngle);
      final charY = center.dy + radius * sin(charAngle);

      canvas.save();
      canvas.translate(charX, charY);

      double rotation;
      if (isOutwardFacing) {
        rotation = charAngle - pi / 2;
      } else {
        rotation = charAngle + pi / 2;
      }

      canvas.rotate(rotation);

      final textPainter = TextPainter(
        text: TextSpan(text: text[i], style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CircularPieChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.showText != showText ||
        oldDelegate.activeStageIndex != activeStageIndex;
  }
}

import 'dart:math';

import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class NisGauge extends StatelessWidget {
  final int score;

  const NisGauge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 50.wp,
          height: 28.wp,
          child: CustomPaint(
            painter: _GaugePainter(score: score),
          ),
        ),
        SizedBox(height: 0.8.hp),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$score',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: _getScoreColor(score),
                  height: 1.0,
                ),
              ),
              TextSpan(
                text: '/100',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondaryStatic,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return const Color(0xFF2E7D32);
    if (score >= 60) return const Color(0xFFF9A825);
    if (score >= 40) return const Color(0xFFFF8F00);
    return const Color(0xFFD32F2F);
  }
}

class _GaugePainter extends CustomPainter {
  final int score;

  _GaugePainter({required this.score});

  static const _startAngleDeg = 150.0;
  static const _sweepAngleDeg = 240.0;
  static const _startAngle = _startAngleDeg * (pi / 180);
  static const _sweepAngle = _sweepAngleDeg * (pi / 180);
  static const _segments = 100;

  static const _gradientColors = [
    Color(0xFFD32F2F),
    Color(0xFFFF8F00),
    Color(0xFFF9A825),
    Color(0xFF7CB342),
    Color(0xFF2E7D32),
  ];
  static const _gradientStops = [0.0, 0.25, 0.5, 0.75, 1.0];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.95);
    final radius = size.width * 0.42;
    const strokeWidth = 14.0;

    final arcRect = Rect.fromCircle(center: center, radius: radius);

    final segmentAngle = _sweepAngle / _segments;
    const overlap = 0.02;

    for (int i = 0; i < _segments; i++) {
      final t = i / (_segments - 1);
      final color = _colorAtT(t);
      final start = _startAngle + (i * segmentAngle);
      final sweep = segmentAngle + (i < _segments - 1 ? overlap : 0);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = i == 0 || i == _segments - 1
            ? StrokeCap.round
            : StrokeCap.butt;

      canvas.drawArc(arcRect, start, sweep, false, paint);
    }

    final progress = (score / 100).clamp(0.0, 1.0);
    final progressAngle = _sweepAngle * progress;
    final needleAngle = _startAngle + progressAngle;
    final needleLength = radius - 16;
    final needleEnd = Offset(
      center.dx + needleLength * cos(needleAngle),
      center.dy + needleLength * sin(needleAngle),
    );

    final needlePaint = Paint()
      ..color = _colorAtT(progress)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleEnd, needlePaint);

    canvas.drawCircle(center, 4, Paint()..color = Colors.white);
    canvas.drawCircle(
      center,
      4,
      Paint()
        ..color = _colorAtT(progress)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  Color _colorAtT(double t) {
    t = t.clamp(0.0, 1.0);
    for (int i = 0; i < _gradientStops.length - 1; i++) {
      if (t <= _gradientStops[i + 1]) {
        final localT = (t - _gradientStops[i]) /
            (_gradientStops[i + 1] - _gradientStops[i]);
        return Color.lerp(_gradientColors[i], _gradientColors[i + 1], localT)!;
      }
    }
    return _gradientColors.last;
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.score != score;
}

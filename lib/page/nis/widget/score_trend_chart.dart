import 'dart:ui' as ui;

import 'package:eventjar/controller/nis_insights/state.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class ScoreTrendChart extends StatelessWidget {
  final List<NisScorePoint> data;

  const ScoreTrendChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 28.hp,
          child: CustomPaint(
            size: Size.infinite,
            painter: _ChartPainter(
              data: data,
              textColor: AppColors.textSecondary(context),
              gridColor: Colors.grey.shade200,
            ),
          ),
        ),
        SizedBox(height: 1.hp),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: data
              .map(
                (point) => Text(
                  point.month,
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<NisScorePoint> data;
  final Color textColor;
  final Color gridColor;

  _ChartPainter({
    required this.data,
    required this.textColor,
    required this.gridColor,
  });

  static const _yLabels = [0, 25, 50, 75, 100];
  static const _leftPadding = 32.0;
  static const _rightPadding = 16.0;
  static const _topPadding = 12.0;
  static const _bottomPadding = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chartLeft = _leftPadding;
    final chartRight = size.width - _rightPadding;
    final chartTop = _topPadding;
    final chartBottom = size.height - _bottomPadding;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - chartTop;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    final labelStyle = ui.TextStyle(color: textColor, fontSize: 10);

    for (final label in _yLabels) {
      final y = chartBottom - (label / 100) * chartHeight;

      canvas.drawLine(Offset(chartLeft, y), Offset(chartRight, y), gridPaint);

      final paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
        textAlign: TextAlign.right,
        fontSize: 10,
      ))
        ..pushStyle(labelStyle)
        ..addText('$label');
      final paragraph = paragraphBuilder.build()
        ..layout(const ui.ParagraphConstraints(width: 26));
      canvas.drawParagraph(paragraph, Offset(0, y - 7));
    }

    if (data.length < 2) return;

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = chartLeft + (i / (data.length - 1)) * chartWidth;
      final y = chartBottom - (data[i].score / 100) * chartHeight;
      points.add(Offset(x, y));
    }

    final fillPath = Path()..moveTo(points.first.dx, chartBottom);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(points.last.dx, chartBottom);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, chartTop),
        Offset(0, chartBottom),
        [
          const Color(0xFF1565C0).withValues(alpha: 0.15),
          const Color(0xFF1565C0).withValues(alpha: 0.0),
        ],
      );
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF1565C0)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final isLast = i == points.length - 1;

      canvas.drawCircle(p, 5, Paint()..color = Colors.white);
      canvas.drawCircle(
        p,
        isLast ? 5 : 4,
        Paint()
          ..color = isLast ? const Color(0xFF2E7D32) : const Color(0xFF1565C0)
          ..style = isLast ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      final scoreText = '${data[i].score}';
      final paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: isLast ? 12 : 10,
      ))
        ..pushStyle(ui.TextStyle(
          color: isLast ? const Color(0xFF2E7D32) : const Color(0xFF1565C0),
          fontWeight: isLast ? FontWeight.w700 : FontWeight.w600,
          fontSize: isLast ? 12 : 10,
        ))
        ..addText(scoreText);
      final paragraph = paragraphBuilder.build()
        ..layout(const ui.ParagraphConstraints(width: 40));
      canvas.drawParagraph(paragraph, Offset(p.dx - 20, p.dy - 20));
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) =>
      oldDelegate.data != data;
}

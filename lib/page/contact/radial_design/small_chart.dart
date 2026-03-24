import 'package:eventjar/model/contact/contact_ui_model.dart';
import 'package:eventjar/page/contact/radial_design/circular_pie_chart_painter.dart';
import 'package:flutter/material.dart';

Widget buildSmallChart(List<PieChartModel> stages, double size) {
  return SizedBox(
    width: size,
    height: size,
    child: CustomPaint(
      size: Size(size, size),
      painter: CircularPieChartPainter(
        stages: stages,
        animationValue: 1.0,
        showText: false, // No text for small chart
      ),
    ),
  );
}

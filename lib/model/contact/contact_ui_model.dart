import 'package:flutter/material.dart';

class PieChartModel {
  final String name;
  final Color color;
  final bool isEnabled;

  PieChartModel({
    required this.name,
    required this.color,
    this.isEnabled = true,
  });
}

class PieChartStageDefinition {
  final String name;
  final String fullName;
  final Color color;

  PieChartStageDefinition({
    required this.name,
    required this.color,
    required this.fullName,
  });
}

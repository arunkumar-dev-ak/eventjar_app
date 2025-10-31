import 'package:flutter/material.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';

Widget buildIconHeaderContainer({
  required IconData icon,
  required Color color,
}) {
  return Container(
    padding: EdgeInsets.all(2.wp),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(icon, color: color, size: 20),
  );
}

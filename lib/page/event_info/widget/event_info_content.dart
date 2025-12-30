import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

Widget freeButtonLabel() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      "FREE",
      style: TextStyle(
        color: Colors.white,
        fontSize: 8.sp,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

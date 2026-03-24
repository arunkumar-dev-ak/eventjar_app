import 'package:flutter/material.dart';

class FoldCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);

    // Fold shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1);

    final shadowPath = Path()
      ..moveTo(1, size.height - 1)
      ..lineTo(size.width - 1, 1)
      ..quadraticBezierTo(size.width - 2, 2, size.width - 1, 3);

    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

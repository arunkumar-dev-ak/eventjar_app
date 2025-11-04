import 'package:flutter/material.dart';

class TicketShapePainter extends CustomPainter {
  final Color borderColor;
  final double borderRadius;
  final double circleRadius;

  TicketShapePainter({
    required this.borderColor,
    this.borderRadius = 12,
    this.circleRadius = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..moveTo(borderRadius, 0)
      ..lineTo(size.width - borderRadius, 0)
      ..arcToPoint(
        Offset(size.width, borderRadius),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(size.width, size.height / 2 - circleRadius)
      ..arcToPoint(
        Offset(size.width, size.height / 2 + circleRadius),
        radius: Radius.circular(circleRadius),
        clockwise: false,
      )
      ..lineTo(size.width, size.height - borderRadius)
      ..arcToPoint(
        Offset(size.width - borderRadius, size.height),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(borderRadius, size.height)
      ..arcToPoint(
        Offset(0, size.height - borderRadius),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(0, size.height / 2 + circleRadius)
      ..arcToPoint(
        Offset(0, size.height / 2 - circleRadius),
        radius: Radius.circular(circleRadius),
        clockwise: false,
      )
      ..lineTo(0, borderRadius)
      ..arcToPoint(
        Offset(borderRadius, 0),
        radius: Radius.circular(borderRadius),
      )
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

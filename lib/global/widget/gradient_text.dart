import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final double textSize;
  final String content;
  final Color gradientStart;
  final Color gradientEnd;
  final FontWeight fontWeight;

  const GradientText({
    required this.textSize,
    required this.content,
    required this.gradientStart,
    required this.gradientEnd,
    required this.fontWeight,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [gradientStart, gradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        content,
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: textSize,
          color: Colors.white,
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final List<Color>? gradientColors;
  final bool showWaves;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.gradientColors,
    this.showWaves = true,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    // Gradient animation - slow color shift
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    // Wave animation
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        widget.gradientColors ??
        [Colors.white, Colors.blue.withAlpha(150), Colors.blue.withAlpha(120)];

    return Stack(
      children: [
        // Layer 1: Animated Gradient Background
        AnimatedBuilder(
          animation: _gradientController,
          builder: (context, child) {
            return CustomPaint(
              painter: GradientPainter(
                animation: _gradientController.value,
                colors: colors,
              ),
              size: Size.infinite,
            );
          },
        ),

        // Layer 2: Wave Animation
        if (widget.showWaves)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: WavePainter(animation: _waveController.value),
                    size: Size(MediaQuery.of(context).size.width, 150),
                  );
                },
              ),
            ),
          ),

        // Content
        widget.child,
      ],
    );
  }
}

// Gradient Painter - creates animated shifting gradient
class GradientPainter extends CustomPainter {
  final double animation;
  final List<Color> colors;

  GradientPainter({required this.animation, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    // Animate the gradient alignment
    final beginAlignment = Alignment(
      -1.0 + animation * 0.5,
      -1.0 + animation * 0.3,
    );
    final endAlignment = Alignment(
      1.0 - animation * 0.3,
      1.0 - animation * 0.5,
    );

    final gradient = LinearGradient(
      begin: beginAlignment,
      end: endAlignment,
      colors: colors,
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(GradientPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

// Wave Painter - animated waves at bottom
class WavePainter extends CustomPainter {
  final double animation;

  WavePainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    // First wave (back)
    _drawWave(
      canvas,
      size,
      offset: animation * 2 * pi,
      amplitude: 20,
      color: Colors.blue.withAlpha(60),
      yOffset: 50,
    );

    // Second wave (middle)
    _drawWave(
      canvas,
      size,
      offset: (animation * 2 * pi) + pi / 2,
      amplitude: 16,
      color: Colors.blue.withAlpha(80),
      yOffset: 30,
    );

    // Third wave (front)
    _drawWave(
      canvas,
      size,
      offset: (animation * 2 * pi) + pi,
      amplitude: 12,
      color: Colors.blue.withAlpha(40),
      yOffset: 10,
    );
  }

  void _drawWave(
    Canvas canvas,
    Size size, {
    required double offset,
    required double amplitude,
    required Color color,
    required double yOffset,
  }) {
    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y =
          size.height -
          yOffset -
          amplitude * sin((x / size.width * 2 * pi) + offset);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

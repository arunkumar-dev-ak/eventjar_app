import 'dart:math';
import 'package:flutter/material.dart';

class NetworkNode {
  Offset position;
  Offset velocity;
  double radius;
  double pulsePhase;
  double brightness;

  NetworkNode({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.pulsePhase,
    required this.brightness,
  });
}

class NetworkAnimationPainter extends CustomPainter {
  final List<NetworkNode> nodes;
  final double animationValue;
  final double connectionDistance;
  final Color nodeColor;
  final Color lineColor;

  NetworkAnimationPainter({
    required this.nodes,
    required this.animationValue,
    this.connectionDistance = 120.0,
    this.nodeColor = Colors.white,
    this.lineColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    final nodePaint = Paint()..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    // Draw connections between nearby nodes
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final distance = (nodes[i].position - nodes[j].position).distance;
        if (distance < connectionDistance) {
          final opacity = (1 - distance / connectionDistance) * 0.5;

          // Animated pulse effect on lines
          final pulseEffect = sin((animationValue * 4 * pi) + (i + j) * 0.2) * 0.2 + 0.8;
          linePaint.color = lineColor.withValues(alpha: opacity * pulseEffect);
          linePaint.strokeWidth = 1.0 + (1 - distance / connectionDistance) * 1.5;

          canvas.drawLine(nodes[i].position, nodes[j].position, linePaint);

          // Draw small dot at midpoint of connection
          if (distance < connectionDistance * 0.6) {
            final midPoint = Offset(
              (nodes[i].position.dx + nodes[j].position.dx) / 2,
              (nodes[i].position.dy + nodes[j].position.dy) / 2,
            );
            nodePaint.color = nodeColor.withValues(alpha: opacity * 0.5);
            canvas.drawCircle(midPoint, 1.5, nodePaint);
          }
        }
      }
    }

    // Draw nodes with pulse effect
    for (final node in nodes) {
      final pulseValue = sin((animationValue * 3 * pi) + node.pulsePhase);
      final currentRadius = node.radius + (pulseValue * 1.5);

      // Outer glow effect
      glowPaint.color = nodeColor.withValues(alpha: 0.15 * node.brightness);
      canvas.drawCircle(node.position, currentRadius * 3.5, glowPaint);

      // Middle glow
      glowPaint.color = nodeColor.withValues(alpha: 0.25 * node.brightness);
      canvas.drawCircle(node.position, currentRadius * 2, glowPaint);

      // Main node
      nodePaint.color = nodeColor.withValues(alpha: 0.7 * node.brightness);
      canvas.drawCircle(node.position, currentRadius, nodePaint);

      // Inner bright spot
      nodePaint.color = nodeColor.withValues(alpha: node.brightness);
      canvas.drawCircle(node.position, currentRadius * 0.4, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant NetworkAnimationPainter oldDelegate) {
    return true;
  }
}

class NetworkAnimationWidget extends StatefulWidget {
  final double opacity;
  final int nodeCount;

  const NetworkAnimationWidget({
    super.key,
    this.opacity = 1.0,
    this.nodeCount = 40,
  });

  @override
  State<NetworkAnimationWidget> createState() => _NetworkAnimationWidgetState();
}

class _NetworkAnimationWidgetState extends State<NetworkAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<NetworkNode> _nodes = [];
  final Random _random = Random();
  bool _nodesInitialized = false;
  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _controller.addListener(_updateNodes);
  }

  void _initializeNodes(Size size) {
    _nodes = List.generate(widget.nodeCount, (index) {
      // Create different layers of nodes
      final isLargeNode = index < widget.nodeCount * 0.15;
      final isMediumNode = index < widget.nodeCount * 0.4;

      double baseRadius;
      double baseSpeed;
      double brightness;

      if (isLargeNode) {
        baseRadius = _random.nextDouble() * 3 + 4;
        baseSpeed = 0.3;
        brightness = 1.0;
      } else if (isMediumNode) {
        baseRadius = _random.nextDouble() * 2 + 2.5;
        baseSpeed = 0.5;
        brightness = 0.85;
      } else {
        baseRadius = _random.nextDouble() * 1.5 + 1.5;
        baseSpeed = 0.7;
        brightness = 0.6;
      }

      return NetworkNode(
        position: Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height,
        ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * baseSpeed,
          (_random.nextDouble() - 0.5) * baseSpeed,
        ),
        radius: baseRadius,
        pulsePhase: _random.nextDouble() * 2 * pi,
        brightness: brightness,
      );
    });
    _lastSize = size;
  }

  void _updateNodes() {
    if (!mounted || _nodes.isEmpty) return;

    for (final node in _nodes) {
      // Update position
      node.position += node.velocity;

      // Bounce off edges with padding
      final padding = 20.0;
      if (node.position.dx < padding || node.position.dx > _lastSize.width - padding) {
        node.velocity = Offset(-node.velocity.dx, node.velocity.dy);
        node.position = Offset(
          node.position.dx.clamp(padding, _lastSize.width - padding),
          node.position.dy,
        );
      }
      if (node.position.dy < padding || node.position.dy > _lastSize.height - padding) {
        node.velocity = Offset(node.velocity.dx, -node.velocity.dy);
        node.position = Offset(
          node.position.dx,
          node.position.dy.clamp(padding, _lastSize.height - padding),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateNodes);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        // Initialize or reinitialize nodes if size changed significantly
        if (!_nodesInitialized ||
            (size.width - _lastSize.width).abs() > 50 ||
            (size.height - _lastSize.height).abs() > 50) {
          _initializeNodes(size);
          _nodesInitialized = true;
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: widget.opacity,
              child: CustomPaint(
                size: size,
                painter: NetworkAnimationPainter(
                  nodes: _nodes,
                  animationValue: _controller.value,
                  connectionDistance: size.width * 0.18,
                  nodeColor: Colors.white,
                  lineColor: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

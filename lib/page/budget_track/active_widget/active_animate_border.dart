import 'package:eventjar/controller/budget_track/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedBorderCard extends GetView<BudgetTrackController> {
  final Widget child;

  const AnimatedBorderCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.animation,
      builder: (_, __) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
          padding: EdgeInsets.all(0.5.wp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.sp),

            gradient: SweepGradient(
              colors: [
                Colors.transparent,
                Colors.green.withValues(alpha: 0.3),
                Colors.green,
                Colors.white,
                Colors.green,
                Colors.green.withValues(alpha: 0.3),
                Colors.transparent,
              ],
              stops: const [0.0, 0.2, 0.35, 0.5, 0.65, 0.8, 1.0],
              transform: GradientRotation(controller.animation.value * 6.2832),
            ),

            /// ✨ Glow effect
            boxShadow: [
              BoxShadow(
                color: Colors.green.withValues(alpha: 0.6),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),

          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(14.sp),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

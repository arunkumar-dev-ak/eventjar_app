import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseAnimatedBorderCard extends GetView<ViewTripController> {
  final Widget child;

  const ExpenseAnimatedBorderCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade400;
    return AnimatedBuilder(
      animation: controller.animation,
      builder: (_, _) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 1.hp),
          padding: EdgeInsets.all(0.3.wp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.sp),

            gradient: SweepGradient(
              colors: [
                Colors.transparent,
                baseColor.withValues(alpha: 0.2),
                baseColor,
                Colors.white,
                baseColor,
                baseColor.withValues(alpha: 0.2),
                Colors.transparent,
              ],
              stops: const [0.0, 0.2, 0.35, 0.5, 0.65, 0.8, 1.0],
              transform: GradientRotation(controller.animation.value * 6.2832),
            ),

            /// ✨ Subtle glow
            boxShadow: [
              BoxShadow(
                color: baseColor.withValues(alpha: 0.25),
                blurRadius: 10,
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

import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class ComingSoonWidget extends StatelessWidget {
  final String message;

  const ComingSoonWidget({
    super.key,
    this.message = "Exciting features coming soon!",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.wp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gradientDarkStart.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.rocket_launch_rounded,
                size: 36,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.hp),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.hp),
            Text(
              "We're working on something amazing.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 8.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.wp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gradient circle with icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gradientDarkStart.withValues(alpha: 0.25),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.star_border_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.hp),

            // Title
            Text(
              "No Reviews Yet",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.5.hp),
          ],
        ),
      ),
    );
  }
}

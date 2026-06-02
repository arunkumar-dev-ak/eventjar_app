import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.wp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.iconMutedStatic),

            SizedBox(height: 2.hp),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondaryStatic,
              ),
            ),

            SizedBox(height: 1.hp),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 9.sp, color: AppColors.textHintStatic),
            ),
          ],
        ),
      ),
    );
  }
}

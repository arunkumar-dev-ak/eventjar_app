import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class NisBreakdownItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color barColor;
  final String label;
  final int score;

  const NisBreakdownItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.barColor,
    required this.label,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.hp),
      child: Row(
        children: [
          Container(
            width: 10.wp,
            height: 10.wp,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 5.wp),
          ),
          SizedBox(width: 3.wp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: 0.6.hp),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: score / 100,
                    minHeight: 0.8.hp,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.wp),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$score',
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                TextSpan(
                  text: '/100',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

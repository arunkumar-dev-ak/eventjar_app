import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class EventPriceBadge extends StatelessWidget {
  final bool isPaid;

  const EventPriceBadge({super.key, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: isPaid ? AppColors.buttonGradient : null,
        color: isPaid ? null : Colors.green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isPaid
                ? AppColors.gradientDarkEnd.withValues(alpha: 0.3)
                : Colors.green.withValues(alpha: 0.15),
            blurRadius: isPaid ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isPaid ? 'Paid' : 'Free',
            style: TextStyle(
              color: isPaid ? Colors.white : Colors.green.shade700,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            isPaid
                ? Icons.confirmation_number_rounded
                : Icons.check_circle_rounded,
            color: isPaid ? Colors.white : Colors.green.shade700,
            size: isPaid ? 14 : 14,
          ),
        ],
      ),
    );
  }
}

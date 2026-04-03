import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';

class EmailUnconfiguredCard extends StatelessWidget {
  const EmailUnconfiguredCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2010) : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.orange.shade800 : Colors.orange.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.email_outlined, size: 28, color: Colors.orange.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email Not Configured',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Configure SMTP to send tickets, reminders, and notifications.',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary(context)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

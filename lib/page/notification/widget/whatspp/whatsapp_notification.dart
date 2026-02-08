import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class WhatsAppComingSoon extends StatelessWidget {
  const WhatsAppComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.wp),
        child: Container(
          padding: EdgeInsets.all(5.wp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.construction_rounded,
                size: 40,
                color: Colors.orange.shade600,
              ),
              SizedBox(height: 2.hp),
              Text(
                "WhatsApp Notifications",
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 1.hp),
              Text(
                "This feature is currently under development and will be available soon.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 9.sp, color: Colors.grey.shade700),
              ),
              SizedBox(height: 1.hp),
              Text(
                "Note: WhatsApp integration is not available in the current  version.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8.sp,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

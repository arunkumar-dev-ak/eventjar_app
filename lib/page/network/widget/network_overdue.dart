import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/contact_analytics_model.dart';
import 'package:flutter/material.dart';

class NetworkOverdueWrapper extends StatelessWidget {
  final Widget child;
  const NetworkOverdueWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: 1.02,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      child: child,
    );
  }
}

class NetworkOverdueCard extends StatelessWidget {
  final NetworkStatusCardData data;
  final int count;
  final VoidCallback? onTap;

  const NetworkOverdueCard({
    super.key,
    required this.data,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              data.color.withValues(alpha: 0.85),
              data.color.withValues(alpha: 0.45),
            ],
          ),
        ),
        child: Row(
          children: [
            Icon(data.icon, color: Colors.white),
            SizedBox(width: 2.wp),
            Expanded(
              child: Text(
                data.label,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  fontSize: 9.sp,
                ),
              ),
            ),
            Text(
              count.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 9.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

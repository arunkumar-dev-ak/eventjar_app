import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class NfcActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final bool enabled;
  final VoidCallback onTap;

  const NfcActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = !enabled;

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: disabled ? 0.6 : 1.0,
        child: Container(
          padding: EdgeInsets.all(5.wp),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: disabled
                  ? gradientColors.map((c) => c.withValues(alpha: 0.6)).toList()
                  : gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors.last.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: Colors.white),
              ),
              SizedBox(width: 3.wp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.5.hp),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.white70, fontSize: 7.5.sp),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white70,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

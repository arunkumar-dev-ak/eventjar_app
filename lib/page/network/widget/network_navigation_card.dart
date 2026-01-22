import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class NetworkNavigationCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const NetworkNavigationCard({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),

            /// 🌤 Light blue gradient background
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFFF5FAFF), const Color(0xFFE9F3FF)],
            ),

            /// Subtle blue border
            border: Border.all(color: const Color(0xFFB6D9FF), width: 1),

            /// Soft elevation
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB6D9FF).withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Icon container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.9),
                      Colors.white.withValues(alpha: 0.6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: const Color(0xFF2F6FED), // blue accent
                ),
              ),

              const SizedBox(width: 16),

              /// Label
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: const Color(0xFF1F3B6E),
                  ),
                ),
              ),

              /// Arrow
              Icon(Icons.lock, size: 14, color: const Color(0xFF5A7FCB)),
            ],
          ),
        ),
      ),
    );
  }
}

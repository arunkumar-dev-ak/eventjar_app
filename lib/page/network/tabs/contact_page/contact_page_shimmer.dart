import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContactAnalyticsShimmer extends StatelessWidget {
  const ContactAnalyticsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 28, height: 28, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Container(width: 80, height: 16, color: Colors.grey.shade400),
            const Spacer(),
            Container(width: 60, height: 30, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

class OverdueCardShimmer extends StatelessWidget {
  const OverdueCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 110,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Container(height: 18, color: Colors.grey.shade400),
                    ),
                    Container(
                      width: 60,
                      height: 22,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

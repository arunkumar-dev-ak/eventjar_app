import 'package:flutter/material.dart';

class NetworkOverdueShimmer extends StatelessWidget {
  const NetworkOverdueShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.6),
      ),
      child: Row(
        children: [
          /// Circle shimmer (icon placeholder)
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
            ),
          ),

          const SizedBox(width: 16),

          /// Text shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerLine(width: 120),
                const SizedBox(height: 8),
                _shimmerLine(width: 80),
              ],
            ),
          ),

          /// Count shimmer
          _shimmerLine(width: 36, height: 18),
        ],
      ),
    );
  }

  Widget _shimmerLine({required double width, double height = 14}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade300,
      ),
    );
  }
}

Widget networkStatusCardShimmer({required int crossAxisCount}) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.15,
    ),
    itemCount: crossAxisCount,
    itemBuilder: (_, __) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withValues(alpha: 0.6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
      );
    },
  );
}

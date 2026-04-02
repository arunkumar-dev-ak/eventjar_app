import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';

class NetworkOverdueShimmer extends StatelessWidget {
  const NetworkOverdueShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = AppColors.border(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.cardBg(context).withValues(alpha: 0.6),
      ),
      child: Row(
        children: [
          /// Circle shimmer (icon placeholder)
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: shimmerColor,
            ),
          ),

          const SizedBox(width: 16),

          /// Text shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerLine(width: 120, color: shimmerColor),
                const SizedBox(height: 8),
                _shimmerLine(width: 80, color: shimmerColor),
              ],
            ),
          ),

          /// Count shimmer
          _shimmerLine(width: 36, height: 18, color: shimmerColor),
        ],
      ),
    );
  }

  Widget _shimmerLine({
    required double width,
    double height = 14,
    required Color color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
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
          color: AppColors.cardBgStatic.withValues(alpha: 0.6),
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

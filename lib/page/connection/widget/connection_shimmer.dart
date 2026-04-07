import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget connectionShimmer() {
  final base = AppColors.borderStatic;
  final highlight = AppColors.chipBgStatic;
  final placeholder = AppColors.dividerStatic;

  return Card(
    elevation: 2,
    color: AppColors.cardBgStatic,
    shadowColor: AppColors.shadowStatic,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar + Name/Badges
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Initials circle shimmer
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: placeholder,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Container(
                        height: 16,
                        width: double.infinity,
                        color: placeholder,
                      ),
                      const SizedBox(height: 4),
                      // Badges row
                      Container(height: 12, width: 80, color: placeholder),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Event info row
            Row(
              children: [
                Container(width: 18, height: 18, color: placeholder),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 14, width: 180, color: placeholder),
                      const SizedBox(height: 4),
                      Container(height: 12, width: 120, color: placeholder),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Message container
            Container(
              width: double.infinity,
              height: 36,
              color: placeholder,
            ),

            const SizedBox(height: 16),

            // Status + Button row
            Row(
              children: [
                // Status badge
                Container(width: 60, height: 24, color: placeholder),
                const Spacer(),
                // Action button
                Container(
                  height: 36,
                  width: 100,
                  decoration: BoxDecoration(
                    color: placeholder,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

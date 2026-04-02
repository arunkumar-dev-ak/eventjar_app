import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget meetingShimmer() {
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 48, height: 48, color: placeholder),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        color: placeholder,
                      ),
                      const SizedBox(height: 4),
                      Container(height: 12, width: 100, color: placeholder),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            Container(width: 80, height: 24, color: placeholder),
          ],
        ),
      ),
    ),
  );
}

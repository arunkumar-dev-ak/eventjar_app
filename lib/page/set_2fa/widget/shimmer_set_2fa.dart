import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:eventjar/global/responsive/responsive.dart';

class TwoFactorShimmer extends StatelessWidget {
  const TwoFactorShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade600 : Colors.grey.shade100;
    final placeholderColor = isDark ? AppColors.darkCardElevated : Colors.grey.shade300;

    return Padding(
      padding: EdgeInsets.all(4.wp),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        period: const Duration(milliseconds: 1400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 3.hp),

            // Icon
            Container(
              width: 16.wp,
              height: 16.wp,
              decoration: BoxDecoration(
                color: placeholderColor,
                shape: BoxShape.circle,
              ),
            ),

            SizedBox(height: 2.hp),

            // Title
            Container(height: 14, width: 60.wp, decoration: _box(placeholderColor)),

            SizedBox(height: 1.hp),

            // Subtitle
            Container(height: 12, width: 70.wp, decoration: _box(placeholderColor)),

            SizedBox(height: 3.hp),

            // QR Code Box
            Container(
              width: 45.wp,
              height: 45.wp,
              decoration: BoxDecoration(
                color: placeholderColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            SizedBox(height: 3.hp),

            // OR line
            Row(
              children: [
                Expanded(child: Divider(color: placeholderColor)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.wp),
                  child: Container(width: 30, height: 10, decoration: _box(placeholderColor)),
                ),
                Expanded(child: Divider(color: placeholderColor)),
              ],
            ),

            SizedBox(height: 2.hp),

            // Secret label
            Container(height: 12, width: 50.wp, decoration: _box(placeholderColor)),

            SizedBox(height: 1.hp),

            // Secret box
            Container(
              height: 5.hp,
              width: double.infinity,
              decoration: BoxDecoration(
                color: placeholderColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            SizedBox(height: 3.hp),

            // Instructions (3 lines)
            Column(
              children: List.generate(
                3,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: 1.hp),
                  child: Container(
                    height: 12,
                    width: double.infinity,
                    decoration: _box(placeholderColor),
                  ),
                ),
              ),
            ),

            SizedBox(height: 3.hp),

            // OTP boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) => Container(
                  width: 10.wp,
                  height: 6.hp,
                  margin: EdgeInsets.symmetric(horizontal: 1.wp),
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            SizedBox(height: 3.hp),

            // Button
            Container(
              height: 6.hp,
              width: double.infinity,
              decoration: BoxDecoration(
                color: placeholderColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _box(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(6),
    );
  }
}

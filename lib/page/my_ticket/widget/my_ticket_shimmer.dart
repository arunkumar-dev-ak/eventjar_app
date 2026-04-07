import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget myTicketShimmer() {
  return Shimmer.fromColors(
    baseColor: AppColors.borderStatic,
    highlightColor: AppColors.chipBgStatic,
    child: Container(
      margin: EdgeInsets.only(bottom: 3.hp),
      decoration: BoxDecoration(
        color: AppColors.cardBgStatic,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerStatic, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(4.wp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Title
                Container(width: 250, height: 16.0, color: Colors.white),
                SizedBox(height: 1.5.hp),

                // Badges Row
                Wrap(
                  spacing: 2.wp,
                  runSpacing: 1.hp,
                  children: [
                    Container(
                      width: 80,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Details Section
          Padding(
            padding: EdgeInsets.fromLTRB(4.wp, 0, 4.wp, 4.wp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRowShimmer(),
                SizedBox(height: 1.5.hp),
                _buildInfoRowShimmer(),
                SizedBox(height: 1.5.hp),
                _buildInfoRowShimmer(),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildInfoRowShimmer() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(width: 4.wp),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 80, height: 12.0, color: Colors.white),
            SizedBox(height: 0.5.hp),
            Container(width: 150, height: 14.0, color: Colors.white),
          ],
        ),
      ),
    ],
  );
}

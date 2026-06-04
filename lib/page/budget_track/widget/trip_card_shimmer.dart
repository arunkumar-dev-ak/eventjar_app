import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TripCardShimmer extends StatelessWidget {
  const TripCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
      padding: EdgeInsets.all(3.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.divider(context),
        highlightColor: AppColors.scaffoldBg(context),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.border(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                SizedBox(width: 3.wp),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.border(context),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),

                      SizedBox(height: 1.hp),

                      Container(
                        height: 12,
                        width: 40.wp,
                        decoration: BoxDecoration(
                          color: AppColors.border(context),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.hp),

            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.border(context),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

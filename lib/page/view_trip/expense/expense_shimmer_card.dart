import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ExpenseShimmerCard extends StatelessWidget {
  const ExpenseShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final placeholder = AppColors.border(context);

    return Container(
      width: 78.wp,
      margin: EdgeInsets.only(top: 1.hp),
      padding: EdgeInsets.all(3.5.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.divider(context),
        highlightColor: AppColors.scaffoldBg(context),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: placeholder,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 2.5.wp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: 40.wp,
                        decoration: BoxDecoration(
                          color: placeholder,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 0.8.hp),
                      Container(
                        height: 14,
                        width: 20.wp,
                        decoration: BoxDecoration(
                          color: placeholder,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.hp),
            Row(
              children: [
                Container(
                  height: 10,
                  width: 30.wp,
                  decoration: BoxDecoration(
                    color: placeholder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 10,
                  width: 12.wp,
                  decoration: BoxDecoration(
                    color: placeholder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

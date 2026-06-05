import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FriendShimmerCard extends StatelessWidget {
  const FriendShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final placeholder = AppColors.border(context);

    return Container(
      margin: EdgeInsets.only(top: 1.hp),
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider(context), width: 0.5),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.divider(context),
        highlightColor: AppColors.scaffoldBg(context),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: placeholder,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 3.wp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 13,
                    width: 35.wp,
                    decoration: BoxDecoration(
                      color: placeholder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 0.8.hp),
                  Container(
                    height: 10,
                    width: 22.wp,
                    decoration: BoxDecoration(
                      color: placeholder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 28,
              width: 18.wp,
              decoration: BoxDecoration(
                color: placeholder,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

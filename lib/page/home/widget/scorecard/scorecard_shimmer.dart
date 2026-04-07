import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget scorecardBuildShimmerProfile() {
  return Shimmer.fromColors(
    baseColor: AppColors.borderStatic,
    highlightColor: AppColors.chipBgStatic,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardBgStatic,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.fromLTRB(3.wp, 1.hp, 3.wp, 1.hp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 24.wp,
                  height: 28.wp,
                  decoration: BoxDecoration(
                    color: AppColors.cardBgStatic,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                SizedBox(width: 4.wp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40.wp,
                        height: 1.7.hp,
                        decoration: BoxDecoration(
                          color: AppColors.cardBgStatic,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 0.8.hp),
                      Container(
                        width: 30.wp,
                        height: 1.2.hp,
                        decoration: BoxDecoration(
                          color: AppColors.cardBgStatic,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 0.6.hp),
                      Container(
                        width: 25.wp,
                        height: 1.2.hp,
                        decoration: BoxDecoration(
                          color: AppColors.cardBgStatic,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 1.hp),
                      Row(
                        children: List.generate(
                          6,
                          (_) => Padding(
                            padding: EdgeInsets.only(right: 0.5.wp),
                            child: Container(
                              width: 5.5.wp,
                              height: 5.5.wp,
                              decoration: BoxDecoration(
                                color: AppColors.cardBgStatic,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 0.5.hp),
          Container(
            width: double.infinity,
            height: 9.hp,
            decoration: BoxDecoration(
              color: AppColors.cardBgStatic,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

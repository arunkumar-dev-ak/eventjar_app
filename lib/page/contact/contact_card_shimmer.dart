import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerPlaceholderForContactCard({bool isBottomNeedToLoad = true}) {
  final base = AppColors.borderStatic;
  final highlight = AppColors.chipBgStatic;
  final placeholder = AppColors.dividerStatic;

  return Card(
    elevation: 3,
    color: AppColors.cardBgStatic,
    shadowColor: AppColors.shadowStatic,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 1.wp),
    child: Padding(
      padding: EdgeInsets.all(2.wp),
      child: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: placeholder,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 16, width: 150, color: placeholder),
                      SizedBox(height: 8),
                      Container(height: 14, width: 200, color: placeholder),
                      SizedBox(height: 8),
                      Container(height: 14, width: 140, color: placeholder),
                    ],
                  ),
                ),
              ],
            ),
            if (isBottomNeedToLoad) ...[
              SizedBox(height: 15),
              Container(
                height: 36,
                decoration: BoxDecoration(
                  color: placeholder,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              SizedBox(height: 20),
              Container(height: 200, color: placeholder),
            ],
          ],
        ),
      ),
    ),
  );
}

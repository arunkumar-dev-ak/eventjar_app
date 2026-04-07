import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildRequestAttendeeListShimmer() {
  final base = AppColors.borderStatic;
  final highlight = AppColors.chipBgStatic;
  final placeholder = AppColors.dividerStatic;

  return Column(
    children: List.generate(2, (index) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 0.5.hp),
        padding: EdgeInsets.all(2.wp),
        decoration: BoxDecoration(
          color: AppColors.cardBgStatic,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowStatic,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: base,
              highlightColor: highlight,
              child: CircleAvatar(
                radius: 28,
                backgroundColor: placeholder,
              ),
            ),
            SizedBox(width: 4.wp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: base,
                    highlightColor: highlight,
                    child: Container(
                      height: 18,
                      width: 120,
                      color: placeholder,
                    ),
                  ),
                  SizedBox(height: 7),
                  Shimmer.fromColors(
                    baseColor: base,
                    highlightColor: highlight,
                    child: Container(
                      height: 12,
                      width: 80,
                      color: placeholder,
                    ),
                  ),
                  SizedBox(height: 15),
                  Shimmer.fromColors(
                    baseColor: base,
                    highlightColor: highlight,
                    child: Container(
                      height: 12,
                      width: 150,
                      color: placeholder,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }),
  );
}

Widget buildAttendeeListShimmer() {
  final base = AppColors.borderStatic;
  final highlight = AppColors.chipBgStatic;
  final placeholder = AppColors.dividerStatic;

  return Column(
    children: List.generate(2, (index) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 0.5.wp, horizontal: 0.5.wp),
        padding: EdgeInsets.all(1.wp),
        decoration: BoxDecoration(
          color: AppColors.cardBgStatic,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowStatic,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: base,
              highlightColor: highlight,
              child: CircleAvatar(
                radius: 28,
                backgroundColor: placeholder,
              ),
            ),
            SizedBox(width: 4.wp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: base,
                    highlightColor: highlight,
                    child: Container(
                      height: 18,
                      width: 110,
                      color: placeholder,
                    ),
                  ),
                  SizedBox(height: 0.9.hp),
                  Shimmer.fromColors(
                    baseColor: base,
                    highlightColor: highlight,
                    child: Container(
                      height: 10,
                      width: 120,
                      color: placeholder,
                    ),
                  ),
                  SizedBox(height: 8),
                  Shimmer.fromColors(
                    baseColor: base,
                    highlightColor: highlight,
                    child: Container(
                      height: 38,
                      width: double.infinity,
                      color: placeholder,
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      );
    }),
  );
}

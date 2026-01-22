import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerPlaceholderForContactCard({bool isBottomNeedToLoad = true}) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 1.wp),
    child: Padding(
      padding: EdgeInsets.all(2.wp),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 16, width: 150, color: Colors.white),
                      SizedBox(height: 8),
                      Container(height: 14, width: 200, color: Colors.white),
                      SizedBox(height: 8),
                      Container(height: 14, width: 140, color: Colors.white),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              SizedBox(height: 20),
              Container(height: 200, color: Colors.white),
            ],
          ],
        ),
      ),
    ),
  );
}

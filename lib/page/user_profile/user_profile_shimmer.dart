import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget userProfileBuildShimmerSkeleton() {
  return SingleChildScrollView(
    child: Column(
      children: [
        // ✅ Profile Header Shimmer
        _buildHeaderShimmer(),
        SizedBox(height: 3.hp),

        // ✅ Sections Shimmer (6 sections)
        ...List.generate(
          6,
          (index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
            child: _buildSectionShimmer(),
          ),
        ),
        SizedBox(height: 4.hp),
      ],
    ),
  );
}

Widget _buildHeaderShimmer() {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(4.wp),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue.shade50, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade50,
      highlightColor: Colors.grey.shade50,
      period: Duration(milliseconds: 1500),
      child: Column(
        children: [
          SizedBox(height: 3.hp),
          // Avatar shimmer
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 2.hp),
          // Edit button shimmer
          Container(
            width: 80,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          SizedBox(height: 2.hp),
          // Name shimmer
          Container(
            width: 200,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 1.hp),
          // Company & Role shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 2.wp),
              Container(
                width: 60,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.hp),
        ],
      ),
    ),
  );
}

Widget _buildSectionShimmer() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade200,
      period: Duration(milliseconds: 1500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header shimmer
          Padding(
            padding: EdgeInsets.all(4.wp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.shade100,
          ),
          // Content shimmer (3 lines)
          Padding(
            padding: EdgeInsets.all(4.wp),
            child: Column(
              children: List.generate(
                3,
                (i) => Padding(
                  padding: EdgeInsets.only(bottom: i < 2 ? 8 : 0),
                  child: Container(
                    height: 16,
                    width: i == 0 ? double.infinity : 70.wp,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

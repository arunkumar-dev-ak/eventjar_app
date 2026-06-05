import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

Widget eventInfoAppBarImageNotFound() {
  final isDark = AppColors.isDark;
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: isDark
            ? [AppColors.darkCard, AppColors.darkCardElevated]
            : [Colors.grey.shade200, Colors.grey.shade300],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardElevated : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.image_outlined,
              color: AppColors.iconMutedStatic,
              size: 40,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'no_image'.tr,
            style: TextStyle(
              color: AppColors.textHintStatic,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget eventInfoAppBarImageShimmer() {
  return Shimmer.fromColors(
    baseColor: AppColors.dividerStatic,
    highlightColor: AppColors.chipBgStatic,
    period: const Duration(milliseconds: 1500),
    child: Container(color: AppColors.dividerStatic),
  );
}

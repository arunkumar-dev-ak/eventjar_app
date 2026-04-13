import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

Widget homeContentBuildTags({required String label}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: AppColors.buttonGradient,
    ),
    child: Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 8.sp,
      ),
    ),
  );
}

Widget homeContentBuildVirtualTags({required String label}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        colors: [Colors.blue.shade400, Colors.blue.shade600],
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.videocam_rounded, color: Colors.white, size: 12),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 8.sp,
          ),
        ),
      ],
    ),
  );
}

Widget homeContentImageNotFound() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.chipBgStatic, AppColors.dividerStatic],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBgStatic,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.image_outlined,
              color: AppColors.iconMutedStatic,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No Image',
            style: TextStyle(
              color: AppColors.iconMutedStatic,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget homeContentImageShimmer() {
  return Shimmer.fromColors(
    baseColor: AppColors.dividerStatic,
    highlightColor: AppColors.scaffoldBgStatic,
    period: const Duration(milliseconds: 1500),
    child: Container(color: AppColors.dividerStatic),
  );
}

Widget homeContentPaidOrFreeButton({required String label}) {
  final isFree = label.toLowerCase() == 'free';
  return Container(
    decoration: BoxDecoration(
      gradient: isFree ? AppColors.buttonGradient : null,
      color: isFree ? null : AppColors.cardBgStatic,
      borderRadius: BorderRadius.circular(12),
      border: isFree
          ? null
          : Border.all(
              color: AppColors.gradientDarkStart.withValues(alpha: 0.3),
              width: 1.5,
            ),
      boxShadow: [
        BoxShadow(
          color: isFree
              ? AppColors.gradientDarkEnd.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.wp),
    child: Text(
      label,
      style: TextStyle(
        color: isFree ? Colors.white : AppColors.gradientDarkStart,
        fontWeight: FontWeight.w600,
        fontSize: 9.sp,
        letterSpacing: 0.3,
      ),
    ),
  );
}

Widget noEventsFoundWidget({VoidCallback? onRefresh}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // SVG icon with container
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.gradientDarkStart.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            'assets/expressing-icons/no_event_found.svg',
            height: 15.hp,
            width: 100,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 24),
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.buttonGradient.createShader(bounds),
          child: Text(
            "No Events Yet",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "We couldn't find any events at the moment.\nCheck back later for exciting new events!",
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textHintStatic,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        if (onRefresh != null) ...[
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onRefresh,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gradientDarkEnd.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Refresh',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

// Tag widgets (unchanged, reused)
import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

Widget homeContentBuildTags({required String label}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: AppColors.buttonGradient,
    ),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.gradientDarkStart,
          fontWeight: FontWeight.bold,
          fontSize: 8.sp,
        ),
      ),
    ),
  );
}

Widget homeContentBuildVirtualTags({required String label}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: AppColors.gradientDarkStart,
    ),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.gradientDarkStart,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 8.sp,
        ),
      ),
    ),
  );
}

Widget homeContentImageNotFound() {
  return Stack(
    fit: StackFit.expand,
    children: [
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.1),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 35,
        ),
      ),
    ],
  );
}

Widget homeContentImageShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(color: Colors.grey.shade300),
  );
}

Widget homeContentPaidOrFreeButton({required String label}) {
  return Container(
    decoration: BoxDecoration(
      color: label.toLowerCase() == 'free' ? null : AppColors.gradientDarkStart,
      gradient: label.toLowerCase() == 'free' ? AppColors.buttonGradient : null,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: AppColors.gradientDarkEnd.withValues(alpha: 0.4),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 2.wp),
    child: Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 10.sp,
        letterSpacing: 0.5,
      ),
    ),
  );
}

Widget noEventsFoundWidget() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // SVG icon
        SvgPicture.asset(
          'assets/expressing-icons/no_event_found.svg',
          height: 40.hp,
          width: 150,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 20),
        Text(
          "No events found at the moment.",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          "Please check back later or try adjusting your filters.",
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

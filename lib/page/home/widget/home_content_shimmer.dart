import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';

class EventCardShimmer extends StatelessWidget {
  const EventCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.wp),
      child: Container(
        margin: EdgeInsets.only(top: 1.hp),
        padding: EdgeInsets.all(3.wp),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.gradientDarkStart.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          period: const Duration(seconds: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 2.hp),

              // Title placeholder
              Container(
                height: 16.sp,
                width: 0.6 * 100.wp, // 60% of width
                color: Colors.grey[300],
              ),
              SizedBox(height: 1.hp),

              // Location placeholder
              Row(
                children: [
                  Container(
                    height: 12.sp,
                    width: 12.sp,
                    color: Colors.grey[300],
                  ),
                  SizedBox(width: 1.wp),
                  Container(
                    height: 12.sp,
                    width: 0.3 * 100.wp,
                    color: Colors.grey[300],
                  ),
                ],
              ),
              SizedBox(height: 1.hp),

              // Date & Time placeholder
              Row(
                children: [
                  Container(
                    height: 12.sp,
                    width: 12.sp,
                    color: Colors.grey[300],
                  ),
                  SizedBox(width: 1.wp),
                  Container(
                    height: 12.sp,
                    width: 0.4 * 100.wp,
                    color: Colors.grey[300],
                  ),
                ],
              ),
              SizedBox(height: 1.hp),

              // Description placeholder (two lines)
              Container(
                height: 12.sp,
                width: double.infinity,
                color: Colors.grey[300],
              ),
              SizedBox(height: 4),
              Container(
                height: 12.sp,
                width: 0.8 * 100.wp,
                color: Colors.grey[300],
              ),
              SizedBox(height: 1.hp),

              // Tags placeholder (small rectangles)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(3, (index) {
                    return Container(
                      margin: EdgeInsets.only(right: 2.wp),
                      height: 20,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 1.hp),

              // Organizer and button placeholder
              Row(
                children: [
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 1.wp),
                  Container(
                    height: 14.sp,
                    width: 0.2 * 100.wp,
                    color: Colors.grey[300],
                  ),
                  Spacer(),
                  Container(
                    height: 24,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

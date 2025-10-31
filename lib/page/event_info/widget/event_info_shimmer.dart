import 'package:eventjar_app/page/event_info/widget/event_info_back_button.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';

/*----- appbar shimmer ----*/
class EventInfoAppBarShimmer extends StatelessWidget {
  const EventInfoAppBarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(0), // optional
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.gradientDarkStart.withValues(alpha: 0.2),
        highlightColor: AppColors.gradientLightEnd.withValues(alpha: 0.4),
        period: const Duration(seconds: 2),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image placeholder
            Container(
              decoration: BoxDecoration(
                color: AppColors.gradientDarkStart.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            // Gradient overlay mimic
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 0),
                  child: EventInfoBackButton(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*----- Event Info Content shimmer ----*/
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
          color: Colors.transparent,
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
          baseColor: AppColors.gradientDarkStart.withValues(alpha: 0.2),
          highlightColor: AppColors.gradientLightEnd.withValues(alpha: 0.4),
          period: const Duration(seconds: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title placeholder
              Container(
                height: 16.sp,
                width: 0.6 * 100.wp, // 60% of width
                color: Colors.grey[300],
              ),

              // Organizer placeholder
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

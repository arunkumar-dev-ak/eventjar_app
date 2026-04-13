import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TripCard extends StatelessWidget {
  final int index;
  final String title;
  final String location;
  final int members;
  final int budget;
  final int spent;

  const TripCard({
    super.key,
    required this.index,
    required this.title,
    required this.location,
    required this.members,
    required this.budget,
    required this.spent,
  });

  double get progress => (spent / budget).clamp(0.0, 1.0);

  String get illustrationPath {
    final imageIndex = (index % 5) + 1;
    return "assets/illustration/ill$imageIndex.svg";
  }

  @override
  Widget build(BuildContext context) {
    final remaining = budget - spent;

    return Container(
      height: 16.hp,
      padding: EdgeInsets.all(2.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.all(Radius.circular(12.sp)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 8.sp,
            offset: Offset(0, 5.sp),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //left svg
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12.sp)),
            child: SizedBox(
              width: 18.wp,
              child: ColoredBox(
                color: AppColors.lightBlueBg(context),
                child: SvgPicture.asset(illustrationPath, fit: BoxFit.cover),
              ),
            ),
          ),

          //Right
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.5.hp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // 👈 evenly space rows
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title + Location
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      SizedBox(height: 0.4.hp),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 9.sp,
                            color: AppColors.iconMuted(context),
                          ),
                          SizedBox(width: 1.wp),
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 8.sp,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  /// Members + Budget + Spent
                  Row(
                    children: [
                      Icon(
                        Icons.group,
                        size: 9.sp,
                        color: AppColors.iconMuted(context),
                      ),
                      SizedBox(width: 1.wp),
                      Text(
                        "$members Members",
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: AppColors.textSecondary(context),
                        ),
                      ),

                      const Spacer(),

                      /// Budget
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Budget",
                            style: TextStyle(
                              fontSize: 7.sp,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                          Text(
                            "₹$budget",
                            style: TextStyle(
                              fontSize: 8.5.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 4.wp),

                      /// Spent
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Spent",
                            style: TextStyle(
                              fontSize: 7.sp,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                          Text(
                            "₹$spent",
                            style: TextStyle(
                              fontSize: 8.5.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gradientDarkStart,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  /// Remaining / Over + Progress
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        remaining >= 0
                            ? "₹$remaining left"
                            : "₹${remaining.abs()} over budget",
                        style: TextStyle(
                          fontSize: 7.5.sp,
                          fontWeight: FontWeight.w600,
                          color: remaining >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      SizedBox(height: 0.5.hp),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2.sp),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 0.7.hp,
                          backgroundColor: AppColors.divider(context),
                          valueColor: AlwaysStoppedAnimation(
                            remaining >= 0
                                ? AppColors.gradientDarkStart
                                : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

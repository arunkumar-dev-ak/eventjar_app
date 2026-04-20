import 'package:eventjar/controller/budget_track/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/budget_track/friends/friends_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsTab extends GetView<BudgetTrackController> {
  const FriendsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.wp),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 1.hp),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg(context),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow(context),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Obx(() {
                  final selected = controller.state.selectedFilter.value;

                  return Row(
                    children: [
                      FriendTab(
                        label: "All",
                        count: 12,
                        selected: selected == "All",
                        onTap: () =>
                            controller.state.selectedFilter.value = "All",
                      ),
                      SizedBox(width: 2.wp),
                      FriendTab(
                        label: "Pending",
                        count: 3,
                        selected: selected == "Pending",
                        onTap: () =>
                            controller.state.selectedFilter.value = "Pending",
                      ),
                    ],
                  );
                }),

                const Spacer(),

                GestureDetector(
                  onTap: () {
                    controller.navigateToAddFriend();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.wp,
                      vertical: 2.5.sp,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.buttonGradientFor(context),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gradientDarkStart.withValues(
                            alpha: 0.25,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_add_alt_1,
                          size: 10.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 1.wp),
                        Text(
                          "Add",
                          style: TextStyle(
                            fontSize: 8.5.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.hp),

          // Friends List
          const Expanded(child: FriendsList()),
        ],
      ),
    );
  }
}

/*----- Friends Tab -----*/
class FriendTab extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const FriendTab({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2.sp),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: [
                    AppColors.gradientDarkStart,
                    AppColors.gradientDarkStart.withValues(alpha: 0.75),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : LinearGradient(
                  colors: [
                    AppColors.cardBg(context).withValues(alpha: 0.7),
                    AppColors.chipBg(context).withValues(alpha: 0.9),
                  ],
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.gradientDarkStart.withValues(alpha: 0.2)
                : AppColors.border(context),
            width: 1.2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.gradientDarkStart.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textPrimary(context),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 8.5.sp,
              ),
            ),

            SizedBox(width: 1.5.wp),

            // Count Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0.8.sp),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.gradientDarkStart.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 7.5.sp,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : AppColors.gradientDarkStart,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

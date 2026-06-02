import 'package:eventjar/controller/budget_track/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/budget_track/trip_model.dart';
import 'package:eventjar/page/budget_track/active_widget/active_animate_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActiveTripCard extends GetView<BudgetTrackController> {
  final int index;
  final TripModel trip;

  const ActiveTripCard({super.key, required this.index, required this.trip});

  String formatAmount(double amount) {
    if (amount >= 100000) {
      return "${(amount / 100000).toStringAsFixed(1)}L";
    }

    if (amount >= 1000) {
      return "${(amount / 1000).toStringAsFixed(1)}K";
    }

    return amount.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final totalBudget = trip.totalBudget;

    final spent = trip.teamShare;

    final progress = totalBudget > 0
        ? (spent / totalBudget).clamp(0.0, 1.0)
        : 0.0;

    final isOverBudget = spent > totalBudget;

    return AnimatedBorderCard(
      child: Container(
        padding: EdgeInsets.all(4.wp),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(14.sp),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE + ACTIVE
            Row(
              children: [
                Expanded(
                  child: Text(
                    trip.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.wp,
                    vertical: .4.hp,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 3,
                        backgroundColor: Colors.green,
                      ),
                      SizedBox(width: 1.wp),
                      Text(
                        "ACTIVE",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 6.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: .8.hp),

            // DESTINATION
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 8.sp,
                  color: AppColors.iconMuted(context),
                ),
                SizedBox(width: 1.wp),
                Expanded(
                  child: Text(
                    trip.destination,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 7.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: .8.hp),

            // EXPENSES + MEMBERS
            Text(
              "${trip.expensesCount} Expenses • ${trip.membersCount} Members",
              style: TextStyle(
                fontSize: 7.sp,
                color: AppColors.textSecondary(context),
              ),
            ),

            SizedBox(height: 1.2.hp),

            Divider(color: AppColors.divider(context)),

            SizedBox(height: 1.hp),

            // MY ANALYTICS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _amountItem(
                  label: "YOU OWE",
                  amount: trip.myOwe,
                  color: Colors.red,
                  context: context,
                ),

                _amountItem(
                  label: "YOU RECEIVE",
                  amount: trip.myReceive,
                  color: Colors.green,
                  context: context,
                ),

                _amountItem(
                  label: "MY SHARE",
                  amount: trip.myShare,
                  color: AppColors.gradientDarkStart,
                  context: context,
                ),
              ],
            ),

            SizedBox(height: 1.hp),

            Divider(color: AppColors.divider(context)),

            SizedBox(height: 1.5.hp),

            // BUDGET
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${formatAmount(spent)} SPENT",
                  style: TextStyle(
                    fontSize: 7.5.sp,
                    fontWeight: FontWeight.w600,
                    color: isOverBudget
                        ? Colors.red
                        : AppColors.textPrimary(context),
                  ),
                ),
                Text(
                  "₹${formatAmount(totalBudget)} BUDGET",
                  style: TextStyle(
                    fontSize: 7.5.sp,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),

            SizedBox(height: .7.hp),

            ClipRRect(
              borderRadius: BorderRadius.circular(10.sp),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: .9.hp,
                backgroundColor: AppColors.divider(context),
                valueColor: AlwaysStoppedAnimation(
                  isOverBudget ? Colors.red : AppColors.gradientDarkStart,
                ),
              ),
            ),

            SizedBox(height: .6.hp),

            Text(
              isOverBudget
                  ? "Exceeded by ₹${formatAmount(spent - totalBudget)}"
                  : "₹${formatAmount(totalBudget - spent)} left",
              style: TextStyle(
                fontSize: 7.sp,
                color: isOverBudget ? Colors.red : Colors.green,
              ),
            ),

            // DESCRIPTION
            if ((trip.description ?? "").isNotEmpty) ...[
              SizedBox(height: 1.5.hp),

              Obx(() {
                final expanded = controller.isExpanded(index);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.description!,
                      maxLines: expanded ? 5 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 7.sp,
                        color: AppColors.textSecondary(context),
                      ),
                    ),

                    SizedBox(height: .3.hp),

                    GestureDetector(
                      onTap: () {
                        HapticHelper.light();
                        controller.toggleNotes(index);
                      },
                      child: Text(
                        expanded ? "Show less" : "Read more",
                        style: TextStyle(
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gradientDarkStart,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _amountItem({
    required String label,
    required double amount,
    required Color color,
    required BuildContext context,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 6.5.sp,
            color: AppColors.textSecondary(context),
          ),
        ),
        SizedBox(height: .2.hp),
        Text(
          "₹${amount.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: amount > 0 ? color : AppColors.textPrimary(context),
          ),
        ),
      ],
    );
  }
}

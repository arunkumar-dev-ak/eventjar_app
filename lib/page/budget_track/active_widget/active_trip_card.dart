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
      return "${(amount / 100000).toStringAsFixed(1)}L+";
    }
    return amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    final computed = controller.computeTripAnalytics(trip.title);

    final youOwe = computed['youOwe']!;
    final youGet = computed['youReceive']!;
    final individualSpent = computed['yourSpent']!;
    final totalSpent = trip.totalSpent ?? individualSpent;
    final budget = trip.budget;

    final progress = budget != null
        ? (totalSpent / budget).clamp(0.0, 1.0)
        : 0.0;

    final isOverBudget = budget != null && totalSpent > budget;

    return AnimatedBorderCard(
      child: Container(
        padding: EdgeInsets.all(4.wp),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(14.sp),
          // boxShadow: [
          //   BoxShadow(
          //     color: AppColors.shadow(context),
          //     blurRadius: 8.sp,
          //     offset: Offset(0, 1.sp),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ───────── TITLE + STATUS ─────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    trip.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),

                /// ACTIVE BADGE
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.wp,
                    vertical: 0.4.hp,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 1.wp),
                      Text(
                        "ACTIVE",
                        style: TextStyle(
                          fontSize: 6.5.sp,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 0.6.hp),

            /// ───────── LOCATION ─────────
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
                    trip.location,
                    style: TextStyle(
                      fontSize: 7.sp,
                      color: AppColors.textSecondary(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            SizedBox(height: 0.6.hp),

            /// ───────── META ─────────
            Text(
              "${controller.getExpenseCount(trip.title)} Expenses • ${trip.members} Members",
              style: TextStyle(
                fontSize: 7.5.sp,
                color: AppColors.textSecondary(context),
              ),
            ),

            SizedBox(height: 1.2.hp),

            /// ───────── DIVIDER ─────────
            Divider(color: AppColors.divider(context)),

            SizedBox(height: 1.hp),

            /// ───────── AMOUNTS ─────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _amountItem(
                  label: "YOU OWE",
                  amount: youOwe,
                  color: Colors.red,
                  highlight: youOwe > 0,
                  context: context,
                ),
                _amountItem(
                  label: "YOU RECEIVE",
                  amount: youGet,
                  color: Colors.green,
                  highlight: youGet > 0,
                  context: context,
                ),
                _amountItem(
                  label: "SPENDING",
                  amount: individualSpent,
                  color: AppColors.gradientDarkStart,
                  highlight: youGet == 0 && youOwe == 0,
                  context: context,
                ),
              ],
            ),

            SizedBox(height: 1.hp),

            Divider(color: AppColors.divider(context)),

            /// ───────── BUDGET ─────────
            if (budget != null) ...[
              SizedBox(height: 1.8.hp),

              /// LABELS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹${formatAmount(totalSpent)} TOT SPENT",
                    style: TextStyle(
                      fontSize: 7.5.sp,
                      fontWeight: FontWeight.w600,
                      color: isOverBudget
                          ? Colors.red
                          : AppColors.textPrimary(context),
                    ),
                  ),
                  Text(
                    "₹${formatAmount(budget)} BUDGET",
                    style: TextStyle(
                      fontSize: 7.5.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 0.6.hp),

              /// PROGRESS BAR (more visible white bg)
              ClipRRect(
                borderRadius: BorderRadius.circular(6.sp),
                child: Container(
                  height: 1.hp,
                  color: AppColors.divider(context),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        color: AppColors.divider(context),
                      ),

                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isOverBudget
                                  ? [Colors.red.shade700, Colors.red]
                                  : [
                                      AppColors.gradientDarkStart,
                                      AppColors.gradientDarkEnd,
                                    ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 0.5.hp),

              /// STATUS
              Text(
                isOverBudget
                    ? "Exceeded by ₹${formatAmount(totalSpent - budget)}"
                    : "₹${formatAmount(budget - totalSpent)} left",
                style: TextStyle(
                  fontSize: 7.sp,
                  color: isOverBudget ? Colors.red : Colors.green,
                ),
              ),
            ],

            /// ───────── NOTES ─────────
            if (trip.notes != null && trip.notes!.isNotEmpty) ...[
              SizedBox(height: 1.5.hp),

              Obx(() {
                final isExpanded = controller.isExpanded(index);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.notes!,
                      maxLines: isExpanded ? 5 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 7.sp,
                        color: AppColors.textSecondary(context),
                      ),
                    ),

                    SizedBox(height: 0.3.hp),

                    GestureDetector(
                      onTap: () {
                        HapticHelper.light();
                        controller.toggleNotes(index);
                      },
                      child: Text(
                        isExpanded ? "Show less" : "Read more",
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

  /// 💰 AMOUNT ITEM
  Widget _amountItem({
    required String label,
    required double amount,
    required Color color,
    required bool highlight,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 6.5.sp,
            color: amount == 0
                ? AppColors.textSecondary(context)
                : (highlight ? color : AppColors.textPrimary(context)),
          ),
        ),
        SizedBox(height: 0.2.hp),
        Text(
          "₹${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: highlight ? 11.sp : 9.sp,
            fontWeight: FontWeight.bold,
            color: amount == 0
                ? AppColors.textSecondary(context)
                : (highlight ? color : AppColors.textPrimary(context)),
          ),
        ),
      ],
    );
  }
}

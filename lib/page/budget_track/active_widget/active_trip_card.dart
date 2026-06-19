import 'dart:ui';

import 'package:eventjar/controller/budget_track/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/delete_confirm_dialog.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalBudget = trip.totalBudget;
    final spent = trip.teamShare;
    final progress = totalBudget > 0
        ? (spent / totalBudget).clamp(0.0, 1.0)
        : 0.0;
    final isOverBudget = spent > totalBudget;

    return AnimatedBorderCard(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.sp),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: EdgeInsets.all(4.wp),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(14.sp),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.6),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER ROW
                Row(
                  children: [
                    // Trip icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.gradientDarkStart.withValues(alpha: 0.15),
                            AppColors.gradientDarkStart.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.flight_takeoff_rounded,
                        size: 20,
                        color: AppColors.gradientDarkStart,
                      ),
                    ),

                    SizedBox(width: 3.wp),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: 0.2.hp),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 12,
                                color: AppColors.textSecondary(context),
                              ),
                              SizedBox(width: 0.5.wp),
                              Expanded(
                                child: Text(
                                  trip.destination,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 7.5.sp,
                                    color: AppColors.textSecondary(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Active badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.wp,
                        vertical: 0.4.hp,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 1.wp),
                          Text(
                            "active".tr.toUpperCase(),
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 6.5.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (controller.isTripOwner(trip)) ...[
                      SizedBox(width: 1.5.wp),
                      GestureDetector(
                        onTap: () {
                          HapticHelper.medium();
                          _showDeleteDialog(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 1.hp),

                // STATS CHIPS
                Row(
                  children: [
                    _chipInfo(
                      "${trip.expensesCount} ${'expenses'.tr}",
                      Icons.receipt_outlined,
                      context,
                    ),
                    SizedBox(width: 2.wp),
                    _chipInfo(
                      "${trip.membersCount} ${'members'.tr}",
                      Icons.people_outline,
                      context,
                    ),
                    const Spacer(),
                    if (controller.isTripOwner(trip))
                      GestureDetector(
                        onTap: () {
                          HapticHelper.light();
                          controller.navigateToEditTrip(trip);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.5.wp,
                            vertical: 0.5.hp,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gradientDarkStart.withValues(
                              alpha: 0.08,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.gradientDarkStart.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 14,
                                color: AppColors.gradientDarkStart,
                              ),
                              SizedBox(width: 1.wp),
                              Text(
                                'edit'.tr,
                                style: TextStyle(
                                  fontSize: 7.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.gradientDarkStart,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 1.5.hp),

                // ANALYTICS ROW
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.wp,
                    vertical: 1.2.hp,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _analyticsItem(
                        "you_owe".tr.toUpperCase(),
                        trip.currency,
                        trip.myOwe,
                        Colors.red,
                        context,
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: AppColors.divider(context),
                      ),
                      _analyticsItem(
                        "you_receive".tr.toUpperCase(),
                        trip.currency,
                        trip.myReceive,
                        Colors.green,
                        context,
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: AppColors.divider(context),
                      ),
                      _analyticsItem(
                        "my_share".tr.toUpperCase(),
                        trip.currency,
                        trip.myShare,
                        AppColors.gradientDarkStart,
                        context,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 1.5.hp),

                // BUDGET PROGRESS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${trip.currency} ${formatAmount(spent)} ${"spent".tr}",
                      style: TextStyle(
                        fontSize: 7.5.sp,
                        fontWeight: FontWeight.w600,
                        color: isOverBudget
                            ? Colors.red
                            : AppColors.textPrimary(context),
                      ),
                    ),
                    Text(
                      "${trip.currency} ${formatAmount(totalBudget)} ${'budget_label'.tr}",
                      style: TextStyle(
                        fontSize: 7.5.sp,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 0.6.hp),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 0.8.hp,
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(
                      isOverBudget ? Colors.red : AppColors.gradientDarkStart,
                    ),
                  ),
                ),

                SizedBox(height: 0.4.hp),

                Text(
                  isOverBudget
                      ? "Exceeded by ${trip.currency} ${formatAmount(spent - totalBudget)}"
                      : "${trip.currency} ${formatAmount(totalBudget - spent)} ${'remaining'.tr}",
                  style: TextStyle(
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w500,
                    color: isOverBudget ? Colors.red : Colors.green,
                  ),
                ),

                // DESCRIPTION
                if ((trip.description ?? "").isNotEmpty) ...[
                  SizedBox(height: 1.2.hp),
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
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 0.3.hp),
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
        ),
      ),
    );
  }

  Widget _chipInfo(String text, IconData icon, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 0.4.hp),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary(context)),
          SizedBox(width: 1.wp),
          Text(
            text,
            style: TextStyle(
              fontSize: 7.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _analyticsItem(
    String label,
    String currency,
    double amount,
    Color color,
    BuildContext context,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 6.5.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary(context),
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 0.3.hp),
        Text(
          "$currency ${formatAmount(amount)}",
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w800,
            color: amount > 0 ? color : AppColors.textPrimary(context),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DeleteConfirmDialog(
        title: 'delete_trip'.tr,
        itemName: trip.name,
        warningText: "permanent_action_warning".tr,
        onDelete: () => controller.deleteTrip(trip),
      ),
    );
  }
}

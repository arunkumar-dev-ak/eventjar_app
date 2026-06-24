import 'package:eventjar/controller/budget_track/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/delete_confirm_dialog.dart';
import 'package:eventjar/model/budget_track/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InactiveTripCard extends GetView<BudgetTrackController> {
  final int index;
  final TripModel trip;

  const InactiveTripCard({super.key, required this.index, required this.trip});

  String get illustrationPath {
    final imageIndex = (index % 5) + 1;
    return "assets/illustration/ill$imageIndex.svg";
  }

  String formatAmount(double amount) {
    if (amount >= 100000) {
      return "${(amount / 100000).toStringAsFixed(1)}L";
    }

    if (amount >= 1000) {
      return "${(amount / 1000).toStringAsFixed(1)}K";
    }

    return amount.toStringAsFixed(0);
  }

  String formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) {
      return 'just_now'.tr;
    }

    if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    }

    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }

    if (diff.inDays == 1) {
      return 'yesterday'.tr;
    }

    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }

    final now = DateTime.now();

    if (date.year == now.year) {
      return DateFormat('MMM d').format(date);
    }

    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final youOwe = trip.myOwe;
    final youReceive = trip.myReceive;

    // fallback amount
    final myShare = trip.myShare;

    // status
    String statusText;
    Color statusColor;

    if (youReceive > 0) {
      statusText = "you_receive".tr.toUpperCase();
      statusColor = Colors.green;
    } else if (youOwe > 0) {
      statusText = "you_owe".tr.toUpperCase();
      statusColor = Colors.red;
    } else {
      statusText = "my_share".tr.toUpperCase();
      statusColor = AppColors.gradientDarkStart;
    }

    final mainAmount = youReceive > 0
        ? youReceive
        : youOwe > 0
        ? youOwe
        : myShare;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
      padding: EdgeInsets.all(2.5.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 6.sp,
            offset: Offset(0, 3.sp),
          ),
        ],
      ),
      child: Column(
        children: [
          // TOP
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.sp),
                child: SizedBox(
                  width: 14.wp,
                  height: 14.wp,
                  child: ColoredBox(
                    color: AppColors.lightBlueBg(context),
                    child: SvgPicture.asset(
                      illustrationPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 3.wp),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                    ),

                    SizedBox(height: .4.hp),

                    Text(
                      "${trip.expensesCount} ${'expenses'.tr} • ${trip.membersCount} ${'members'.tr}",
                      style: TextStyle(
                        fontSize: 7.5.sp,
                        color: AppColors.textSecondary(context),
                      ),
                    ),

                    SizedBox(height: .3.hp),

                    Text(
                      trip.destination,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 7.sp,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 3.wp),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (controller.isTripOwner(trip))
                    GestureDetector(
                      onTap: () {
                        HapticHelper.medium();
                        _showDeleteDialog(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 0.5.hp),
                        child: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ),

                  Text(
                    "${trip.currency} ${formatAmount(mainAmount)}",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),

                  SizedBox(height: .3.hp),

                  Text(
                    statusText,
                    style: TextStyle(fontSize: 7.sp, color: statusColor),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 1.5.hp),

          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.2.wp,
                  vertical: .5.hp,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightBlueBg(context),
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                child: Text(
                  "${'my_owe_members'.tr} : ${trip.myOweMembersCount}",
                  style: TextStyle(
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF5B9BEF)
                        : AppColors.gradientDarkStart,
                  ),
                ),
              ),

              SizedBox(width: 2.wp),

              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.2.wp,
                    vertical: .5.hp,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.chipBg(context),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Text(
                    "${'created_by'.tr} ${formatTimeAgo(trip.createdAt)}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 7.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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

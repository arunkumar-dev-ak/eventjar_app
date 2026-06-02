import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/model/view_trip/trip_friend_model.dart';
import 'package:flutter/material.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:get/get.dart';

class FriendsList extends GetView<ViewTripController> {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final friends = controller.state.friends;

      if (controller.state.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (friends.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 4.hp),
            child: Text(
              "No friends added yet",
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 10.sp,
              ),
            ),
          ),
        );
      }

      return Column(
        children: List.generate(
          friends.length,
          (index) => _friendItem(context, friends[index]),
        ),
      );
    });
  }

  Widget _friendItem(BuildContext context, TripFriendModel f) {
    final isOwe = f.balanceType == 'owe';
    final isReceive = f.balanceType == 'receive';
    final isSettled = f.balance == 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = f.displayName;

    return Container(
      margin: EdgeInsets.only(top: 1.hp),
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        border: Border.all(color: AppColors.budgetTabColor, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.darkCardElevated
                  : const Color(0xFFE0E0E0),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary(context),
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
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: 0.3.hp),
                _statusText(context, f, isOwe, isReceive, isSettled),
              ],
            ),
          ),

          _actionWidget(context, isOwe, isReceive, isSettled),
        ],
      ),
    );
  }

  Widget _statusText(
    BuildContext context,
    TripFriendModel f,
    bool isOwe,
    bool isReceive,
    bool isSettled,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isSettled) {
      return Text(
        "No dues",
        style: TextStyle(
          color: AppColors.textSecondary(context),
          fontSize: 8.5.sp,
        ),
      );
    }

    if (isOwe) {
      return Text(
        "You owe ₹${f.myOwe.toStringAsFixed(0)}",
        style: TextStyle(
          color: isDark ? Colors.red.shade300 : Colors.red.shade700,
          fontSize: 8.5.sp,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Text(
      "You receive ₹${f.myReceive.toStringAsFixed(0)}",
      style: TextStyle(
        color: isDark ? Colors.green.shade300 : Colors.green.shade700,
        fontSize: 8.5.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _actionWidget(
    BuildContext context,
    bool isOwe,
    bool isReceive,
    bool isSettled,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isSettled) {
      return Icon(
        Icons.check_circle_outline,
        color: isDark ? Colors.green.shade400 : Colors.green.shade600,
        size: 22,
      );
    }

    if (isOwe) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.5.wp, vertical: 0.8.hp),
        decoration: BoxDecoration(
          gradient: AppColors.buttonGradientFor(context),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "SettleUp",
          style: TextStyle(
            color: Colors.white,
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.5.wp, vertical: 0.8.hp),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Remind",
        style: TextStyle(
          color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
          fontSize: 8.5.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/model/budget_track/friend_model.dart';
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

      return Column(
        children: List.generate(
          friends.length,
          (index) => _friendItem(context, friends[index]),
        ),
      );
    });
  }

  // ================= ITEM =================
  Widget _friendItem(BuildContext context, FriendModel f) {
    final isOwe = f.youOwe && !f.isSettled;
    final isReceive = !f.youOwe && !f.isSettled;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          // PROFILE
          Stack(
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
              ),

              // ME TAG
              if (f.isYou)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "ME",
                      style: TextStyle(
                        color: isDark ? Colors.black : Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(width: 3.wp),

          // CENTER CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME
                Text(
                  f.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                    color: AppColors.textPrimary(context),
                  ),
                ),

                SizedBox(height: 0.3.hp),

                /// STATUS TEXT
                _statusText(context, f, isOwe, isReceive),
              ],
            ),
          ),

          // RIGHT ACTION
          _actionButton(context, f),
        ],
      ),
    );
  }

  /// ================= STATUS TEXT =================
  Widget _statusText(
    BuildContext context,
    FriendModel f,
    bool isOwe,
    bool isReceive,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (f.isSettled) {
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
        "You owe ₹${f.amount.toStringAsFixed(0)}",
        style: TextStyle(
          color: isDark ? Colors.red.shade300 : Colors.red.shade700,
          fontSize: 8.5.sp,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Text(
      "You receive ₹${f.amount.toStringAsFixed(0)}",
      style: TextStyle(
        color: isDark ? Colors.green.shade300 : Colors.green.shade700,
        fontSize: 8.5.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// ================= ACTION =================
  Widget _actionButton(BuildContext context, FriendModel f) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    /// ✅ SETTLED
    if (f.isSettled) {
      return Icon(
        Icons.check_circle_outline,
        color: isDark ? Colors.green.shade400 : Colors.green.shade600,
        size: 22,
      );
    }

    /// 🔴 YOU OWE → SETTLE (PRIMARY CTA)
    if (f.youOwe) {
      return InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Container(
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
        ),
      );
    }

    /// 🔵 YOU RECEIVE → REMIND (SECONDARY CTA)
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
      ),
    );
  }
}

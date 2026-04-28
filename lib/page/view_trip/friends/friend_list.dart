import 'package:eventjar/model/budget_track/friend_model.dart';
import 'package:flutter/material.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';

class FriendsList extends StatelessWidget {
  final List<FriendModel> friends = dummyFriends;

  FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        friends.length,
        (index) => _friendItem(context, friends[index]),
      ),
    );
  }

  // ================= ITEM =================
  Widget _friendItem(BuildContext context, FriendModel f) {
    final isOwe = f.youOwe && !f.isSettled;
    final isReceive = !f.youOwe && !f.isSettled;

    return Container(
      margin: EdgeInsets.only(top: 1.hp),
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        color: Colors.white,
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
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE0E0E0),
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
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "ME",
                      style: TextStyle(
                        color: Colors.white,
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
                  ),
                ),

                SizedBox(height: 0.3.hp),

                /// STATUS TEXT
                _statusText(f, isOwe, isReceive),
              ],
            ),
          ),

          // RIGHT ACTION
          _actionButton(f),
        ],
      ),
    );
  }

  /// ================= STATUS TEXT =================
  Widget _statusText(FriendModel f, bool isOwe, bool isReceive) {
    if (f.isSettled) {
      return Text(
        "No dues",
        style: TextStyle(color: Colors.grey, fontSize: 8.5.sp),
      );
    }

    if (isOwe) {
      return Text(
        "You owe ₹${f.amount.toStringAsFixed(0)}",
        style: TextStyle(
          color: Colors.red.shade700,
          fontSize: 8.5.sp,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Text(
      "You receive ₹${f.amount.toStringAsFixed(0)}",
      style: TextStyle(
        color: Colors.green.shade700,
        fontSize: 8.5.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// ================= ACTION =================
  Widget _actionButton(FriendModel f) {
    /// ✅ SETTLED
    if (f.isSettled) {
      return Icon(
        Icons.check_circle_outline,
        color: Colors.green.shade600,
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
            gradient: AppColors.buttonGradient, // ✅ YOUR GRADIENT
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
          color: Colors.blue.withValues(alpha: 0.1), // light blue bg
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "Remind",
          style: TextStyle(
            color: Colors.blue.shade700,
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

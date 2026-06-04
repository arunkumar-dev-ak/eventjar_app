import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/global/widget/empty_widget.dart';
import 'package:eventjar/model/view_trip/trip_friend_model.dart';
import 'package:eventjar/page/view_trip/friends/friend_shimmer_card.dart';
import 'package:eventjar/page/view_trip/friends/remove_member_dialog.dart';
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

      final isLoading = controller.state.isLoading.value;

      final haveNextPage = controller.hasFriendMore;

      // 🔥 FULL LOADING SHIMMER
      if (isLoading) {
        return Column(
          children: List.generate(5, (index) => const FriendShimmerCard()),
        );
      }

      // 🔥 EMPTY STATE
      if (friends.isEmpty) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 60.hp,
            child: EmptyStateWidget(
              icon: Icons.group_off,
              title: "No friends added yet",
              subtitle: "Add friends to start splitting expenses",
            ),
          ),
        );
      }

      // 🔥 DATA LIST
      return Column(
        children: List.generate(friends.length + (haveNextPage ? 1 : 0), (
          index,
        ) {
          if (index >= friends.length) {
            return const FriendShimmerCard();
          }

          return _friendItem(context, friends[index]);
        }),
      );
    });
  }

  Widget _friendItem(BuildContext context, TripFriendModel f) {
    // --- 1. SECURITY CHECK ---
    final currentUserId = UserStore.to.profile['id'];
    final creatorId = controller.state.trip.value?.createdById;

    // Only true if the logged-in user made the trip
    final isCurrentUserCreator = currentUserId == creatorId;

    // --- 2. YOUR CARD UI ---
    final isOwe = f.balanceType == 'owe';
    final isReceive = f.balanceType == 'receive';
    final isSettled = f.balance == 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = f.displayName;

    final card = Container(
      margin: EdgeInsets.only(top: 1.hp),
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        border: Border.all(color: AppColors.budgetTabColor, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isDark
                ? AppColors.darkCardElevated
                : const Color(0xFFE0E0E0),
            child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?'),
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
                _statusText(context, f),
              ],
            ),
          ),

          _actionWidget(context, f, isOwe, isReceive, isSettled),
        ],
      ),
    );

    // --- 3. SWIPE TO DELETE LOGIC ---
    // If the user is NOT the creator, just return the static card (Disables the swipe).
    if (!isCurrentUserCreator) {
      return card;
    }

    // IF ALLOWED: Return the swipeable Dismissible
    return Dismissible(
      key: ValueKey(f.memberId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(top: 1.hp),
        padding: EdgeInsets.only(right: 5.wp),
        decoration: BoxDecoration(
          color: Colors.red.shade500,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.person_remove_rounded, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        HapticHelper.medium();
        // Open the modern stateless confirmation dialog
        final result = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) =>
              RemoveMemberDialog(memberName: name, memberId: f.memberId),
        );
        return result == true;
      },
      onDismissed: (_) {
        // UI handles removal automatically via the controller's refresh mechanism
      },
      child: card,
    );
  }

  Widget _statusText(BuildContext context, TripFriendModel f) {
    if (f.balance == 0) {
      return Text(
        "No dues",
        style: TextStyle(
          color: AppColors.textSecondary(context),
          fontSize: 8.5.sp,
        ),
      );
    }

    if (f.balanceType == 'owe') {
      return Text(
        "You owe ₹${f.myOwe.toStringAsFixed(0)}",
        style: TextStyle(
          color: Colors.red,
          fontSize: 8.5.sp,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Text(
      "You receive ₹${f.myReceive.toStringAsFixed(0)}",
      style: TextStyle(
        color: Colors.green,
        fontSize: 8.5.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _actionWidget(
    BuildContext context,
    TripFriendModel f,
    bool isOwe,
    bool isReceive,
    bool isSettled,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isSettled) {
      return Icon(Icons.check_circle_outline, color: Colors.green, size: 22);
    }

    // ❌ OWE → SettleUp
    if (isOwe) {
      return InkWell(
        onTap: () =>
            controller.openPaymentDialog(f, PaymentActionType.settleUp),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.5.wp, vertical: 0.8.hp),
          decoration: BoxDecoration(
            gradient: AppColors.buttonGradientFor(context),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text("SettleUp", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    // ✅ RECEIVE → Record
    return InkWell(
      onTap: () => controller.openPaymentDialog(f, PaymentActionType.record),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.5.wp, vertical: 0.8.hp),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "Record",
          style: TextStyle(color: Colors.blue, fontSize: 8.5.sp),
        ),
      ),
    );
  }
}

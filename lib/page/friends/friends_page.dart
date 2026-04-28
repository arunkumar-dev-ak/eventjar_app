import 'package:eventjar/controller/friends/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/budget_track/friend_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsPage extends GetView<FriendsController> {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Friends",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appBarGradient),
        ),
      ),

      /// BODY
      body: Obx(() {
        final friends = controller.state.friends;

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
          itemCount: friends.length,
          itemBuilder: (_, index) {
            final f = friends[index];

            return Column(
              children: [
                _friendItem(context, f),

                Padding(
                  padding: EdgeInsets.only(left: 60),
                  child: Divider(thickness: 0.6, color: Colors.grey.shade300),
                ),
              ],
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.navigateToAddFriend();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  PopupMenuItem<FriendAction> _menuItem(
    IconData icon,
    String text,
    FriendAction action,
  ) {
    return PopupMenuItem(
      value: action,
      child: Row(
        children: [Icon(icon, size: 18), SizedBox(width: 8), Text(text)],
      ),
    );
  }

  /// ================= ITEM =================
  Widget _friendItem(BuildContext context, FriendModel f) {
    final isOwe = f.youOwe && !f.isSettled;
    final isReceive = !f.youOwe && !f.isSettled;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.2.hp),
      child: Row(
        children: [
          /// LEFT - AVATAR
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade300,
            child: Text(f.name[0], style: const TextStyle(color: Colors.black)),
          ),

          SizedBox(width: 3.wp),

          /// CENTER
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  f.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                  ),
                ),

                SizedBox(height: 0.3.hp),

                Text(
                  f.email,
                  style: TextStyle(fontSize: 8.sp, color: Colors.grey),
                ),

                SizedBox(height: 0.4.hp),

                _statusText(f, isOwe, isReceive),
              ],
            ),
          ),

          /// RIGHT - MENU
          PopupMenuButton<FriendAction>(
            icon: Icon(Icons.more_vert, color: AppColors.textPrimary(context)),
            itemBuilder: (_) {
              final List<PopupMenuEntry<FriendAction>> menu = [];

              if (f.youOwe && !f.isSettled) {
                menu.add(
                  _menuItem(Icons.list, "View Trips", FriendAction.viewTrips),
                );
              }

              if (!f.youOwe && !f.isSettled) {
                menu.add(
                  _menuItem(Icons.notifications, "Remind", FriendAction.remind),
                );
              }

              menu.add(_menuItem(Icons.delete, "Remove", FriendAction.remove));

              return menu;
            },
            onSelected: (action) => controller.handleAction(context, action, f),
          ),
        ],
      ),
    );
  }

  /// ================= STATUS =================
  Widget _statusText(FriendModel f, bool isOwe, bool isReceive) {
    if (f.isSettled) {
      return SizedBox.shrink();
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
}

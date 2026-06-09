import 'package:eventjar/controller/friends/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/global/widget/empty_widget.dart';
import 'package:eventjar/model/budget_track/split_track_friend_model.dart';
import 'package:eventjar/page/friends/widget/friend_list_shimmer.dart';
import 'package:eventjar/page/friends/widget/friend_list_utils.dart';
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
          'friends'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarGradientFor(context),
          ),
        ),
        centerTitle: false,
      ),

      /// BODY
      body: Obx(() {
        if (controller.state.isLoading.value &&
            controller.state.friends.isEmpty) {
          return const FriendListShimmer();
        }

        final friends = controller.state.friends;

        if (friends.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.people_outline,
            title: 'no_friends_yet'.tr,
            subtitle: "add_friends_split_desc".tr,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshFriends,
          child: ListView.builder(
            controller: controller.friendScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
            itemCount: controller.hasNextPage
                ? friends.length + 1
                : friends.length,
            itemBuilder: (_, index) {
              if (index >= friends.length) {
                return const FriendCardShimmer();
              }

              final friend = friends[index];

              return Column(
                children: [
                  _friendItem(context, friend),

                  Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: Divider(
                      thickness: 0.6,
                      color: AppColors.divider(context),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticHelper.medium();
          controller.navigateToAddFriend();
        },
        icon: const Icon(Icons.add),
        label: Text("new_friend".tr),
      ),
    );
  }

  PopupMenuItem<FriendAction> _menuItem(
    BuildContext context,
    IconData icon,
    String text,
    FriendAction action,
  ) {
    final color = AppColors.textPrimary(context);
    return PopupMenuItem(
      value: action,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          SizedBox(width: 8),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  /// ================= ITEM =================
  Widget _friendItem(BuildContext context, SplitTrackFriend friend) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final displayName = friend.invitedName.isNotEmpty
        ? friend.invitedName
        : (friend.friendUser?.name ?? "");

    final displayEmail = friend.invitedEmail.isNotEmpty
        ? friend.invitedEmail
        : (friend.friendUser?.email ?? "");

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.2.hp),
      child: Row(
        children: [
          _buildAvatar(context, friend, displayName, isDark),

          SizedBox(width: 3.wp),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                    color: AppColors.textPrimary(context),
                  ),
                ),

                if (displayEmail.isNotEmpty) ...[
                  SizedBox(height: 0.3.hp),

                  Text(
                    displayEmail,
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],

                SizedBox(height: 0.5.hp),

                _statusWidget(context, friend),
              ],
            ),
          ),

          PopupMenuButton<FriendAction>(
            icon: Icon(Icons.more_vert, color: AppColors.textPrimary(context)),
            itemBuilder: (_) {
              final List<PopupMenuEntry<FriendAction>> menu = [];

              final isPending = friend.status.toLowerCase() == "pending";
              final isAccepted = friend.status.toLowerCase() == "accepted";

              final isSender = isSenderForFriendList(friend);
              final isReceiver = isReceiverForFriendList(friend);

              if (isPending && isReceiver) {
                menu.add(
                  _menuItem(
                    context,
                    Icons.check_circle,
                    "accept_invitation".tr,
                    FriendAction.accept,
                  ),
                );

                menu.add(
                  _menuItem(
                    context,
                    Icons.cancel,
                    "reject_invitation".tr,
                    FriendAction.reject,
                  ),
                );
              }

              if ((isPending && isSender)) {
                menu.add(
                  _menuItem(
                    context,
                    Icons.delete_outline,
                    "remove_invitation".tr,
                    FriendAction.remove,
                  ),
                );
              }

              if (isAccepted) {
                menu.add(
                  _menuItem(
                    context,
                    Icons.delete_outline,
                    "remove_friend".tr,
                    FriendAction.remove,
                  ),
                );
              }

              return menu;
            },
            onSelected: (action) {
              HapticHelper.selection();

              switch (action) {
                case FriendAction.accept:
                  controller.acceptFriend(friend);
                  break;

                case FriendAction.reject:
                  controller.rejectFriend(friend);
                  break;

                case FriendAction.remove:
                  controller.deleteFriend(friend);
                  break;
              }
            },
          ),
        ],
      ),
    );
  }

  /// ================= AVATAR =================
  Widget _buildAvatar(
    BuildContext context,
    SplitTrackFriend friend,
    String displayName,
    bool isDark,
  ) {
    final avatarUrl = friend.friendUser?.avatarUrl;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return CircleAvatar(
      radius: 22,
      backgroundColor: isDark
          ? AppColors.darkCardElevated
          : Colors.grey.shade300,
      backgroundImage: hasAvatar ? NetworkImage(getFileUrl(avatarUrl)) : null,
      child: hasAvatar
          ? null
          : Text(
              displayName.isNotEmpty ? displayName[0].toUpperCase() : "?",
              style: TextStyle(color: AppColors.textPrimary(context)),
            ),
    );
  }

  /// ================= STATUS =================
  Widget _statusWidget(BuildContext context, SplitTrackFriend friend) {
    final status = getStatusTextForFriendList(friend);
    if (status == "friend".tr) {
      return SizedBox.shrink();
    }
    return Text(
      status,
      style: TextStyle(
        color: getStatusColorForFriendList(context, friend),
        fontSize: 8.5.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

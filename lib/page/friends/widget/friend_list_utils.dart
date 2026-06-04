import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/model/budget_track/split_track_friend_model.dart';
import 'package:flutter/material.dart';

bool isSenderForFriendList(SplitTrackFriend friend) {
  return friend.userId == UserStore.to.profile['id'];
}

bool isReceiverForFriendList(SplitTrackFriend friend) {
  return friend.userId != UserStore.to.profile['id'];
}

String getStatusTextForFriendList(SplitTrackFriend friend) {
  if (friend.status == "accepted") {
    return "Friend";
  }

  if (friend.status == "pending") {
    return isSenderForFriendList(friend)
        ? "Invitation Sent"
        : "Invitation Received";
  }

  if (friend.status == "rejected") {
    return "Invitation Rejected";
  }

  return friend.status;
}

Color getStatusColorForFriendList(
  BuildContext context,
  SplitTrackFriend friend,
) {
  if (friend.status == "accepted") {
    return Colors.green;
  }

  if (friend.status == "pending") {
    return isSenderForFriendList(friend) ? Colors.blue : Colors.orange;
  }

  if (friend.status == "rejected") {
    return Colors.red;
  }

  return AppColors.textSecondary(context);
}

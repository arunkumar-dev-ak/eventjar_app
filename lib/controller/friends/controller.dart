import 'package:eventjar/controller/friends/state.dart';
import 'package:eventjar/model/budget_track/friend_model.dart';
import 'package:eventjar/page/friends/widget/bottom_sheet_friends_page.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum FriendAction { viewTrips, remind, remove }

class FriendsController extends GetxController {
  final state = FriendsState();

  @override
  void onInit() {
    super.onInit();
    loadDummyFriends();
  }

  void loadDummyFriends() {
    state.friends.assignAll(dummyFriends);
  }

  void openTrips(FriendModel friend) {
    Get.bottomSheet(_buildTripsSheet(friend), isScrollControlled: true);
  }

  void navigateToAddFriend() {
    Get.toNamed(RouteName.addFriendPage)?.then((result) async {
      // if (result == "logged_in") {
      //   await fetchContactsOnFirstLoad();
      // } else {
      //   Get.back();
      // }
    });
  }

  Widget _buildTripsSheet(FriendModel friend) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (_, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Get.theme.cardColor,
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: 3,
            itemBuilder: (_, i) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Get.theme.scaffoldBackgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Goa Trip",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    const Text("Pending: ₹300"),
                    const Text("You owe: ₹150"),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Pay"),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text("Remind"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void handleAction(BuildContext context, FriendAction action, FriendModel f) {
    switch (action) {
      case FriendAction.viewTrips:
        _openTripsBottomSheet(context, f);
        break;
      case FriendAction.remind:
        Get.snackbar("Reminder", "Reminder sent to ${f.name}");
        break;
      case FriendAction.remove:
        Get.snackbar("Removed", "${f.name} removed");
        break;
    }
  }

  void _openTripsBottomSheet(BuildContext context, FriendModel f) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TripsBottomSheetFriendList(friend: f),
    );
  }
}

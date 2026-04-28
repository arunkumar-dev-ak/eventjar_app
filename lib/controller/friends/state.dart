import 'package:eventjar/model/budget_track/friend_model.dart';
import 'package:get/get.dart';

class FriendsState {
  final RxList<FriendModel> friends = <FriendModel>[].obs;

  RxBool isLoading = false.obs;
}

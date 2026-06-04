import 'package:eventjar/model/budget_track/split_track_friend_model.dart';
import 'package:get/get.dart';

class FriendsState {
  final RxList<SplitTrackFriend> friends = <SplitTrackFriend>[].obs;

  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;

  Rxn<SplitTrackPagination> pagination = Rxn<SplitTrackPagination>();
}

import 'package:eventjar/model/budget_track/friend_model.dart';
import 'package:eventjar/model/budget_track/trip_model.dart';
import 'package:eventjar/model/meta/mobile_meta_model.dart';
import 'package:eventjar/model/view_trip/trip_expense_model.dart';
import 'package:eventjar/model/view_trip/trip_friend_model.dart';
import 'package:get/get.dart';

class ViewTripState {
  // RxBool isLoading = false.obs;
  // RxBool isPaginationLoading = false.obs;

  // RxInt expenseOpenedIndex = (-1).obs;
  // RxSet<int> expenseSelectedIndexes = <int>{}.obs;
  // RxBool showLongPressHint = true.obs;

  // final Rxn<TripModel> trip = Rxn<TripModel>();

  // RxString tripId = ''.obs;

  // RxList<FriendModel> friends = <FriendModel>[].obs;
  // Rxn<MobileMeta> friendMeta = Rxn<MobileMeta>();

  // RxList<TripExpenseModel> expenses = <TripExpenseModel>[].obs;
  // Rxn<MobileMeta> expenseMeta = Rxn<MobileMeta>();
  RxInt selectedTab = 0.obs;

  RxList<TripExpenseModel> expenses = <TripExpenseModel>[].obs;
  RxList<TripFriendModel> friends = <TripFriendModel>[].obs;

  Rxn<MobileMeta> expenseMeta = Rxn<MobileMeta>();
  Rxn<MobileMeta> friendMeta = Rxn<MobileMeta>();

  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;
  RxBool isFriendPaginationLoading = false.obs;

  RxString tripId = ''.obs;
}

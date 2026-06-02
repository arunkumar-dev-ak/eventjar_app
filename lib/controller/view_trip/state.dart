import 'package:eventjar/model/budget_track/trip_model.dart';
import 'package:eventjar/model/meta/mobile_meta_model.dart';
import 'package:eventjar/model/view_trip/trip_expense_model.dart';
import 'package:eventjar/model/view_trip/trip_friend_model.dart';
import 'package:get/get.dart';

class ViewTripState {
  RxInt selectedTab = 0.obs;

  RxString tripId = ''.obs;

  RxList<TripExpenseModel> expenses = <TripExpenseModel>[].obs;
  RxList<TripFriendModel> friends = <TripFriendModel>[].obs;

  Rxn<MobileMeta> expenseMeta = Rxn<MobileMeta>();

  Rxn<TripModel> trip = Rxn<TripModel>();
  Rxn<MobileMeta> friendMeta = Rxn<MobileMeta>();

  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;
  RxBool isFriendPaginationLoading = false.obs;

  RxBool isFriendsLoaded = false.obs;

  RxInt expenseOpenedIndex = (-1).obs;
  RxSet<int> expenseSelectedIndexes = <int>{}.obs;
  RxBool showLongPressHint = true.obs;

  final RxString paymentMethod = 'UPI'.obs;
  final List<String> paymentMethods = ['Cash', 'UPI', 'Bank Transfer', 'Other'];
  RxBool isSettleupLoading = false.obs;
}

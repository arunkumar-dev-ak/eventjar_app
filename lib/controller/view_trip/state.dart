import 'package:eventjar/model/budget_track/friend_model.dart';
import 'package:eventjar/model/budget_track/trip_model.dart';
import 'package:eventjar/model/meta/mobile_meta_model.dart';
import 'package:eventjar/model/view_trip/trip_expense_model.dart';
import 'package:get/get.dart';

class ViewTripState {
  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;

  RxInt expenseOpenedIndex = (-1).obs;
  RxSet<int> expenseSelectedIndexes = <int>{}.obs;
  RxInt selectedTab = 0.obs;
  RxBool showLongPressHint = true.obs;

  final Rxn<TripModel> trip = Rxn<TripModel>();

  RxString tripId = ''.obs;

  Rxn<MobileMeta> meta = Rxn<MobileMeta>();

  RxList<FriendModel> friends = <FriendModel>[].obs;

  RxList<TripExpenseModel> expenses = <TripExpenseModel>[].obs;
}

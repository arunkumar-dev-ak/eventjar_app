import 'package:eventjar/model/budget_track/expense_model.dart';
import 'package:eventjar/model/budget_track/friend_model.dart';
import 'package:eventjar/model/budget_track/trip_model.dart';
import 'package:get/get.dart';

class ViewTripState {
  RxBool isLoading = false.obs;

  RxInt expenseOpenedIndex = (-1).obs;
  RxSet<int> expenseSelectedIndexes = <int>{}.obs;
  RxInt selectedTab = 0.obs;
  RxBool showLongPressHint = true.obs;

  final Rxn<TripModel> trip = Rxn<TripModel>();
  RxList<FriendModel> friends = <FriendModel>[].obs;
  RxList<ExpenseModel> expense = <ExpenseModel>[].obs;
}

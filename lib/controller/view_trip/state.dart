import 'package:get/get.dart';

class ViewTripState {
  RxBool isLoading = false.obs;

  RxInt expenseOpenedIndex = (-1).obs;
  RxSet<int> expenseSelectedIndexes = <int>{}.obs;
  RxInt selectedTab = 0.obs;
}

import 'package:get/get_rx/src/rx_types/rx_types.dart';

class BudgetTrackState {
  final RxBool isLoading = true.obs;

  final RxInt selectedMainTab = 0.obs;

  final RxString selectedFilter = 'All'.obs;
}

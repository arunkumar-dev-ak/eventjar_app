import 'package:eventjar/model/transaction/transaction_model.dart';
import 'package:get/get.dart';

class TransactionState {
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxInt displayedMonth = DateTime.now().month.obs;
  RxInt displayedYear = DateTime.now().year.obs;

  RxList<Transaction> transactions = <Transaction>[].obs;
  Rx<DailyTotal> dailyTotal = DailyTotal(paid: 0, received: 0).obs;
  Rxn<String> nextCursor = Rxn<String>();
  RxBool hasNextPage = false.obs;
}

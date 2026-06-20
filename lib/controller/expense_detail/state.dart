import 'package:eventjar/model/expense_detail/expense_detail_model.dart';
import 'package:eventjar/model/meta/mobile_meta_model.dart';
import 'package:eventjar/model/view_trip/trip_expense_model.dart';
import 'package:get/get.dart';

class ExpenseDetailState {
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasError = false.obs;
  RxString appBarTitle = ''.obs;

  RxBool isEditLoading = false.obs;

  Rx<TripExpenseModel?> expense = Rx<TripExpenseModel?>(null);
  RxList<ExpenseParticipantModel> participants =
      <ExpenseParticipantModel>[].obs;
  Rx<MobileMeta?> meta = Rx<MobileMeta?>(null);
}

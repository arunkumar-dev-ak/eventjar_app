import 'package:eventjar/controller/expense_detail/state.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ExpenseDetailController extends GetxController {
  final state = ExpenseDetailState();

  @override
  void onInit() {
    UserStore.cancelAllRequests();

    super.onInit();
  }
}

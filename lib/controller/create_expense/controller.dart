import 'package:eventjar/controller/create_expense/state.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CreateExpenseController extends GetxController {
  final state = CreateExpenseState();

  final appBarTitle = "Create Expense";

  @override
  void onInit() {
    super.onInit();
  }
}

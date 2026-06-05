import 'package:eventjar/controller/expense_detail/controller.dart';
import 'package:get/get.dart';

class ExpenseDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseDetailController>(() => ExpenseDetailController());
  }
}

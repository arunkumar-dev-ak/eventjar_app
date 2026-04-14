import 'package:eventjar/controller/create_expense/controller.dart';
import 'package:get/get.dart';

class CreateExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateExpenseController>(() => CreateExpenseController());
  }
}

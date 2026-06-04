import 'package:eventjar/controller/transaction/controller.dart';
import 'package:get/get.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionController>(() => TransactionController());
  }
}

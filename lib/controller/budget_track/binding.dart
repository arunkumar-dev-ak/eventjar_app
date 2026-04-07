import 'package:eventjar/controller/budget_track/controller.dart';
import 'package:get/get.dart';

class BudgetTrackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BudgetTrackController>(() => BudgetTrackController());
  }
}

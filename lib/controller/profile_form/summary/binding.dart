import 'package:eventjar/controller/profile_form/summary/controller.dart';
import 'package:get/get.dart';

class SummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SummaryFormController>(() => SummaryFormController());
  }
}

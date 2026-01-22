import 'package:eventjar/controller/reminder/controller.dart';
import 'package:get/get.dart';

class ReminderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReminderController>(() => ReminderController());
  }
}

import 'package:eventjar/controller/scheduler/controller.dart';
import 'package:get/get.dart';

class SchedulerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SchedulerController>(() => SchedulerController());
  }
}

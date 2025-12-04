import 'package:eventjar/controller/schedule_meeting/controller.dart';
import 'package:get/get.dart';

class ScheduleMeetingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleMeetingController>(() => ScheduleMeetingController());
  }
}

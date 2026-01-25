import 'package:eventjar/controller/meeting/controller.dart';
import 'package:get/get.dart';

class MeetingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeetingController>(() => MeetingController());
  }
}

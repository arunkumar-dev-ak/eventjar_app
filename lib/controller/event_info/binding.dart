import 'package:eventjar/controller/event_info/controller.dart';
import 'package:get/get.dart';

class EventInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventInfoController>(() => EventInfoController());
  }
}

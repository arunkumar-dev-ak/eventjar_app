import 'package:eventjar_app/controller/event_info/controller.dart';
import 'package:eventjar_app/controller/home/binding.dart';
import 'package:get/get.dart';

class EventInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventInfoController>(() => EventInfoController());
    HomeBinding().dependencies();
  }
}

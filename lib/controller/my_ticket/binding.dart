import 'package:eventjar_app/controller/my_ticket/controller.dart';
import 'package:get/get.dart';

class MyTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyTicketController>(() => MyTicketController());
  }
}

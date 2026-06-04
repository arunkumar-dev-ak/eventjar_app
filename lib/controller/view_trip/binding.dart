import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:get/get.dart';

class ViewTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewTripController>(() => ViewTripController());
  }
}

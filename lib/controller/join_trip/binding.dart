import 'package:eventjar/controller/join_trip/controller.dart';
import 'package:get/get.dart';

class JoinTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JoinTripController>(() => JoinTripController());
  }
}

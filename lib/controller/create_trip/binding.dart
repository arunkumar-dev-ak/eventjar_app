import 'package:eventjar/controller/create_trip/controller.dart';
import 'package:get/get.dart';

class CreateTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateTripController>(() => CreateTripController());
  }
}

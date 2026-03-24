import 'package:eventjar/controller/profile_form/location/controller.dart';
import 'package:get/get.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationFormController>(() => LocationFormController());
  }
}

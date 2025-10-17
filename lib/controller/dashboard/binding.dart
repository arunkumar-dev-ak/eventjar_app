import 'package:eventjar_app/controller/dashboard/controller.dart';
import 'package:eventjar_app/controller/home/binding.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    HomeBinding().dependencies();
  }
}

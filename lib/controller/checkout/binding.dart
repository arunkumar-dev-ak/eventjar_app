import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/controller/home/binding.dart';
import 'package:get/get.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(() => CheckoutController());
    HomeBinding().dependencies();
  }
}

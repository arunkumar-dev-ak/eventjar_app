import 'package:eventjar/controller/dashboard/controller.dart';
import 'package:eventjar/controller/home/binding.dart';
import 'package:eventjar/controller/my_ticket/controller.dart';
import 'package:eventjar/controller/network/controller.dart';
import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    HomeBinding().dependencies();
    Get.lazyPut<MyTicketController>(() => MyTicketController());
    Get.lazyPut<UserProfileController>(() => UserProfileController());
    Get.lazyPut<NetworkScreenController>(() => NetworkScreenController());
  }
}

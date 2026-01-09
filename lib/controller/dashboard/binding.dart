import 'package:eventjar/controller/dashboard/controller.dart';
import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/controller/my_ticket/controller.dart';
import 'package:eventjar/controller/network/controller.dart';
import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<UserProfileController>(() => UserProfileController());
    Get.lazyPut<NetworkScreenController>(() => NetworkScreenController());
    Get.lazyPut<MyTicketController>(() => MyTicketController());
  }
}

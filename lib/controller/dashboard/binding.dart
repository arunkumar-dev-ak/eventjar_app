import 'package:eventjar_app/controller/dashboard/controller.dart';
import 'package:eventjar_app/controller/home/binding.dart';
import 'package:eventjar_app/controller/my_ticket/controller.dart';
import 'package:eventjar_app/controller/user_profile/controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    HomeBinding().dependencies();
    Get.lazyPut<MyTicketController>(() => MyTicketController(), fenix: true);
    Get.lazyPut<UserProfileController>(
      () => UserProfileController(),
      fenix: true,
    );
  }
}

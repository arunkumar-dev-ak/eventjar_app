import 'package:eventjar/controller/dashboard/state.dart';
import 'package:eventjar/controller/network/controller.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var appBarTitle = "EventJar";
  final state = DashboardState();

  void onInint() {
    super.onInit();
  }

  void handleNetworkTabSwitch() {
    final isLoggedIn = UserStore.to.isLogin;
    if (!isLoggedIn) {
      Get.toNamed(RouteName.signInPage)?.then((result) async {
        if (result == "logged_in") {
          state.selectedIndex.value = 1;
          if (!Get.isRegistered<NetworkScreenController>()) {
            Get.put(NetworkScreenController()).onTabOpen();
          } else {
            Get.find<NetworkScreenController>().onTabOpen();
          }
        }
      });
    } else {
      state.selectedIndex.value = 1;
      if (!Get.isRegistered<NetworkScreenController>()) {
        Get.put(NetworkScreenController()).onTabOpen();
      } else {
        Get.find<NetworkScreenController>().onTabOpen();
      }
    }
  }
}

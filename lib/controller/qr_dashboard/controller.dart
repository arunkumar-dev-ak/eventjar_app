import 'package:eventjar/controller/qr_dashboard/state.dart';
import 'package:get/get.dart';

import '../../routes/route_name.dart';

class QrDashboardController extends GetxController {
  var appBarTitle = "EventJar";
  final state = QrDashboardState();

  void onInint() {
    super.onInit();
  }

  void navigateToAddContact() {
    Get.toNamed(RouteName.addContactPage);
  }
}

import 'package:eventjar/controller/scheduler/state.dart';
import 'package:get/get.dart';

class SchedulerController extends GetxController {
  var state = SchedulerState();

  @override
  void onInit() {
    super.onInit();
  }

  void onOpen() {}

  void changeTab(int index) {
    state.selectedTab.value = index;
    update();
  }
}

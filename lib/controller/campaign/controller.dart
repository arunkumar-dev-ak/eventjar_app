import 'package:eventjar/controller/campaign/state.dart';
import 'package:get/get.dart';

class CampaignController extends GetxController {
  var state = CampaignState();

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

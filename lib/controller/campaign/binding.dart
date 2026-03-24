import 'package:eventjar/controller/campaign/controller.dart';
import 'package:get/get.dart';

class CampaignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CampaignController>(() => CampaignController());
  }
}

import 'package:get/get.dart';

class CampaignState {
  RxBool isLoading = false.obs;

  RxInt selectedTab = 0.obs;
  RxInt sendCount = 12.obs;
  RxInt receivedCount = 1042.obs;
}

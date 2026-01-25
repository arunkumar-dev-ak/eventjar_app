import 'package:eventjar/model/connection/connection_model.dart';
import 'package:get/get.dart';

class ConnState {
  RxBool isLoading = false.obs;
  RxBool isSentLoadingMore = false.obs;
  RxBool isReceivedLoadingMore = false.obs;

  RxInt selectedTab = 0.obs;
  RxInt sendCount = 12.obs;
  RxInt receivedCount = 1042.obs;

  Rx<SentRequests?> sent = Rx<SentRequests?>(null);
  Rx<ReceivedRequests?> received = Rx<ReceivedRequests?>(null);

  List<String> statusItems = [
    'all',
    'pending',
    'declined',
    'accepted',
    'maybe_later',
  ];
  Rxn<String> selectedStatus = Rxn();

  RxMap<String, bool> buttonLoading = <String, bool>{}.obs;
}

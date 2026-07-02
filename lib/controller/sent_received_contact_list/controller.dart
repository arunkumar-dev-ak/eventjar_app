import 'package:eventjar/controller/sent_received_contact_list/state.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:get/get.dart';

class SentReceivedContactListController extends GetxController {
  var appBarTitle = "Contact Share List".tr;
  final state = SentReceivedContactListState();

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    super.onInit();
  }
}

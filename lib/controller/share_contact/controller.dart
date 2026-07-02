import 'package:eventjar/controller/share_contact/state.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:get/get.dart';

class ShareContactController extends GetxController {
  var appBarTitle = "Contact Share List".tr;
  final state = ShareContactState();

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    super.onInit();
  }
}

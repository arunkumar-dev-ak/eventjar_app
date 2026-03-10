import 'package:eventjar/controller/reminder/state.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:get/get.dart';

class ReminderController extends GetxController {
  var state = ReminderState();

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    super.onInit();
  }

  void onOpen() {}
}

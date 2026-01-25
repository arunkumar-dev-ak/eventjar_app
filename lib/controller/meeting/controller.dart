import 'package:eventjar/controller/meeting/state.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MeetingController extends GetxController {
  var appBarTitle = "My Meeting";

  final state = MeetingState();

  @override
  void onInit() {
    super.onInit();
  }
}

import 'package:eventjar/controller/contact/state.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  var appBarTitle = "Contact Page";
  final state = ContactState();

  @override
  void onInit() {
    super.onInit();
    // Retrieve from Get.arguments on page init
    final args = Get.arguments;
    if (args != null) {
      state.selectedTab.value = args;
    }
  }

  void toggleFilterRow() {
    state.showFilterRow.value = !state.showFilterRow.value;
  }
}

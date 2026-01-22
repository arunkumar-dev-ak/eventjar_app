import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:get/get.dart';

class ThankYouMessageState {
  final RxBool isLoading = false.obs;

  Rx<MobileContact?> contact = Rx<MobileContact?>(null);

  // For Thank You message popup
  var emailChecked = true.obs;
  var whatsappChecked = false.obs;
}

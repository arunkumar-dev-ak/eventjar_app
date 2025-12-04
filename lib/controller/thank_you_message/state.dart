import 'package:eventjar/model/contact/contact_model.dart';
import 'package:get/get.dart';

class ThankYouMessageState {
  final RxBool isLoading = false.obs;

  Rx<Contact?> contact = Rx<Contact?>(null);

  // For Thank You message popup
  var emailChecked = true.obs;
  var whatsappChecked = false.obs;
}

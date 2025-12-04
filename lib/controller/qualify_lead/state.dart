import 'package:eventjar/model/contact/contact_model.dart';
import 'package:get/get.dart';

class QualifyLeadState {
  final RxBool isLoading = false.obs;

  Rx<Contact?> contact = Rx<Contact?>(null);
}

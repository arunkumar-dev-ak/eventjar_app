import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:get/get.dart';

class QualifyLeadState {
  final RxBool isLoading = false.obs;

  Rx<MobileContact?> contact = Rx<MobileContact?>(null);
}

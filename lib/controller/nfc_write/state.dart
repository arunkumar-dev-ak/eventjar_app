import 'package:eventjar/model/contact/nfc_contact_model.dart';
import 'package:get/get.dart';

class NfcWriteState {
  final isSharing = false.obs;
  final shareSuccess = false.obs;

  final profile = Rxn<NfcContactModel>();
  final errorMessage = Rxn<String>();
}

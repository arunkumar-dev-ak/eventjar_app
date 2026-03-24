import 'package:eventjar/model/contact/nfc_contact_model.dart';
import 'package:eventjar/services/nfc_service.dart';
import 'package:get/get.dart';

class NfcState {
  final nfcStatus = NfcStatus.unknown.obs;
  final profile = Rxn<NfcContactModel>();
  final isLoading = false.obs;
}

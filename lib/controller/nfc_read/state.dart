import 'package:eventjar/model/contact/nfc_contact_model.dart';
import 'package:get/get.dart';

class NfcReadState {
  final isScanning = false.obs;
  final isSaving = false.obs;
  final isSaved = false.obs;
  final receivedProfile = Rxn<NfcContactModel>();
  final errorMessage = Rxn<String>();
}

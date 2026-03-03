import 'package:eventjar/model/contact/nfc_contact_model.dart';
import 'package:get/get.dart';

import '../../services/nfc_service.dart';

class NfcReadState {
  RxBool isLoading = false.obs;
  final isScanning = false.obs;
  final isProcessing = false.obs;
  final isSaving = false.obs;
  final isSaved = false.obs;
  final scanComplete = false.obs;
  final receivedProfile = Rxn<NfcContactModel>();
  final errorMessage = Rxn<String>();

  final nfcStatus = NfcStatus.unknown.obs;
  final profile = Rxn<NfcContactModel>();
}

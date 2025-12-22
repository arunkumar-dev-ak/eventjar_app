import 'package:eventjar/controller/nfc_read/state.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:eventjar/services/nfc_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NfcReadController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var state = NfcReadState();
  final NfcService _nfcService = NfcService();

  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    _initAnimations();
    startScanning();
  }

  void _initAnimations() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  Future<void> startScanning() async {
    state.isScanning.value = true;
    state.errorMessage.value = null;
    state.receivedProfile.value = null;

    await _nfcService.startReadSession(
      onContactReceived: (contact) {
        state.receivedProfile.value = contact;
        state.isScanning.value = false;
        _nfcService.stopSession();
        navigateToAddContact();
      },
      onError: (error) {
        state.errorMessage.value = error;
        state.isScanning.value = false;
      },
      onSessionStarted: () {
        state.isScanning.value = true;
      },
    );
  }

  void resetAndScan() {
    state.receivedProfile.value = null;
    state.errorMessage.value = null;
    state.isSaved.value = false;
    state.isSaving.value = false;
    startScanning();
  }

  Future<void> navigateToAddContact() async {
    Get.toNamed(
      RouteName.addContactPage,
      arguments: state.receivedProfile.value,
    );
  }

  void cancel() {
    _nfcService.stopSession();
    Get.back();
  }

  void done() {
    // Get.back(result: isSaved.value);
  }

  @override
  void onClose() {
    animationController.dispose();
    _nfcService.stopSession();
    super.onClose();
  }
}

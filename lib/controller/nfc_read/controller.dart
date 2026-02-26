import 'package:eventjar/controller/nfc_read/state.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:eventjar/services/nfc_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global/app_snackbar.dart';
import '../../global/store/user_store.dart';
import '../../model/contact/mobile_contact_model.dart';
import '../../model/contact/nfc_contact_model.dart';

class NfcReadController extends GetxController
    with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  var state = NfcReadState();
  final NfcService _nfcService = NfcService();

  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initAnimations();
    _loadData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkAndStartScanning();
    }
  }

  Future<void> _checkAndStartScanning() async {
    await _checkNfcStatus();
    if (state.nfcStatus.value == NfcStatus.available) {
      if (!state.isScanning.value) {
        startScanning();
      }
    } else {
      _nfcService.stopSession();
      state.isScanning.value = false;
    }
  }

  Future<void> _loadData() async {
    LoggerService.loggerInstance.dynamic_d("In _lodaDtaa");
    state.isLoading.value = true;
    try {
      _loadProfile();
      await Future.wait([
        _checkNfcStatus(),
      ]).timeout(const Duration(seconds: 5));
      startScanning();
    } catch (_) {
      state.isLoading.value = false;
    }
  }

  Future<void> _checkNfcStatus() async {
    state.nfcStatus.value = await _nfcService.getNfcStatus();
  }

  String getNfcStatusText() {
    switch (state.nfcStatus.value) {
      case NfcStatus.available:
        return 'NFC Ready';
      case NfcStatus.notAvailable:
        return 'NFC Not Available';
      case NfcStatus.disabled:
        return 'NFC Disabled';
      case NfcStatus.unknown:
        return 'Checking NFC...';
    }
  }

  Future<void> _loadProfile() async {
    LoggerService.loggerInstance.dynamic_d("In _loadProfile");
    final profile = UserStore.to.profile;

    // Convert phoneParsed from Map to PhoneParsed object if it exists
    PhoneParsed? phoneParsed;
    if (profile['phoneParsed'] != null) {
      phoneParsed = PhoneParsed.fromJson(
        Map<String, dynamic>.from(profile['phoneParsed']),
      );
    }

    final nfcProfile = NfcContactModel(
      name: profile['name'] ?? '',
      phoneParsed: phoneParsed,
      email: profile['email'] ?? '',
    );
    LoggerService.loggerInstance.dynamic_d(nfcProfile);
    state.profile.value = nfcProfile;
  }

  void showNfcErrorPrompt() {
    AppSnackbar.warning(
      title: 'NFC Error',
      message:
          'NFC is not available on this device or Please Turn it ON, in your Setting',
    );
  }

  void _initAnimations() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  Future<void> startScanning() async {
    if (state.nfcStatus.value != NfcStatus.available) {
      showNfcErrorPrompt();
      return;
    }

    state.isScanning.value = true;
    state.errorMessage.value = null;
    state.receivedProfile.value = null;

    await _nfcService.startReadSession(
      onContactReceived: (contact) {
        state.receivedProfile.value = contact;
        state.isScanning.value = false;
        _handleReadSuccess();
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

  Future<void> navigateToWrite() async {
    if (state.nfcStatus.value != NfcStatus.available) {
      showNfcErrorPrompt();
      return;
    }

    // Navigate and wait for result
    await Get.toNamed(RouteName.nfcWritePage);

    // Small delay to ensure write controller is fully disposed
    await Future.delayed(const Duration(milliseconds: 100));

    // When returning from WritePage, restart scanning
    resetAndScan();
  }

  Future<void> _handleReadSuccess() async {
    // Show processing state
    state.isProcessing.value = true;

    // Delay to let user move card away before stopping session
    // This prevents OS from intercepting the NFC tag
    await Future.delayed(const Duration(milliseconds: 1500));

    // Stop NFC session
    await _nfcService.stopSession();

    state.isProcessing.value = false;

    // Navigate to add contact
    navigateToAddContact();
  }

  Future<void> navigateToAddContact() async {
    // Navigate and wait for result
    await Get.toNamed(
      RouteName.addContactPage,
      arguments: state.receivedProfile.value,
    )?.then((result) {
      if (result == "refresh") {
        Navigator.pop(Get.context!, "refresh");
      }
    });

    // Small delay to ensure proper cleanup
    await Future.delayed(const Duration(milliseconds: 100));

    // When returning from AddContactPage, restart scanning
    resetAndScan();
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
    WidgetsBinding.instance.removeObserver(this);
    animationController.dispose();
    _nfcService.stopSession();
    super.onClose();
  }
}

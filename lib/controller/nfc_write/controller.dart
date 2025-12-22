import 'dart:io';

import 'package:eventjar/controller/nfc_write/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/nfc_contact_model.dart';
import 'package:eventjar/services/nfc_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NfcWriteController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var state = NfcWriteState();
  late AnimationController animationController;
  final NfcService _nfcService = NfcService();

  @override
  void onInit() {
    super.onInit();
    _initAnimations();
    loadData();
    startSharing();
  }

  void _initAnimations() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  void loadData() {
    final profile = UserStore.to.profile;
    final nfcProfile = NfcContactModel(
      name: profile['name'],
      phone: profile['phone'],
      email: profile['email'],
    );
    state.profile.value = nfcProfile;
  }

  Future<void> startSharing() async {
    if (Platform.isIOS) {
      state.errorMessage.value =
          'iOS cannot write to NFC tags. Use an Android device to share your contact via NFC.';
      return;
    }

    loadData();

    state.isSharing.value = true;
    state.errorMessage.value = null;
    state.shareSuccess.value = false;

    await _nfcService.startWriteSession(
      contact: state.profile.value!,
      onWriteSuccess: _handleWriteSuccess,
      onError: (error) {
        LoggerService.loggerInstance.e(error);
        state.errorMessage.value = error;
        state.isSharing.value = false;
      },
      onSessionStarted: () {
        state.isSharing.value = true;
      },
    );
  }

  Future<void> _handleWriteSuccess() async {
    LoggerService.loggerInstance.d("in success");
    state.shareSuccess.value = true;
    state.isSharing.value = false;

    try {
      // Stop NFC session completely
      await _nfcService.stopSession();

      // Give platform time to cleanup
      await Future.delayed(Duration(milliseconds: 100));

      // Success feedback
      showSuccessPopup();

      // Navigate back
      Navigator.of(Get.context!).pop();
    } catch (e) {
      LoggerService.loggerInstance.e("Navigation error: $e");
    }
  }

  void resetAndScan() {
    state.shareSuccess.value = false;
    state.errorMessage.value = null;
    startSharing();
  }

  void navigateToAddProfile() {}

  void showSuccessPopup() {
    AppSnackbar.success(
      title: 'Success! 🎉',
      message: 'Contact written to NFC card successfully!',
    );
  }

  void cancel() {
    _nfcService.stopSession();
    Get.back();
  }

  void done() {
    // Get.back(result: state.isSaved.value);
  }

  @override
  void onClose() {
    animationController.dispose();
    _nfcService.stopSession();
    super.onClose();
  }
}

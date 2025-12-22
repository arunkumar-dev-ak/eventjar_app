import 'package:eventjar/controller/nfc/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/model/contact/nfc_contact_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:eventjar/services/nfc_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NfcController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse1;
  late final Animation<double> _pulse2;

  Animation<double> get pulseAnimation1 => _pulse1;
  Animation<double> get pulseAnimation2 => _pulse2;

  final NfcService _nfcService = NfcService();

  final state = NfcState();

  @override
  void onInit() {
    super.onInit();
    _initAnimations();
    loadData();
  }

  void _initAnimations() {
    _controller = AnimationController(
      vsync: this, // 'this' works because of SingleTickerProviderStateMixin
      duration: const Duration(seconds: 2),
    )..repeat(); // Auto-start and loop

    // Pulse animation 1: outer ring (0.6 → 1.0 scale)
    _pulse1 = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8), // Plays 0-80% of controller duration
      ),
    );

    // Pulse animation 2: inner ring (0.0 → 1.0 scale, delayed)
    _pulse2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0), // Starts at 30%, ends at 100%
      ),
    );
  }

  Future<void> loadData() async {
    state.isLoading.value = true;
    try {
      _loadProfile();
      await Future.wait([
        _checkNfcStatus(),
      ]).timeout(const Duration(seconds: 5));
    } catch (_) {}
    state.isLoading.value = false;
  }

  Future<void> _checkNfcStatus() async {
    state.nfcStatus.value = await _nfcService.getNfcStatus();
  }

  Future<void> _loadProfile() async {
    final profile = UserStore.to.profile;
    final nfcProfile = NfcContactModel(
      name: profile['name'],
      phone: profile['phone'],
      email: profile['email'],
    );
    state.profile.value = nfcProfile;
  }

  void refreshProfile() {
    _loadProfile();
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

  void navigateToReceive() {
    if (state.nfcStatus.value != NfcStatus.available) {
      showNfcErrorPrompt();
      return;
    }
    Get.toNamed(RouteName.nfcReadPage);
  }

  void navigateToContacts() {
    // Get.toNamed(AppRoutes.contacts);
  }

  void navigateToWrite() {
    if (state.nfcStatus.value != NfcStatus.available) {
      showNfcErrorPrompt();
      return;
    }
    if (state.profile.value == null) {
      navigateTologin();
      return;
    }

    Get.toNamed(RouteName.nfcWritePage);
  }

  void navigateTologin() {}

  void showNfcErrorPrompt() {
    AppSnackbar.warning(
      title: 'NFC Error',
      message: 'NFC is not available on this device',
    );
  }

  Future<void> simulateReceiveContact(NfcContactModel contact) async {
    // await ContactsService().saveContact(contact, source: ContactSource.nfc);
    // Get.snackbar(
    //   'Success',
    //   'Test contact saved! Check My Contacts.',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }

  String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  void onClose() {
    _controller.dispose(); // Clean up animation controller
    super.onClose();
  }
}

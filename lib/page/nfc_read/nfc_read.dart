import 'dart:io';

import 'package:eventjar/controller/nfc_read/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/page/nfc_read/nfc_read_bottom_control.dart';
import 'package:eventjar/page/nfc_read/nfc_read_scanning_zone.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'nfc_page_action.dart';

class NfcReadPage extends GetView<NfcReadController> {
  const NfcReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
          statusBarBrightness: Theme.of(context).brightness,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.nfc, size: 22, color: Colors.blue.shade700),
            SizedBox(width: 8),
            Text(
              'read_card'.tr,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 11.sp,
                color: AppColors.textPrimary(context),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.blueGrey),
          onPressed: controller.cancel,
        ),
        elevation: 4,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.cardBg(context),
                AppColors.cardBg(context).withValues(alpha: 0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 2.hp),
            _StatusBadge(),
            Expanded(flex: 3, child: NfcReadScanningZone()),
            NfcActionContainer(),
            NfcReadBottomControls(),
          ],
        ),
      ),
    );
  }
}

class NfcActionContainer extends GetView<NfcReadController> {
  const NfcActionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = controller.state.profile.value;
    final hasProfile = profile != null;
    final isIos = Platform.isIOS;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 2.hp),
      child: NfcActionCard(
        title: isIos ? 'Write Not Available on iOS' : 'write_contact'.tr,
        subtitle: isIos
            ? 'NFC card writing is not supported on iOS. Use an Android device.'
            : hasProfile
            ? 'write_your_contact_to_nfc'.tr
            : 'set_up_profile_to_write_contact'.tr,
        icon: isIos ? Icons.phone_android : Icons.nfc,
        gradientColors: isIos
            ? const [Color(0xFF9E9E9E), Color(0xFF616161)]
            : const [Color(0xFF4CAF50), Color(0xFF2E7D32)],
        enabled: !isIos && hasProfile,
        onTap: isIos
            ? () {}
            : hasProfile
            ? controller.navigateToWrite
            : () {},
      ),
    );
  }
}

class _StatusBadge extends GetView<NfcReadController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final nfcStatus = controller.getNfcStatusText();
      final nfcStatusText = nfcStatus[0];
      final nfcStatusColor = nfcStatus[1];
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.blueAccent.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 7.sp, color: nfcStatusColor),
            SizedBox(width: 1.wp),
            Text(
              nfcStatusText,
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
                color: nfcStatusColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    });
  }
}

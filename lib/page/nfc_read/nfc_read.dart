import 'package:eventjar/controller/nfc_read/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/page/nfc_read/nfc_read_bottom_control.dart';
import 'package:eventjar/page/nfc_read/nfc_read_scanning_zone.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../nfc/widget/nfc_page_action.dart';

class NfcReadPage extends GetView<NfcReadController> {
  const NfcReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.nfc,
              size: 22,
              color: Colors.blue.shade700,
            ), // Blue for Read
            SizedBox(width: 8),
            Text(
              'Read Card', // Read Card title
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 11.sp,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.blueGrey),
          onPressed: () => Get.back(),
        ),
        elevation: 4,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white.withValues(alpha: 0.9)],
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
            // Main scanning area - takes more space
            Expanded(flex: 3, child: NfcReadScanningZone()),
            // Action container at bottom
            NfcActionContainer(),
            // Bottom controls
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
    LoggerService.loggerInstance.dynamic_d(profile);
    final hasProfile = profile != null;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 2.hp),
      child: NfcActionCard(
        title: 'Write Contact',
        subtitle: hasProfile
            ? 'Write your contact to NFC card'
            : 'Set up your profile to write contact',
        icon: Icons.nfc,
        gradientColors: const [Color(0xFF4CAF50), Color(0xFF2E7D32)],
        enabled: hasProfile,
        onTap: hasProfile ? controller.navigateToWrite : () {},
      ),
    );
  }
}

class _StatusBadge extends GetView<NfcReadController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final nfcStatusText = controller.getNfcStatusText();
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
            Icon(
              Icons.circle,
              size: 7.sp,
              color: _getStatusColor(nfcStatusText),
            ),
            SizedBox(width: 1.wp),
            Text(
              nfcStatusText,
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
                color: _getStatusColor(nfcStatusText),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'NFC Ready':
        return Colors.green;
      case 'NFC Not Available':
      case 'NFC Disabled':
        return Colors.orange;
      default:
        return Colors.blueAccent;
    }
  }
}

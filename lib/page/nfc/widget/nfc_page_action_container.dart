import 'package:eventjar/controller/nfc/controller.dart';
import 'package:eventjar/page/nfc/widget/nfc_page_action.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NfcActionContainer extends GetView<NfcController> {
  const NfcActionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = controller.state.profile.value;
    final hasProfile = profile != null;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // WRITE (share) card
            NfcActionCard(
              title: 'Write Contact',
              subtitle: hasProfile
                  ? 'Write your contact to NFC card'
                  : 'Set up your profile to write contact',
              icon: Icons.nfc,
              gradientColors: const [Color(0xFF4CAF50), Color(0xFF2E7D32)],
              enabled: hasProfile,
              onTap: hasProfile
                  ? controller.navigateToWrite
                  : controller.navigateTologin,
            ),
            const SizedBox(height: 16),
            // READ card
            NfcActionCard(
              title: 'Read Contact',
              subtitle: 'Read contact from NFC card or phone',
              icon: Icons.download,
              gradientColors: const [Color(0xFF1976D2), Color(0xFF0D47A1)],
              enabled: true,
              onTap: controller.navigateToReceive,
            ),
          ],
        ),
      ),
    );
  }
}

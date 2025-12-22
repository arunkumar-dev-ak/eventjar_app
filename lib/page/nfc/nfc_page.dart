import 'package:eventjar/controller/nfc/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/nfc/widget/nfc_page_action_container.dart';
import 'package:eventjar/page/nfc/widget/nfc_page_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NfcPage extends GetView<NfcController> {
  const NfcPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blueGrey),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Top NFC animated header
          SizedBox(height: 3.hp),
          NfcAnimatedHeader(),
          NfcActionContainer(),
        ],
      ),
    );
  }
}

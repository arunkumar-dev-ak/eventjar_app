import 'package:eventjar/controller/notification/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/notification/widget/whatspp/whatsapp_connected_card.dart';
import 'package:eventjar/page/notification/widget/whatspp/whatsapp_instruction_card.dart';
import 'package:eventjar/page/notification/widget/whatspp/whatsapp_shimmer.dart';
import 'package:eventjar/page/notification/widget/whatspp/whatsapp_token_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhatsAppNotificationTab extends StatelessWidget {
  WhatsAppNotificationTab({super.key});

  final controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.isLoading.value) {
        return const WhatsappNotificationShimmer();
      }

      final config = controller.state.whatsAppConfig.value;
      final isConnected =
          config?.apiToken != null && config!.apiToken!.isNotEmpty;

      return ListView(
        padding: EdgeInsets.all(4.wp),
        children: [
          WhatsAppInstructionCard(),
          SizedBox(height: 2.hp),
          isConnected
              ? WhatsAppConnectedCard(config: config)
              : WhatsAppTokenForm(),
        ],
      );
    });
  }
}

import 'package:eventjar/controller/notification/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/whatsapp_integration/whatsapp_integration_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class WhatsAppConnectedCard extends GetView<NotificationController> {
  final WhatsAppIntegrationModel config;
  const WhatsAppConnectedCard({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    String maskedToken = "********";
    if (config.apiToken != null && config.apiToken!.length > 6) {
      maskedToken =
          "********${config.apiToken!.substring(config.apiToken!.length - 4)}";
    }

    return Container(
      padding: EdgeInsets.all(3.5.wp),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade50,
            Colors.green.shade100.withValues(alpha: .25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.wp),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green.shade700,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 2.5.wp),
              Expanded(
                child: Text(
                  "Mybotify WhatsApp Connected",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 1.2.hp),

          Text(
            "Your integration token is securely stored and ready to send WhatsApp notifications.",
            style: TextStyle(fontSize: 9.sp, color: AppColors.textPrimary(context)),
          ),

          SizedBox(height: 2.hp),

          /// Token Preview Box
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.2.hp),
            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.lock, size: 14.sp, color: Colors.green.shade700),
                SizedBox(width: 2.wp),
                Expanded(
                  child: Text(
                    maskedToken,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Text(
                  "Secured",
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.hp),

          // Disconnect Button
          SizedBox(
            width: double.infinity,
            child: Obx(() {
              final isLoading = controller.state.isSavingToken.value;

              return ElevatedButton.icon(
                onPressed: isLoading ? null : controller.disconnectWhatsApp,
                icon: isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.link_off),
                label: Text(
                  isLoading ? "Disconnecting..." : "Disconnect Integration",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLoading
                      ? Colors.red.shade300
                      : Colors.red.shade500,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 1.6.hp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

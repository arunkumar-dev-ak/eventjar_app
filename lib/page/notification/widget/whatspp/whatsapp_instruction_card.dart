import 'package:eventjar/controller/notification/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhatsAppInstructionCard extends GetView<NotificationController> {
  const WhatsAppInstructionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.5.wp),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade100.withValues(alpha: .3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title Row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.wp),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.chat, color: Colors.blue, size: 18.sp),
              ),
              SizedBox(width: 2.5.wp),
              Text(
                "WhatsApp Integration",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.sp),
              ),
            ],
          ),

          SizedBox(height: 1.5.hp),

          Text(
            "Store your WhatsApp Business API token to enable event notifications.",
            style: TextStyle(fontSize: 9.sp, color: Colors.grey.shade800),
          ),

          SizedBox(height: 1.5.hp),

          /// Clickable Link
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: controller.openMyBotify,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.2.hp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .04),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.open_in_new,
                    size: 14.sp,
                    color: Colors.blue.shade700,
                  ),
                  SizedBox(width: 1.5.wp),
                  Text(
                    "whatsapp.mybotify.com",
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

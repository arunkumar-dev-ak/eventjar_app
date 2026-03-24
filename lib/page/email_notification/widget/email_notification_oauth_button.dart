import 'package:eventjar/controller/email_notification/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/model/notification/email_providers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget emailNotificationOauthButton(EmailProvider provider) {
  final EmailNotificationController controller = Get.find();
  final String providerName = (provider.oauthProvider ?? '')
      .toString()
      .toLowerCase();

  IconData icon;
  Color bgColor;
  Color iconColor;

  if (providerName == 'google') {
    icon = Icons.g_mobiledata;
    bgColor = Colors.red.shade50;
    iconColor = Colors.red;
  } else if (providerName == 'microsoft') {
    icon = Icons.desktop_windows;
    bgColor = Colors.blue.shade50;
    iconColor = Colors.blue.shade700;
  } else {
    icon = Icons.login;
    bgColor = Colors.purple.shade50;
    iconColor = Colors.purple;
  }

  final title =
      "Connect with ${capitalize(provider.oauthProvider ?? 'Provider')}";

  return Obx(() {
    final isLoading = controller.state.isOauthLoading.value;

    return Column(
      children: [
        InkWell(
          onTap: isLoading ? null : () => controller.connectOAuth(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.wp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [bgColor, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.wp),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 24, color: iconColor),
                ),
                SizedBox(width: 3.wp),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                isLoading
                    ? SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: iconColor,
                        ),
                      )
                    : Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.grey.shade600,
                      ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.hp),
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.wp),
              child: Text(
                "OR",
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
        SizedBox(height: 2.hp),
      ],
    );
  });
}

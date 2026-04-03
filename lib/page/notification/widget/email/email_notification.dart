import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/notification/widget/email/email_provider_list.dart';
import 'package:eventjar/page/notification/widget/email/email_shimmer.dart';
import 'package:eventjar/page/notification/widget/email/email_unconfigured_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventjar/controller/notification/controller.dart';

class EmailNotificationTab extends StatelessWidget {
  EmailNotificationTab({super.key});

  final NotificationController controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.isLoading.value) {
        return ProviderShimmerList();
      }

      final config = controller.state.emailConfig.value;

      return Column(
        children: [
          if (config == null || config.status != 'active')
            const EmailUnconfiguredCard()
          else if (config.authType == 'oauth_google')
            _StatusBanner(
              title: 'Gmail Connected',
              subtitle:
                  'Sending emails as ${config.oauthEmail ?? config.fromEmail}',
              onDisconnect: controller.disconnectEmail,
              isDeleting: controller.state.isDeleting.value,
            )
          else if (config.authType == 'oauth_microsoft')
            _StatusBanner(
              title: 'Outlook Connected',
              subtitle:
                  'Sending emails as ${config.oauthEmail ?? config.fromEmail}',
              onDisconnect: controller.disconnectEmail,
              isDeleting: controller.state.isDeleting.value,
            )
          else if (config.authType == 'password')
            _StatusBanner(
              title: '${config.providerName ?? 'Email'} Active',
              subtitle: 'SMTP verified • ${config.fromEmail ?? ''}',
              onDisconnect: controller.disconnectEmail,
              isDeleting: controller.state.isDeleting.value,
            ),

          Expanded(child: EmailProvidersList()),
        ],
      );
    });
  }
}

class _StatusBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onDisconnect;
  final bool isDeleting;

  const _StatusBanner({
    required this.title,
    required this.subtitle,
    required this.onDisconnect,
    required this.isDeleting,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0A2A1A), const Color(0xFF0F3322)]
              : [Colors.green.shade50, Colors.green.shade100],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        SizedBox(width: 1.wp),
                        Icon(
                          Icons.check_circle,
                          size: 20,
                          color: Colors.green.shade600,
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.hp),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 8.sp,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 1.wp),

              isDeleting
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.red.shade400,
                      ),
                    )
                  : TextButton(
                      onPressed: onDisconnect,
                      child: const Text(
                        "Disconnect",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
            ],
          ),

          /// TEXT BELOW FULL ROW
          SizedBox(height: 1.hp),
          Text(
            "To use a different provider, kindly disconnect the current one first.",
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 7.5.sp,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

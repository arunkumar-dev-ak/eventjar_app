import 'package:eventjar/controller/notification/controller.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/notification/email_providers.dart'
    show EmailProvider;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailProvidersList extends StatelessWidget {
  EmailProvidersList({super.key});

  final NotificationController controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final providers = controller.state.providers;
      final config = controller.state.emailConfig.value;

      if (config == null) {
        return const SizedBox();
      }

      return ListView.builder(
        padding: EdgeInsets.all(4.wp),
        itemCount: providers.length,
        itemBuilder: (context, index) {
          final provider = providers[index];
          final isConfigured = config.providerName == provider.name;

          return ProviderCard(
            provider: provider,
            isConfigured: isConfigured,
            authType: config.authType ?? '',
            onTap: () {
              final currentProvider = config.providerName?.toLowerCase();
              final tappedProvider = provider.name.toLowerCase();

              // If another provider is already configured
              if (currentProvider != null &&
                  currentProvider != tappedProvider &&
                  currentProvider.isNotEmpty) {
                AppSnackbar.warning(
                  title: "Disconnect Required",
                  message:
                      "Kindly disconnect the current email provider before switching.",
                );
                return;
              }

              controller.navigateToEmailNotification(provider);
            },
          );
        },
      );
    });
  }
}

class ProviderCard extends StatelessWidget {
  final EmailProvider provider;
  final bool isConfigured;
  final String authType;
  final VoidCallback onTap;

  const ProviderCard({
    super.key,
    required this.provider,
    required this.isConfigured,
    required this.authType,
    required this.onTap,
  });

  bool get isOAuthConnected {
    if (provider.name.toLowerCase() == 'gmail' && authType == 'oauth_google') {
      return true;
    }
    if (provider.name.toLowerCase() == 'outlook' &&
        authType == 'oauth_microsoft') {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.only(bottom: 1.hp),
      decoration: BoxDecoration(
        color: isConfigured ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isConfigured ? Colors.green.shade200 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: isConfigured && isOAuthConnected ? null : onTap,
        child: Padding(
          padding: EdgeInsets.all(3.wp),
          child: Row(
            children: [
              _iconBox(),
              SizedBox(width: 3.wp),
              Expanded(child: _details()),
              _action(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBox() {
    return Container(
      padding: EdgeInsets.all(2.wp),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.email, color: Colors.blue.shade600),
    );
  }

  Widget _details() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          provider.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
        ),
        SizedBox(height: 0.4.hp),
        Text(
          provider.description,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 8.sp),
        ),
        SizedBox(height: 0.4.hp),
        Text(
          "${provider.host} • ${provider.port}",
          style: TextStyle(fontSize: 7.sp, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _action() {
    if (isConfigured || isOAuthConnected) {
      return ElevatedButton(onPressed: onTap, child: const Text("Change"));
    }

    return ElevatedButton(onPressed: onTap, child: const Text("Use"));
  }
}

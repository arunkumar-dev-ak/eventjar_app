import 'package:eventjar/model/notification/email_providers.dart';
import 'package:eventjar/model/notification/notification_model.dart';
import 'package:eventjar/model/whatsapp_integration/whatsapp_integration_model.dart';
import 'package:get/get.dart';

class NotificationState {
  final isLoading = false.obs;
  final isDeleting = false.obs;
  RxList<EmailProvider> providers = <EmailProvider>[].obs;
  Rxn<NotificationSettingsEmailResponse> emailConfig =
      Rxn<NotificationSettingsEmailResponse>();

  RxInt selectedTab = 0.obs;

  final isSavingToken = false.obs;
  Rxn<WhatsAppIntegrationModel> whatsAppConfig =
      Rxn<WhatsAppIntegrationModel>();
  RxBool isTokenVisible = false.obs;
}

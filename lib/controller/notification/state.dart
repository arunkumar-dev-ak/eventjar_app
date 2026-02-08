import 'package:eventjar/model/notification/email_providers.dart';
import 'package:eventjar/model/notification/notification_model.dart';
import 'package:get/get.dart';

class NotificationState {
  final isLoading = false.obs;
  final isDeleting = false.obs;
  RxList<EmailProvider> providers = <EmailProvider>[].obs;
  Rxn<NotificationSettingsEmailResponse> emailConfig =
      Rxn<NotificationSettingsEmailResponse>();

  RxInt selectedTab = 0.obs;
}

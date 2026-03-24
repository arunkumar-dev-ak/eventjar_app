import 'package:eventjar/model/notification/email_providers.dart';
import 'package:get/get.dart';

class EmailNotificationState {
  final RxBool isLoading = false.obs;
  final RxBool isTesting = false.obs;
  final RxBool isOauthLoading = false.obs;
  final RxBool isConnected = false.obs;

  final RxBool isSecure = false.obs;
  final RxBool showPassword = false.obs;

  final Rxn<EmailProvider> provider = Rxn<EmailProvider>();
}

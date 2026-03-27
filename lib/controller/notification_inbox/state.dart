import 'package:eventjar/model/notification_inbox/notification_inbox_model.dart';
import 'package:get/get.dart';

class NotificationInboxState {
  final RxList<NotificationInboxItem> notifications =
      <NotificationInboxItem>[].obs;
  final RxBool isLoading = false.obs;
}

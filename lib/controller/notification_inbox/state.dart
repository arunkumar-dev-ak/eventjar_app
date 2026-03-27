import 'package:eventjar/model/notification_inbox/notification_inbox_model.dart';
import 'package:get/get.dart';

class NotificationInboxState {
  final RxList<Datum> notifications = <Datum>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxInt currentOffset = 0.obs;
  final RxBool hasMore = true.obs;
  final RxString navigatingId = ''.obs;
}

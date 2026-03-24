import 'package:eventjar/model/contact/contact_analytics_model.dart';
import 'package:get/get.dart';

class ContactAnalyticsState {
  RxBool isLoading = false.obs;

  final RxInt selectedTab = 0.obs;

  Rx<ContactAnalytics> analytics = ContactAnalytics(
    newCount: 0,
    followup24h: 0,
    followup7d: 0,
    followup30d: 0,
    qualified: 0,
    overdue: 0,
    total: 0,
  ).obs;
}

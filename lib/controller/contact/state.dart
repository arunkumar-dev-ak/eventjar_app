import 'package:eventjar/model/contact/contact_analytics_model.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:get/get.dart';

class ContactState {
  final RxBool isLoading = false.obs;

  RxBool showFilterRow = false.obs;
  Rx<NetworkStatusCardData?> selectedTab = Rx<NetworkStatusCardData?>(null);
  Rx<ContactAnalytics?> analytics = Rx<ContactAnalytics?>(null);

  RxList<Contact> contacts = <Contact>[].obs;

  // For Thank You message popup
  var emailChecked = true.obs;
  var whatsappChecked = false.obs;

  // For Meeting popup
  var meetingDate = DateTime.now().obs;
  var meetingTime = DateTime.now().obs;
  var meetingEmailChecked = true.obs;
  var meetingWhatsappChecked = false.obs;
}

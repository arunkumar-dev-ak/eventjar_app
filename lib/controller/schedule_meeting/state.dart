import 'package:eventjar/model/contact/contact_model.dart';
import 'package:get/get.dart';

class ScheduleMeetingState {
  final RxBool isLoading = false.obs;

  Rx<Contact?> contact = Rx<Contact?>(null);

  var meetingDate = DateTime.now().obs;
  var meetingTime = DateTime.now().obs;
  var meetingEmailChecked = true.obs;
  var meetingWhatsappChecked = false.obs;
}

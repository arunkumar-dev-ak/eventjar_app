import 'package:get/get.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';

enum MeetingButtonType { accept, reschedule, complete }

class ContactListMeetingState {
  // MobileContact from args
  Rx<MobileContact?> mobileContact = Rx<MobileContact?>(null);

  // Loading states
  RxBool isLoading = false.obs;

  // Meetings data
  // RxList<NetworkMeetingResponseModel> meetings =
  //     <NetworkMeetingResponseModel>[].obs;
  Rx<ActiveMeeting?> currentMeeting = Rx<ActiveMeeting?>(null);

  // UI states
  RxString appBarTitle = 'Contact Meeting'.obs;
  Rx<MeetingButtonType> primaryButtonType = MeetingButtonType.accept.obs;
}

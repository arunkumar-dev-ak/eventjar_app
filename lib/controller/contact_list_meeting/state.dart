import 'package:get/get.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/model/contact-list-meeting/network_meeting.dart';

enum MeetingButtonType { accept, reschedule, complete }

class ContactListMeetingState {
  // MobileContact from args
  Rx<MobileContact?> mobileContact = Rx<MobileContact?>(null);

  // Loading states
  RxBool isLoading = false.obs;
  RxBool isShimmerLoading = true.obs;

  // Meetings data
  // RxList<NetworkMeetingResponseModel> meetings =
  //     <NetworkMeetingResponseModel>[].obs;
  Rx<NetworkMeetingResponseModel?> currentMeeting =
      Rx<NetworkMeetingResponseModel?>(null);

  // UI states
  RxString appBarTitle = 'Contact Meeting'.obs;
  Rx<MeetingButtonType> primaryButtonType = MeetingButtonType.accept.obs;
}

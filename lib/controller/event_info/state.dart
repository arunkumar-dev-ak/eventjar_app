import 'package:eventjar/model/event_info/event_attendee_meeting_req_model.dart';
import 'package:eventjar/model/event_info/event_attendee_model.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:get/get.dart';

class EventInfoState {
  RxBool isLoading = false.obs;
  RxInt tabCount = 5.obs;

  Rxn<EventInfo> eventInfo = Rxn<EventInfo>();

  RxInt selectedAttendeeTab = 0.obs;
  RxString searchText = ''.obs;

  RxBool attendeeListLoading = false.obs;
  Rxn<EventAttendeeResponse> attendeeList = Rxn<EventAttendeeResponse>();

  RxBool attendeeRequestLoading = false.obs;
  Rxn<EventAttendeeRequestResponse> attendeeRequests =
      Rxn<EventAttendeeRequestResponse>();

  RxMap<String, bool> buttonLoadingStates = <String, bool>{}.obs;
  RxBool isProcessingRequest = false.obs;

  RxMap<String, bool> meetReqButtonLoadingStates = <String, bool>{}.obs;
  RxBool isMeetReqProcessingRequest = false.obs;
}

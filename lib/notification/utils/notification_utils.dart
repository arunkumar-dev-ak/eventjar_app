import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:get/get.dart';

void navigateBasedOnNotificationType(String type) {
  switch (type) {
    /// CONTACT PAGE
    case "CONTACT_LIST":
    case "CONTACT_LIST_MEETING_SCHEDULED":
    case "CONTACT_LIST_MEETING_RESCHEDULED":
    case "CONTACT_LIST_MEETING_ACCEPTED":
    case "CONTACT_LIST_MEETING_COMPLETED":
      Get.toNamed(RouteName.contactPage);
      break;

    /// MEETING PAGE
    case "MEETING_SCHEDULED":
    case "MEETING_COMPLETED":
    case "MEETING_ACCEPTED":
    case "MEETING_RESCHEDULED":
      Get.toNamed(RouteName.meetingPage);
      break;

    /// CONNECTION PAGE
    case "CONNECTION_RECEIVED":
    case "CONNECTION_REJECTED":
      Get.toNamed(RouteName.connectionPage);
      break;

    default:
      LoggerService.loggerInstance.d("Unhandled notification type: $type");
  }
}

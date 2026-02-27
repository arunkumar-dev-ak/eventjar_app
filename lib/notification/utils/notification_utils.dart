import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:get/get.dart';

void navigateBasedOnNotificationType(String type) {
  Map<String, dynamic> args = {};

  switch (type) {
    /// CONTACT
    case "CONTACT_LIST":
    case "CONTACT_LIST_MEETING_SCHEDULED":
    case "CONTACT_LIST_MEETING_RESCHEDULED":
    case "CONTACT_LIST_MEETING_ACCEPTED":
    case "CONTACT_LIST_MEETING_COMPLETED":
      args = {"initialTab": 1, "openSubPage": "contact"};
      break;

    /// MEETING
    case "MEETING_SCHEDULED":
    case "MEETING_COMPLETED":
    case "MEETING_ACCEPTED":
    case "MEETING_RESCHEDULED":
      args = {"initialTab": 1, "openSubPage": "meeting"};
      break;

    /// CONNECTION
    case "CONNECTION_RECEIVED":
      args = {"initialTab": 1, "openSubPage": "connection", "connectionTab": 1};
      break;

    case "CONNECTION_REJECTED":
    case "CONNECTION_ACCEPTED":
      args = {"initialTab": 1, "openSubPage": "connection", "connectionTab": 0};
      break;

    /// TICKET
    case "ATTENDEE_TICKET_CONFIRMED":
      args = {"initialTab": 3};
      break;

    default:
      LoggerService.loggerInstance.d("Unhandled notification type: $type");
      return;
  }

  Get.offAllNamed(RouteName.dashboardpage, arguments: args);
}

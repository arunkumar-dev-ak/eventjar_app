import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:get/get.dart';

void navigateBasedOnNotificationType(String type) {
  Map<String, dynamic> args = {};

  switch (type) {
    /// CONTACT (Login Required)
    case "CONTACT_LIST":
    case "CONTACT_LIST_MEETING_SCHEDULED":
    case "CONTACT_LIST_MEETING_RESCHEDULED":
    case "CONTACT_LIST_MEETING_ACCEPTED":
    case "CONTACT_LIST_MEETING_COMPLETED":
      args = {
        "initialTab": 1,
        "openSubPage": "contact",
        "isLoginRequired": true,
      };
      break;

    /// MEETING (Login Required)
    case "MEETING_SCHEDULED":
    case "MEETING_COMPLETED":
    case "MEETING_ACCEPTED":
    case "MEETING_RESCHEDULED":
      args = {
        "initialTab": 1,
        "openSubPage": "meeting",
        "isLoginRequired": true,
      };
      break;

    /// CONNECTION (Login Required)
    case "CONNECTION_RECEIVED":
      args = {
        "initialTab": 1,
        "openSubPage": "connection",
        "connectionTab": 1,
        "isLoginRequired": true,
      };
      break;

    case "CONNECTION_REJECTED":
    case "CONNECTION_ACCEPTED":
      args = {
        "initialTab": 1,
        "openSubPage": "connection",
        "connectionTab": 0,
        "isLoginRequired": true,
      };
      break;

    /// TICKET (Login Required)
    case "ATTENDEE_TICKET_CONFIRMED":
      args = {"initialTab": 3, "isLoginRequired": true};
      break;

    default:
      LoggerService.loggerInstance.d("Unhandled notification type: $type");
      return;
  }

  Get.offAllNamed(RouteName.dashboardpage, arguments: args);
}

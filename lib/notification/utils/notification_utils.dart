import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:get/get.dart';

bool isNotificationNavigable(String? triggerKey) {
  if (triggerKey == null) return false;
  const navigableTypes = {
    "CONTACT_LIST",
    "CONTACT_LIST_MEETING_SCHEDULED",
    "CONTACT_LIST_MEETING_RESCHEDULED",
    "CONTACT_LIST_MEETING_ACCEPTED",
    "CONTACT_LIST_MEETING_COMPLETED",
    "MEETING_SCHEDULED",
    "MEETING_COMPLETED",
    "MEETING_ACCEPTED",
    "MEETING_RESCHEDULED",
    "CONNECTION_RECEIVED",
    "CONNECTION_REJECTED",
    "CONNECTION_ACCEPTED",
    "ATTENDEE_TICKET_CONFIRMED",
  };
  return navigableTypes.contains(triggerKey);
}

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

    //Need to handle
    /*---
    NotificationEventType.EVENT_UPDATED
    NotificationEventType.EVENT_CANCELLED_BY_ORGANIZER,
    NotificationEventType.TICKET_CONFIRMATION
    NotificationEventType.TICKET_CANCELLED
    NotificationEventType.EVENT_REMINDER_1_DAY
    NotificationEventType.EVENT_REMINDER_1_HOUR
    NotificationEventType.EVENT_REMINDER_2_HOUR
    NotificationEventType.WEEKLY_UPCOMING_EVENTS_DIGEST
    NotificationEventType.PROFILE_INCOMPLETE
    NotificationEventType.ADD_CONTACT_REMINDER
    NotificationEventType.OVERDUE_CONTACT
    ONBOARDING
    Type: email_integration, calendar_feature, whatsapp_integration, networking_card, scan_card
    ---*/

    default:
      LoggerService.loggerInstance.d("Unhandled notification type: $type");
      return;
  }

  Get.offAllNamed(RouteName.dashboardpage, arguments: args);
}

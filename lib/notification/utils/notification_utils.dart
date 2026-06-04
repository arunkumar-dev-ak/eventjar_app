import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:get/get.dart';

bool isNotificationNavigable(String? triggerKey) {
  if (triggerKey == null) return false;
  const navigableTypes = {
    /// CONTACT
    "CONTACT_LIST",
    "CONTACT_LIST_MEETING_SCHEDULED",
    "CONTACT_LIST_MEETING_RESCHEDULED",
    "CONTACT_LIST_MEETING_ACCEPTED",
    "CONTACT_LIST_MEETING_COMPLETED",

    /// MEETING
    "MEETING_SCHEDULED",
    "MEETING_COMPLETED",
    "MEETING_ACCEPTED",
    "MEETING_RESCHEDULED",

    /// CONNECTION
    "CONNECTION_RECEIVED",
    "CONNECTION_REJECTED",
    "CONNECTION_ACCEPTED",

    /// ONBOARDING
    "email_integration",
    "whatsapp_integration",
    "calendar_feature",

    /// ACTIONS
    "scan_card",
    "ADD_CONTACT_REMINDER",

    /// TICKETS / EVENTS
    "ATTENDEE_TICKET_CONFIRMED",
    "EVENT_UPDATED",
    "EVENT_CANCELLED_BY_ORGANIZER",
    "TICKET_CONFIRMATION",
    "TICKET_CANCELLED",
    "EVENT_REMINDER_1_DAY",
    "EVENT_REMINDER_1_HOUR",
    "EVENT_REMINDER_2_HOUR",

    /// PROFILE / OTHER
    "PROFILE_INCOMPLETE",
    "OVERDUE_CONTACT",
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

    // MEETING (Login Required)
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

    /*----- OnBoarding Tabs -----*/
    case "email_integration":
      args = {
        "initialTab": 2,
        "openSubPage": "email_integration",
        "isLoginRequired": true,
        "showTour": true,
      };
      break;

    case "whatsapp_integration":
      args = {
        "initialTab": 2,
        "openSubPage": "whatsapp_integration",
        "isLoginRequired": true,
        "showTour": true,
      };
      break;

    case "calendar_feature":
      args = {
        "initialTab": 2,
        "openSubPage": "calendar_feature",
        "isLoginRequired": true,
        "showTour": true,
      };
      break;

    // case "networking_card":
    //   args = {
    //     "initialTab": 1,
    //     "openSubPage": "whatsapp_integration",
    //     "isLoginRequired": true,
    //     "enable"
    //   };
    //   break;

    case "scan_card":
      args = {"initialTab": 0, "openSubPage": "scan_card", "showTour": true};
      break;

    /*----- Navigation To Ticket -----*/
    case "ATTENDEE_TICKET_CONFIRMED":
    case "EVENT_UPDATED":
    case "EVENT_CANCELLED_BY_ORGANIZER":
    case "TICKET_CONFIRMATION":
    case "TICKET_CANCELLED":
    case "EVENT_REMINDER_1_DAY":
    case "EVENT_REMINDER_1_HOUR":
    case "EVENT_REMINDER_2_HOUR":
      args = {"initialTab": 3, "isLoginRequired": true};
      break;

    case "PROFILE_INCOMPLETE":
      args = {"initialTab": 2, "isLoginRequired": true};
      break;

    case "OVERDUE_CONTACT":
      args = {
        "initialTab": 1,
        "openSubPage": "overdue_contact",
        "isLoginRequired": true,
      };
      break;

    case "ADD_CONTACT_REMINDER":
      args = {"initialTab": 0, "openSubPage": "add_contact"};
      break;

    //Need to handle
    /*---
    
    NotificationEventType.WEEKLY_UPCOMING_EVENTS_DIGEST
    Type: networking_card,
    ---*/

    default:
      LoggerService.loggerInstance.d("Unhandled notification type: $type");
      return;
  }

  Get.offAllNamed(RouteName.dashboardpage, arguments: args);
}

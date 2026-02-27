import 'package:eventjar/global/utils/helpers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationContent {
  final String title;
  final String body;
  final String type;
  final String? contactStage;

  NotificationContent({
    required this.title,
    required this.body,
    required this.type,
    this.contactStage,
  });
}

NotificationContent buildContactNotification(RemoteMessage message) {
  final String type = message.data['type'] ?? '';
  final String contactName = message.data['contactName'] ?? '';
  final String? stage = message.data['stage'];

  String title =
      message.data["title"] ??
      message.notification?.title ??
      'New Notification';
  String body =
      message.data["body"] ??
      message.notification?.body ??
      'You have new activity';
  String? formattedStage;

  if (type.startsWith("CONTACT_LIST")) {
    formattedStage = formatConatctStageForNotification(stage);

    title = "Contact Update";

    if (type == "CONTACT_LIST") {
      body = "${capitalize(contactName)} moved to $formattedStage";
    } else if (type == "CONTACT_LIST_MEETING_SCHEDULED") {
      title = "Meeting Scheduled";
      body =
          "Meeting scheduled with ${capitalize(contactName)} ($formattedStage)";
    } else if (type == "CONTACT_LIST_MEETING_ACCEPTED") {
      title = "Meeting Confirmed";
      body =
          "${capitalize(contactName)} confirmed the meeting ($formattedStage)";
    } else if (type == "CONTACT_LIST_MEETING_COMPLETED") {
      title = "Meeting Completed";
      body =
          "Meeting with ${capitalize(contactName)} completed ($formattedStage)";
    }
  }

  return NotificationContent(
    title: title,
    body: body,
    type: type,
    contactStage: formattedStage,
  );
}

String formatConatctStageForNotification(String? stage) {
  switch (stage) {
    case "new":
      return "New";
    case "followup_24h":
      return "Follow-up 24h";
    case "followup_7d":
      return "Follow-up 7 Days";
    case "followup_30d":
      return "Follow-up 30 Days";
    default:
      return "";
  }
}

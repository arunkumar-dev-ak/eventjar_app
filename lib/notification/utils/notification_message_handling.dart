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

NotificationContent buildNotificationContent(RemoteMessage message) {
  final String type = message.data['type'] ?? '';

  String title =
      message.data["title"] ??
      message.notification?.title ??
      'New Notification';
  String body =
      message.data["body"] ??
      message.notification?.body ??
      'You have new activity';
  String? formattedStage;

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

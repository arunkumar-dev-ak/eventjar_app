import 'package:eventjar/controller/event_info/controller.dart';

extension EventInfoControllerExtensions on EventInfoController {
  bool get canShowAttendeesTab {
    final event = state.eventInfo.value;
    if (event == null) return false;

    final isOneOnOneEnabled = event.isOneMeetingEnabled == true;
    final isRegistered = event.userTicketStatus?.isRegistered == true;
    final isOrganizerUser = isOrganizer(event.organizer.id);

    return isOneOnOneEnabled && (isRegistered || isOrganizerUser);
  }
}

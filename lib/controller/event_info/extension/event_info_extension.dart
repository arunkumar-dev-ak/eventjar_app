import 'package:eventjar/controller/event_info/controller.dart';

extension EventInfoControllerExtensions on EventInfoController {
  bool get canShowAttendeesTab {
    final event = state.eventInfo.value;
    if (event == null) return false;

    return event.isOneMeetingEnabled == true;
  }

  bool get canAccessAttendeesTab {
    final event = state.eventInfo.value;
    if (event == null) return false;

    final isRegistered =
        event.userTicketStatus?.isRegistered == true ||
        state.ticketId.value != null;
    final isOrganizerUser = isOrganizer(event.organizer.id);

    return isRegistered || isOrganizerUser;
  }
}

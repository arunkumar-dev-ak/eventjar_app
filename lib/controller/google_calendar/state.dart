import 'package:eventjar/model/google_calendar/google_calendar_status_model.dart';
import 'package:get/get.dart';

class GoogleCalendarState {
  final RxBool isLoading = false.obs;

  final RxString loadingText = "Checking Google Calendar connection...".obs;

  final Rxn<GoogleCalendarStatusModel> connection =
      Rxn<GoogleCalendarStatusModel>();
}

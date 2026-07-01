import 'package:dio/dio.dart';
import 'package:eventjar/api/google_calendar_api/google_calendar_api.dart';
import 'package:eventjar/controller/schedule_meeting/availability_state.dart';
import 'package:eventjar/logger_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

mixin AvailabilityMixin {
  AvailabilityState get availability;

  int get selectedDurationMins;
  void onDurationApplied(List<int> allowedDurations);

  String? _targetUserId;
  bool get _hasTarget => _targetUserId != null && _targetUserId!.isNotEmpty;

  static bool _tzInitialized = false;

  void _ensureTzInitialized() {
    if (!_tzInitialized) {
      tz_data.initializeTimeZones();
      _tzInitialized = true;
    }
  }

  tz.Location _getLocation(String timezone) {
    _ensureTzInitialized();
    try {
      return tz.getLocation(timezone);
    } catch (_) {
      return tz.getLocation('UTC');
    }
  }

  tz.Location get _viewerLocation {
    final viewerTz = availability.ownPrefs.value?.timezone;
    if (viewerTz != null) return _getLocation(viewerTz);
    return tz.local;
  }

  void initAvailability(String? targetUserId) {
    _targetUserId = targetUserId;
    availability.reset();
    _loadCalendarStatus();
    _loadPreferences();
  }

  Future<void> _loadCalendarStatus() async {
    try {
      final status = await GoogleCalendarApi.getConnectionStatus();
      LoggerService.loggerInstance.dynamic_d("message:${status.toJson()}");
      availability.isCalendarConnected.value = status.connected;
    } catch (_) {
      availability.isCalendarConnected.value = false;
    }
  }

  Future<void> _loadPreferences() async {
    availability.isPrefsLoading.value = true;
    availability.availabilityError.value = null;
    try {
      final hostFuture = _hasTarget
          ? GoogleCalendarApi.getTargetUserPreferences(_targetUserId!)
          : GoogleCalendarApi.getMeetingPreferences();

      final hostPrefs = await hostFuture;
      availability.hostPrefs.value = hostPrefs;
      LoggerService.loggerInstance.dynamic_d("message:${hostPrefs.toJson()}");

      onDurationApplied(hostPrefs.allowedDurations);

      if (_hasTarget) {
        try {
          final ownPrefs = await GoogleCalendarApi.getMeetingPreferences();
          availability.ownPrefs.value = ownPrefs;
        } catch (_) {}
      } else {
        availability.ownPrefs.value = hostPrefs;
      }

      _fetchAvailableDates();
    } catch (err) {
      availability.availabilityError.value = _extractErrorMessage(err);
    } finally {
      availability.isPrefsLoading.value = false;
    }
  }

  Future<void> _fetchAvailableDates() async {
    availability.isDatesLoading.value = true;
    try {
      final now = DateTime.now().toUtc();
      final maxDays = availability.hostPrefs.value?.maxAdvanceDays ?? 60;
      final end = now.add(Duration(days: maxDays));

      final response = await GoogleCalendarApi.getAvailableDates(
        timeMin: now.toIso8601String(),
        timeMax: end.toIso8601String(),
        targetUserId: _targetUserId,
      );

      availability.availableDates.value = response.dates.toSet();
    } catch (err) {
      LoggerService.loggerInstance.e('Failed to fetch available dates: $err');
    } finally {
      availability.isDatesLoading.value = false;
    }
  }

  void onDateSelected(DateTime date) {
    availability.selectedDate.value = date;
    availability.selectedSlotIso.value = null;
    availability.timeSlots.clear();
    _fetchSlotsForDate(date);
  }

  void onDurationChanged() {
    availability.selectedSlotIso.value = null;
    final date = availability.selectedDate.value;
    if (date != null) {
      _fetchSlotsForDate(date);
    }
  }

  void onSlotSelected(String isoString) {
    availability.selectedSlotIso.value = isoString;
    final utc = DateTime.parse(isoString).toUtc();
    final viewerLoc = _viewerLocation;
    final displayTime = tz.TZDateTime.from(utc, viewerLoc);
    availability.dateTimeController.text = DateFormat(
      'MMM dd, yyyy - h:mm a',
    ).format(displayTime);
  }

  DateTime? get selectedSlotDateTime {
    final iso = availability.selectedSlotIso.value;
    if (iso == null) return null;
    return DateTime.parse(iso).toUtc();
  }

  Future<void> _fetchSlotsForDate(DateTime date) async {
    availability.isSlotsLoading.value = true;
    availability.availabilityError.value = null;

    try {
      final dayStart = DateTime.utc(date.year, date.month, date.day);
      final dayEnd = DateTime.utc(date.year, date.month, date.day, 23, 59, 59, 999);

      final response = await GoogleCalendarApi.getAvailableSlots(
        timeMin: dayStart.toIso8601String(),
        timeMax: dayEnd.toIso8601String(),
        duration: selectedDurationMins,
        targetUserId: _targetUserId,
      );

      // TODO: use response.ownTimezone once backend adds it
      final slots = response.slots.map((s) {
        final start = DateTime.parse(s.start).toUtc();
        final end = DateTime.parse(s.end).toUtc();
        return TimeSlot(
          start: start,
          end: end,
          available: s.available,
          reason: s.reason,
        );
      }).toList();

      availability.timeSlots.value = slots;
    } catch (err) {
      availability.availabilityError.value = _extractErrorMessage(err);
    } finally {
      availability.isSlotsLoading.value = false;
    }
  }

  Duration get viewerDisplayOffset {
    final loc = _viewerLocation;
    final now = tz.TZDateTime.now(loc);
    return now.timeZoneOffset;
  }

  String formatSlotLabel(TimeSlot slot) {
    final viewerLoc = _viewerLocation;
    final start = tz.TZDateTime.from(slot.start, viewerLoc);
    final end = tz.TZDateTime.from(slot.end, viewerLoc);
    return '${DateFormat('h:mm a').format(start)} – ${DateFormat('h:mm a').format(end)}';
  }

  bool isDayAvailable(DateTime date) {
    if (availability.availableDates.value.isEmpty) return true;
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return availability.availableDates.value.contains(dateStr);
  }

  DateTime get maxBookingDate {
    final days = availability.hostPrefs.value?.maxAdvanceDays ?? 60;
    return DateTime.now().add(Duration(days: days));
  }

  List<int> get hostAllowedDurations {
    return availability.hostPrefs.value?.allowedDurations ?? [15, 30, 45, 60];
  }

  String _extractErrorMessage(dynamic err) {
    if (err is DioException) {
      final data = err.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'];
        if (message is Map<String, dynamic>) {
          return message['message']?.toString() ?? 'something_went_wrong'.tr;
        }
        if (message is String) return message;
      }
    }
    return 'something_went_wrong'.tr;
  }
}

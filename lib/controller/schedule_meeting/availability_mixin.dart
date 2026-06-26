import 'package:dio/dio.dart';
import 'package:eventjar/api/google_calendar_api/google_calendar_api.dart';
import 'package:eventjar/controller/schedule_meeting/availability_state.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/meeting_preferences/meeting_preferences_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

mixin AvailabilityMixin {
  AvailabilityState get availability;

  int get selectedDurationMins;
  void onDurationApplied(List<int> allowedDurations);

  String? _targetUserId;
  bool get _hasTarget => _targetUserId != null && _targetUserId!.isNotEmpty;

  Duration get _viewerOffset {
    final viewerTz = availability.ownPrefs.value?.timezone;
    if (viewerTz != null) return _getTimezoneOffset(viewerTz);
    return DateTime.now().timeZoneOffset;
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
    } catch (err) {
      availability.availabilityError.value = _extractErrorMessage(err);
    } finally {
      availability.isPrefsLoading.value = false;
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
    final displayTime = utc.add(_viewerOffset);
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
    availability.busySlots.clear();
    availability.availabilityError.value = null;

    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    if (availability.isCalendarConnected.value) {
      try {
        final busySlots = _hasTarget
            ? await GoogleCalendarApi.getMutualAvailability(
                _targetUserId!,
                dayStart.toUtc().toIso8601String(),
                dayEnd.toUtc().toIso8601String(),
              )
            : await GoogleCalendarApi.getMyAvailability(
                dayStart.toUtc().toIso8601String(),
                dayEnd.toUtc().toIso8601String(),
              );
        availability.busySlots.value = busySlots;
      } catch (err) {
        availability.availabilityError.value = _extractErrorMessage(err);
      }
    }

    _generateSlots(date);
    availability.isSlotsLoading.value = false;
  }

  void _generateSlots(DateTime date) {
    final prefs = availability.hostPrefs.value;
    if (prefs == null) {
      availability.timeSlots.clear();
      return;
    }

    final window = _resolveDayWindow(date, prefs);
    if (window == null) {
      availability.timeSlots.clear();
      return;
    }

    final durationMins = selectedDurationMins;
    final interval = prefs.slotIntervalMins;
    final bufferBefore = prefs.bufferBeforeMins;
    final bufferAfter = prefs.bufferAfterMins;
    final totalSlotMins = bufferBefore + durationMins + bufferAfter;

    final hostOffset = _getTimezoneOffset(prefs.timezone);

    // Host's start/end → UTC
    final dayStartUtc = DateTime.utc(
      date.year,
      date.month,
      date.day,
      int.parse(window['startTime']!.split(':')[0]),
      int.parse(window['startTime']!.split(':')[1]),
    ).subtract(hostOffset);
    final dayEndUtc = DateTime.utc(
      date.year,
      date.month,
      date.day,
      int.parse(window['endTime']!.split(':')[0]),
      int.parse(window['endTime']!.split(':')[1]),
    ).subtract(hostOffset);

    final nowUtc = DateTime.now().toUtc();
    final minNoticeUtc = nowUtc.add(Duration(minutes: prefs.minNoticeMins));

    // Busy slots are already UTC (ISO strings)
    final busyRanges = availability.busySlots.map((s) {
      return _BusyRange(
        start: DateTime.parse(s.start).toUtc(),
        end: DateTime.parse(s.end).toUtc(),
      );
    }).toList();

    final slots = <TimeSlot>[];
    var current = dayStartUtc;

    while (current.isBefore(dayEndUtc)) {
      final slotEnd = current.add(Duration(minutes: totalSlotMins));
      if (slotEnd.isAfter(dayEndUtc)) break;

      final meetStartUtc = current.add(Duration(minutes: bufferBefore));
      final meetEndUtc = meetStartUtc.add(Duration(minutes: durationMins));

      String? reason;
      bool available = true;

      if (meetStartUtc.isBefore(nowUtc) ||
          meetStartUtc.isAtSameMomentAs(nowUtc)) {
        available = false;
        reason = 'past';
      } else if (meetStartUtc.isBefore(minNoticeUtc)) {
        available = false;
        reason = 'notice';
      } else if (busyRanges.any(
        (b) => meetStartUtc.isBefore(b.end) && meetEndUtc.isAfter(b.start),
      )) {
        available = false;
        reason = 'busy';
      }

      slots.add(
        TimeSlot(
          start: meetStartUtc,
          end: meetEndUtc,
          available: available,
          reason: reason,
        ),
      );

      current = current.add(Duration(minutes: interval));
    }

    availability.timeSlots.value = slots;
  }

  Duration getTimezoneOffset(String timezone) => _getTimezoneOffset(timezone);

  Duration get viewerDisplayOffset => _viewerOffset;

  String formatSlotLabel(TimeSlot slot) {
    final offset = _viewerOffset;
    final start = slot.start.add(offset);
    final end = slot.end.add(offset);
    return '${DateFormat('h:mm a').format(start)} – ${DateFormat('h:mm a').format(end)}';
  }

  Duration _getTimezoneOffset(String timezone) {
    const offsets = {
      'Pacific/Midway': Duration(hours: -11),
      'Pacific/Honolulu': Duration(hours: -10),
      'America/Anchorage': Duration(hours: -9),
      'America/Los_Angeles': Duration(hours: -8),
      'America/Denver': Duration(hours: -7),
      'America/Chicago': Duration(hours: -6),
      'America/New_York': Duration(hours: -5),
      'America/Caracas': Duration(hours: -4, minutes: 30),
      'America/Halifax': Duration(hours: -4),
      'America/St_Johns': Duration(hours: -3, minutes: 30),
      'America/Sao_Paulo': Duration(hours: -3),
      'America/Buenos_Aires': Duration(hours: -3),
      'America/Argentina/Buenos_Aires': Duration(hours: -3),
      'Atlantic/South_Georgia': Duration(hours: -2),
      'Atlantic/Azores': Duration(hours: -1),
      'UTC': Duration.zero,
      'Europe/London': Duration.zero,
      'Europe/Paris': Duration(hours: 1),
      'Europe/Berlin': Duration(hours: 1),
      'Europe/Athens': Duration(hours: 2),
      'Europe/Istanbul': Duration(hours: 3),
      'Asia/Istanbul': Duration(hours: 3),
      'Europe/Moscow': Duration(hours: 3),
      'Asia/Tehran': Duration(hours: 3, minutes: 30),
      'Asia/Dubai': Duration(hours: 4),
      'Asia/Kabul': Duration(hours: 4, minutes: 30),
      'Asia/Karachi': Duration(hours: 5),
      'Asia/Kolkata': Duration(hours: 5, minutes: 30),
      'Asia/Kathmandu': Duration(hours: 5, minutes: 45),
      'Asia/Dhaka': Duration(hours: 6),
      'Asia/Yangon': Duration(hours: 6, minutes: 30),
      'Asia/Bangkok': Duration(hours: 7),
      'Asia/Ho_Chi_Minh': Duration(hours: 7),
      'Asia/Jakarta': Duration(hours: 7),
      'Asia/Shanghai': Duration(hours: 8),
      'Asia/Hong_Kong': Duration(hours: 8),
      'Asia/Singapore': Duration(hours: 8),
      'Asia/Taipei': Duration(hours: 8),
      'Asia/Tokyo': Duration(hours: 9),
      'Asia/Seoul': Duration(hours: 9),
      'Australia/Adelaide': Duration(hours: 9, minutes: 30),
      'Australia/Sydney': Duration(hours: 10),
      'Australia/Melbourne': Duration(hours: 10),
      'Pacific/Auckland': Duration(hours: 12),
      'Pacific/Fiji': Duration(hours: 12),
    };
    return offsets[timezone] ?? DateTime.now().timeZoneOffset;
  }

  Map<String, String>? _resolveDayWindow(
    DateTime date,
    MeetingPreferencesResponse prefs,
  ) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    final override = prefs.dateOverrides
        .where((o) => o.date == dateStr)
        .firstOrNull;

    if (override != null) {
      if (!override.enabled) return null;
      if (override.startTime != null && override.endTime != null) {
        return {'startTime': override.startTime!, 'endTime': override.endTime!};
      }
    }

    final dayOfWeek = date.weekday % 7;
    final dayConfig = prefs.weeklyHours
        .where((h) => h.day == dayOfWeek)
        .firstOrNull;

    if (dayConfig == null || !dayConfig.enabled) return null;
    return {'startTime': dayConfig.startTime, 'endTime': dayConfig.endTime};
  }

  bool isDayAvailable(DateTime date) {
    final prefs = availability.hostPrefs.value;
    if (prefs == null) return true;
    return _resolveDayWindow(date, prefs) != null;
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

class _BusyRange {
  final DateTime start;
  final DateTime end;
  _BusyRange({required this.start, required this.end});
}

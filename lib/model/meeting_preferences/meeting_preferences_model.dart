import 'package:eventjar/logger_service.dart';

class MeetingPreferencesResponse {
  final String timezone;
  final int slotIntervalMins;
  final int bufferBeforeMins;
  final int bufferAfterMins;
  final int minNoticeMins;
  final int maxAdvanceDays;
  final List<WeeklyHour> weeklyHours;
  final List<int> allowedDurations;

  MeetingPreferencesResponse({
    required this.timezone,
    required this.slotIntervalMins,
    required this.bufferBeforeMins,
    required this.bufferAfterMins,
    required this.minNoticeMins,
    required this.maxAdvanceDays,
    required this.weeklyHours,
    required this.allowedDurations,
  });

  factory MeetingPreferencesResponse.fromJson(Map<String, dynamic> json) {
    try {
      return MeetingPreferencesResponse(
        timezone: json['timezone'] ?? 'UTC',
        slotIntervalMins: json['slot_interval_mins'] ?? 30,
        bufferBeforeMins: json['buffer_before_mins'] ?? 0,
        bufferAfterMins: json['buffer_after_mins'] ?? 0,
        minNoticeMins: json['min_notice_mins'] ?? 60,
        maxAdvanceDays: json['max_advance_days'] ?? 60,
        weeklyHours: (json['weekly_hours'] as List<dynamic>?)
                ?.map(
                  (e) => WeeklyHour.fromJson(e as Map<String, dynamic>),
                )
                .toList() ??
            [],
        allowedDurations: (json['allowed_durations'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList() ??
            [15, 30, 45, 60],
      );
    } catch (e) {
      LoggerService.loggerInstance.e(
        'Error parsing MeetingPreferencesResponse: $e',
      );
      rethrow;
    }
  }
}

class WeeklyHour {
  final int day;
  final String startTime;
  final String endTime;
  final bool enabled;

  WeeklyHour({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.enabled,
  });

  factory WeeklyHour.fromJson(Map<String, dynamic> json) {
    return WeeklyHour(
      day: json['day'],
      startTime: json['startTime'] ?? '09:00',
      endTime: json['endTime'] ?? '18:00',
      enabled: json['enabled'] ?? false,
    );
  }
}

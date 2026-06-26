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
  final String videoProvider;
  final String? customVideoUrl;
  final List<DateOverride> dateOverrides;

  MeetingPreferencesResponse({
    required this.timezone,
    required this.slotIntervalMins,
    required this.bufferBeforeMins,
    required this.bufferAfterMins,
    required this.minNoticeMins,
    required this.maxAdvanceDays,
    required this.weeklyHours,
    required this.allowedDurations,
    required this.videoProvider,
    this.customVideoUrl,
    required this.dateOverrides,
  });

  factory MeetingPreferencesResponse.fromJson(Map<String, dynamic> json) {
    try {
      return MeetingPreferencesResponse(
        timezone: json['timezone'] ?? 'UTC',
        slotIntervalMins: (json['slot_interval_mins'] as num?)?.toInt() ?? 30,
        bufferBeforeMins: (json['buffer_before_mins'] as num?)?.toInt() ?? 0,
        bufferAfterMins: (json['buffer_after_mins'] as num?)?.toInt() ?? 0,
        minNoticeMins: (json['min_notice_mins'] as num?)?.toInt() ?? 60,
        maxAdvanceDays: (json['max_advance_days'] as num?)?.toInt() ?? 60,
        weeklyHours:
            (json['weekly_hours'] as List<dynamic>?)
                ?.map((e) => WeeklyHour.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        allowedDurations:
            (json['allowed_durations'] as List<dynamic>?)
                ?.map((e) => (e as num).toInt())
                .toList() ??
            [15, 30, 45, 60],
        videoProvider: json['video_provider'] ?? 'google_meet',
        customVideoUrl: json['custom_video_url'],
        dateOverrides:
            (json['date_overrides'] as List<dynamic>?)
                ?.map((e) => DateOverride.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
    } catch (e) {
      LoggerService.loggerInstance.e(
        'Error parsing MeetingPreferencesResponse: $e',
      );
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'timezone': timezone,
      'slot_interval_mins': slotIntervalMins,
      'buffer_before_mins': bufferBeforeMins,
      'buffer_after_mins': bufferAfterMins,
      'min_notice_mins': minNoticeMins,
      'max_advance_days': maxAdvanceDays,
      'weekly_hours': weeklyHours.map((h) => h.toJson()).toList(),
      'allowed_durations': allowedDurations,
      'video_provider': videoProvider,
      'custom_video_url': customVideoUrl,
      'date_overrides': dateOverrides.map((o) => o.toJson()).toList(),
    };
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
      day: (json['day'] as num).toInt(),
      startTime: json['startTime'] ?? '09:00',
      endTime: json['endTime'] ?? '18:00',
      enabled: json['enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'enabled': enabled,
    };
  }
}

class DateOverride {
  final String date;
  final bool enabled;
  final String? startTime;
  final String? endTime;
  final String? label;

  DateOverride({
    required this.date,
    required this.enabled,
    this.startTime,
    this.endTime,
    this.label,
  });

  factory DateOverride.fromJson(Map<String, dynamic> json) {
    return DateOverride(
      date: json['date'] ?? '',
      enabled: json['enabled'] ?? false,
      startTime: json['startTime'],
      endTime: json['endTime'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'enabled': enabled,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
      if (label != null) 'label': label,
    };
  }

  DateOverride copyWith({
    String? date,
    bool? enabled,
    String? startTime,
    String? endTime,
    String? label,
  }) {
    return DateOverride(
      date: date ?? this.date,
      enabled: enabled ?? this.enabled,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      label: label ?? this.label,
    );
  }
}

class HolidayCountry {
  final String code;
  final String name;

  HolidayCountry({required this.code, required this.name});

  factory HolidayCountry.fromJson(Map<String, dynamic> json) {
    return HolidayCountry(code: json['code'] ?? '', name: json['name'] ?? '');
  }
}

class FreeBusySlot {
  final String start;
  final String end;

  FreeBusySlot({required this.start, required this.end});

  factory FreeBusySlot.fromJson(Map<String, dynamic> json) {
    return FreeBusySlot(start: json['start'] ?? '', end: json['end'] ?? '');
  }
}

class Holiday {
  final String date;
  final String name;
  final String type;

  Holiday({required this.date, required this.name, required this.type});

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      date: json['date'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? 'public',
    );
  }
}

import 'package:eventjar/logger_service.dart';

class TimeRange {
  final String startTime;
  final String endTime;

  TimeRange({required this.startTime, required this.endTime});

  factory TimeRange.fromJson(Map<String, dynamic> json) {
    try {
      return TimeRange(
        startTime: json['startTime'] ?? '09:00',
        endTime: json['endTime'] ?? '18:00',
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing TimeRange: $e');
      return TimeRange(startTime: '09:00', endTime: '18:00');
    }
  }

  Map<String, dynamic> toJson() {
    return {'startTime': startTime, 'endTime': endTime};
  }

  TimeRange copyWith({String? startTime, String? endTime}) {
    return TimeRange(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

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
  final bool enabled;
  final List<TimeRange> ranges;
  final String startTime;
  final String endTime;

  WeeklyHour({
    required this.day,
    required this.enabled,
    required this.ranges,
    required this.startTime,
    required this.endTime,
  });

  factory WeeklyHour.fromJson(Map<String, dynamic> json) {
    try {
      final rangesList = (json['ranges'] as List<dynamic>?)
              ?.map((e) => TimeRange.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

      return WeeklyHour(
        day: (json['day'] as num).toInt(),
        enabled: json['enabled'] ?? false,
        ranges: rangesList.isNotEmpty
            ? rangesList
            : [
                TimeRange(
                  startTime: json['startTime'] ?? '09:00',
                  endTime: json['endTime'] ?? '18:00',
                ),
              ],
        startTime: json['startTime'] ?? '09:00',
        endTime: json['endTime'] ?? '18:00',
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing WeeklyHour: $e');
      return WeeklyHour(
        day: (json['day'] as num?)?.toInt() ?? 0,
        enabled: false,
        ranges: [TimeRange(startTime: '09:00', endTime: '18:00')],
        startTime: '09:00',
        endTime: '18:00',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'enabled': enabled,
      'ranges': ranges.map((r) => r.toJson()).toList(),
      'startTime': ranges.isNotEmpty ? ranges.first.startTime : startTime,
      'endTime': ranges.isNotEmpty ? ranges.first.endTime : endTime,
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
    try {
      return DateOverride(
        date: json['date'] ?? '',
        enabled: json['enabled'] ?? false,
        startTime: json['startTime'],
        endTime: json['endTime'],
        label: json['label'],
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing DateOverride: $e');
      return DateOverride(date: '', enabled: false);
    }
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
    try {
      return HolidayCountry(
        code: json['code'] ?? '',
        name: json['name'] ?? '',
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing HolidayCountry: $e');
      return HolidayCountry(code: '', name: '');
    }
  }
}

class FreeBusySlot {
  final String start;
  final String end;

  FreeBusySlot({required this.start, required this.end});

  factory FreeBusySlot.fromJson(Map<String, dynamic> json) {
    try {
      return FreeBusySlot(
        start: json['start'] ?? '',
        end: json['end'] ?? '',
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing FreeBusySlot: $e');
      return FreeBusySlot(start: '', end: '');
    }
  }
}

class AvailableDatesResponse {
  final List<String> dates;
  final String timezone;

  AvailableDatesResponse({required this.dates, required this.timezone});

  factory AvailableDatesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return AvailableDatesResponse(
      dates: (data['dates'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      timezone: data['timezone'] ?? 'UTC',
    );
  }
}

class AvailableSlot {
  final String start;
  final String end;
  final bool available;
  final String? reason;

  AvailableSlot({
    required this.start,
    required this.end,
    required this.available,
    this.reason,
  });

  factory AvailableSlot.fromJson(Map<String, dynamic> json) {
    return AvailableSlot(
      start: json['start'] ?? '',
      end: json['end'] ?? '',
      available: json['available'] ?? false,
      reason: json['reason'],
    );
  }
}

class AvailableSlotsResponse {
  final List<AvailableSlot> slots;
  final String timezone;
  final String? ownTimezone;

  AvailableSlotsResponse({
    required this.slots,
    required this.timezone,
    this.ownTimezone,
  });

  factory AvailableSlotsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return AvailableSlotsResponse(
      slots: (data['slots'] as List<dynamic>?)
              ?.map((e) => AvailableSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      timezone: data['timezone'] ?? 'UTC',
      ownTimezone: data['own_timezone'],
    );
  }
}

class Holiday {
  final String date;
  final String name;
  final String type;

  Holiday({required this.date, required this.name, required this.type});

  factory Holiday.fromJson(Map<String, dynamic> json) {
    try {
      return Holiday(
        date: json['date'] ?? '',
        name: json['name'] ?? '',
        type: json['type'] ?? 'public',
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing Holiday: $e');
      return Holiday(date: '', name: '', type: 'public');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DayAvailability {
  final String day;
  final RxBool isEnabled;
  final Rx<TimeOfDay> startTime;
  final Rx<TimeOfDay> endTime;

  DayAvailability({
    required this.day,
    required bool enabled,
    required TimeOfDay start,
    required TimeOfDay end,
  })  : isEnabled = enabled.obs,
        startTime = start.obs,
        endTime = end.obs;
}

class MeetingPreferencesState {
  RxBool isLoading = false.obs;
  RxBool isSaving = false.obs;

  final RxString selectedTimezone = 'UTC'.obs;
  final RxString selectedSlotInterval = '30 min'.obs;
  final RxString selectedMinNotice = '1 hour'.obs;
  final RxString selectedBufferBefore = 'None'.obs;
  final RxString selectedBufferAfter = 'None'.obs;

  final List<String> timezones = [
    'UTC',
    'Africa/Abidjan',
    'Africa/Cairo',
    'Africa/Casablanca',
    'Africa/Johannesburg',
    'Africa/Lagos',
    'Africa/Nairobi',
    'America/Anchorage',
    'America/Argentina/Buenos_Aires',
    'America/Bogota',
    'America/Chicago',
    'America/Denver',
    'America/Halifax',
    'America/Lima',
    'America/Los_Angeles',
    'America/Mexico_City',
    'America/New_York',
    'America/Phoenix',
    'America/Santiago',
    'America/Sao_Paulo',
    'America/St_Johns',
    'America/Toronto',
    'America/Vancouver',
    'Asia/Almaty',
    'Asia/Baghdad',
    'Asia/Bangkok',
    'Asia/Colombo',
    'Asia/Dhaka',
    'Asia/Dubai',
    'Asia/Hong_Kong',
    'Asia/Istanbul',
    'Asia/Jakarta',
    'Asia/Karachi',
    'Asia/Kathmandu',
    'Asia/Kolkata',
    'Asia/Kuala_Lumpur',
    'Asia/Manila',
    'Asia/Riyadh',
    'Asia/Seoul',
    'Asia/Shanghai',
    'Asia/Singapore',
    'Asia/Taipei',
    'Asia/Tehran',
    'Asia/Tokyo',
    'Asia/Vladivostok',
    'Atlantic/Reykjavik',
    'Australia/Adelaide',
    'Australia/Brisbane',
    'Australia/Darwin',
    'Australia/Melbourne',
    'Australia/Perth',
    'Australia/Sydney',
    'Europe/Amsterdam',
    'Europe/Athens',
    'Europe/Berlin',
    'Europe/Brussels',
    'Europe/Bucharest',
    'Europe/Dublin',
    'Europe/Helsinki',
    'Europe/Kiev',
    'Europe/Lisbon',
    'Europe/London',
    'Europe/Madrid',
    'Europe/Moscow',
    'Europe/Oslo',
    'Europe/Paris',
    'Europe/Prague',
    'Europe/Rome',
    'Europe/Stockholm',
    'Europe/Vienna',
    'Europe/Warsaw',
    'Europe/Zurich',
    'Pacific/Auckland',
    'Pacific/Fiji',
    'Pacific/Honolulu',
    'Pacific/Samoa',
  ];

  final List<String> slotIntervals = [
    '15 min',
    '30 min',
    '45 min',
    '60 min',
  ];

  final List<String> minNoticeOptions = [
    'No minimum',
    '30 min',
    '1 hour',
    '2 hours',
    '4 hours',
    '1 day',
  ];

  final List<String> bufferOptions = [
    'None',
    '5 min',
    '10 min',
    '15 min',
    '30 min',
  ];

  final RxList<DayAvailability> weeklyAvailability = <DayAvailability>[
    DayAvailability(
      day: 'Monday',
      enabled: true,
      start: const TimeOfDay(hour: 9, minute: 0),
      end: const TimeOfDay(hour: 18, minute: 0),
    ),
    DayAvailability(
      day: 'Tuesday',
      enabled: true,
      start: const TimeOfDay(hour: 9, minute: 0),
      end: const TimeOfDay(hour: 18, minute: 0),
    ),
    DayAvailability(
      day: 'Wednesday',
      enabled: true,
      start: const TimeOfDay(hour: 9, minute: 0),
      end: const TimeOfDay(hour: 18, minute: 0),
    ),
    DayAvailability(
      day: 'Thursday',
      enabled: true,
      start: const TimeOfDay(hour: 9, minute: 0),
      end: const TimeOfDay(hour: 18, minute: 0),
    ),
    DayAvailability(
      day: 'Friday',
      enabled: true,
      start: const TimeOfDay(hour: 9, minute: 0),
      end: const TimeOfDay(hour: 18, minute: 0),
    ),
    DayAvailability(
      day: 'Saturday',
      enabled: false,
      start: const TimeOfDay(hour: 9, minute: 0),
      end: const TimeOfDay(hour: 18, minute: 0),
    ),
    DayAvailability(
      day: 'Sunday',
      enabled: false,
      start: const TimeOfDay(hour: 9, minute: 0),
      end: const TimeOfDay(hour: 18, minute: 0),
    ),
  ].obs;
}

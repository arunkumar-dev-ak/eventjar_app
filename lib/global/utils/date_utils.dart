import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Defines our custom return type: (Date, Time, Timezone)
typedef FormattedDateTime = (String date, String time, String timezone);

FormattedDateTime formatUtcToLocal(dynamic inputDate, BuildContext context) {
  try {
    DateTime utcDateTime;

    // Case 1: The input is a String (e.g., "2026-06-05T15:41:18Z")
    if (inputDate is String) {
      String timeStr = inputDate.trim();
      // Ensure Dart parses it as UTC by appending 'Z' if missing
      if (!timeStr.endsWith('Z') && !timeStr.contains('+')) {
        timeStr += 'Z';
      }
      utcDateTime = DateTime.parse(timeStr).toUtc();
    }
    // Case 2: The input is already a DateTime object
    else if (inputDate is DateTime) {
      // Force it to treat its values as UTC just in case it was instantiated locally
      utcDateTime = DateTime.utc(
        inputDate.year,
        inputDate.month,
        inputDate.day,
        inputDate.hour,
        inputDate.minute,
        inputDate.second,
      );
    }
    // Fallback if an unexpected type is passed
    else {
      return ('--', '--', '--');
    }

    // 1. Convert the confirmed UTC time to the user's local mobile time
    final localDateTime = utcDateTime.toLocal();

    // 2. Format Date (e.g., "Jun 05, 2026")
    final formattedDate = DateFormat('MMM dd, yyyy').format(localDateTime);

    // 3. Format Time (Checks device settings for 12h vs 24h)
    final is24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;
    final timePattern = is24HourFormat ? 'HH:mm' : 'hh:mm a';
    final formattedTime = DateFormat(timePattern).format(localDateTime);

    // 4. Get the local Timezone abbreviation (e.g., "EST", "GMT", "IST")
    // Inside your formatUtcToLocal helper function:
    String timezoneName = localDateTime.timeZoneName;

    // If the OS returns a raw offset string like "+05" or "-04", wrap it cleanly
    if (timezoneName.startsWith('+') || timezoneName.startsWith('-')) {
      timezoneName = 'GMT$timezoneName'; // Transforms "+05" into "GMT+05"
    }

    return (formattedDate, formattedTime, timezoneName);
  } catch (e) {
    // Fallback if parsing fails
    return ('--', '--', '--');
  }
}

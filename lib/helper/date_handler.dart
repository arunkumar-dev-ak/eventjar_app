import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatTimeFromHHMM(String timeString, BuildContext context) {
  final parts = timeString.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  final dateTime = DateTime(0, 1, 1, hour, minute);

  final localTime = formatTimeToLocale(dateTime, context);

  return localTime;
}

String formatTimeFromDateTime(DateTime dateTime, BuildContext context) {
  final localTime = formatTimeToLocale(dateTime, context);

  return localTime;
}

String formatTimeToLocale(DateTime time, BuildContext context) {
  final timeFormat12 = DateFormat('hh:mm a');
  final timeFormat24 = DateFormat('HH:mm');

  final userPrefers24Hour = MediaQuery.of(context).alwaysUse24HourFormat;

  final formattedTime = userPrefers24Hour
      ? timeFormat24.format(time)
      : timeFormat12.format(time);

  return formattedTime;
}

String formatDate(DateTime date) {
  return DateFormat('dd MMM yyyy').format(date);
}

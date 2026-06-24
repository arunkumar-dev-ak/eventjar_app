import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingDateHelper {
  static String formatDate(DateTime date) {
    final months = [
      'jan'.tr,
      'feb'.tr,
      'mar'.tr,
      'apr'.tr,
      'may'.tr,
      'jun'.tr,
      'jul'.tr,
      'aug'.tr,
      'sep'.tr,
      'oct'.tr,
      'nov'.tr,
      'dec'.tr,
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  static String getDateRangeDisplayText(DateTimeRange range) {
    final start = formatDate(range.start);
    final end = formatDate(range.end);
    return '$start - $end';
  }
}

import 'package:flutter/material.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting_status.dart';

class MeetingQueryHelper {
  static Map<String, dynamic> gatherOneOnOneQueryData({
    required MeetingStatus? status,
    required DateTimeRange dateRange,
    String? cursor,
  }) {
    final queryParams = <String, dynamic>{'limit': 10};

    if (status != null && status != MeetingStatus.ALL) {
      queryParams['status'] = status.name.toUpperCase();
    }

    final fromDateUtc = dateRange.start.toUtc();
    DateTime toDateUtc = dateRange.end.toUtc();

    if (fromDateUtc.isAtSameMomentAs(toDateUtc)) {
      toDateUtc = toDateUtc.add(const Duration(hours: 23, minutes: 59));
    }

    queryParams['fromDate'] = fromDateUtc.toIso8601String();
    queryParams['toDate'] = toDateUtc.toIso8601String();

    if (cursor != null) {
      queryParams['cursor'] = cursor;
    }

    return queryParams;
  }

  static Map<String, dynamic> gatherQueryData({
    required MeetingStatus? status,
    required DateTimeRange dateRange,
  }) {
    final queryParams = <String, dynamic>{};

    if (status != null && status != MeetingStatus.ALL) {
      queryParams['status'] = status.name.toUpperCase();
    }

    final fromDateUtc = dateRange.start.toUtc();
    DateTime toDateUtc = dateRange.end.toUtc();

    if (fromDateUtc.isAtSameMomentAs(toDateUtc)) {
      toDateUtc = toDateUtc.add(const Duration(hours: 23, minutes: 59));
    }

    queryParams['fromDate'] = fromDateUtc.toIso8601String();
    queryParams['toDate'] = toDateUtc.toIso8601String();

    return queryParams;
  }
}

import 'package:flutter/material.dart';
import 'package:eventjar/global/utils/date_utils.dart';
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

    final utcRange = dateRangeToUtcStrings(dateRange);
    queryParams['fromDate'] = utcRange.startDate;
    queryParams['toDate'] = utcRange.endDate;

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

    final utcRange = dateRangeToUtcStrings(dateRange);
    queryParams['fromDate'] = utcRange.startDate;
    queryParams['toDate'] = utcRange.endDate;

    return queryParams;
  }
}

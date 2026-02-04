import 'package:flutter/material.dart';

enum MeetingStatus {
  ALL,
  SCHEDULED,
  CONFIRMED,
  DECLINED,
  CANCELLED,
  COMPLETED,
  NO_SHOW;

  String get displayName {
    switch (this) {
      case MeetingStatus.ALL:
        return 'All';
      case MeetingStatus.SCHEDULED:
        return 'Scheduled';
      case MeetingStatus.CONFIRMED:
        return 'Confirmed';
      case MeetingStatus.DECLINED:
        return 'Declined';
      case MeetingStatus.CANCELLED:
        return 'Cancelled';
      case MeetingStatus.COMPLETED:
        return 'Completed';
      case MeetingStatus.NO_SHOW:
        return 'No Show';
    }
  }

  Color get color {
    switch (this) {
      case MeetingStatus.ALL:
        return Colors.grey;
      case MeetingStatus.SCHEDULED:
        return Colors.blue;
      case MeetingStatus.CONFIRMED:
        return Colors.green;
      case MeetingStatus.DECLINED:
        return Colors.orange;
      case MeetingStatus.CANCELLED:
        return Colors.red;
      case MeetingStatus.COMPLETED:
        return Colors.green;
      case MeetingStatus.NO_SHOW:
        return Colors.grey;
    }
  }
}

enum MeetingStatusForReschedule {
  SCHEDULED,
  DECLINED,
  COMPLETED;

  String get displayName {
    switch (this) {
      case MeetingStatusForReschedule.SCHEDULED:
        return 'Scheduled';
      case MeetingStatusForReschedule.DECLINED:
        return 'Declined';
      case MeetingStatusForReschedule.COMPLETED:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case MeetingStatusForReschedule.SCHEDULED:
        return Colors.blue;
      case MeetingStatusForReschedule.DECLINED:
        return Colors.orange;
      case MeetingStatusForReschedule.COMPLETED:
        return Colors.green;
    }
  }
}

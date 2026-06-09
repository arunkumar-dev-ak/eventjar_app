import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        return 'all'.tr;
      case MeetingStatus.SCHEDULED:
        return 'scheduled'.tr;
      case MeetingStatus.CONFIRMED:
        return 'confirmed'.tr;
      case MeetingStatus.DECLINED:
        return 'declined'.tr;
      case MeetingStatus.CANCELLED:
        return 'cancelled'.tr;
      case MeetingStatus.COMPLETED:
        return 'completed'.tr;
      case MeetingStatus.NO_SHOW:
        return 'no_show'.tr;
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
        return 'scheduled'.tr;
      case MeetingStatusForReschedule.DECLINED:
        return 'declined'.tr;
      case MeetingStatusForReschedule.COMPLETED:
        return 'completed'.tr;
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

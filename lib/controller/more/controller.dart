import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/model/contact/contact_analytics_model.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting_status.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreController extends GetxController {
  RxBool get isLoggedIn => UserStore.to.isLoginReactive;

  void _requireLogin(Function action) {
    if (UserStore.to.isLogin) {
      action();
    } else {
      Get.toNamed(RouteName.signInPage)?.then((result) {
        if (result == "logged_in") {
          action();
        }
      });
    }
  }

  // Budget
  // void navigateToBudgetTrack() {
  //   _requireLogin(() => Get.toNamed(RouteName.budgetTrackPage));
  // }

  // Contact
  void navigateToAddContact() {
    _requireLogin(() => Get.toNamed(RouteName.addContactPage));
  }

  void navigateToNfcRead() {
    _requireLogin(() => Get.toNamed(RouteName.nfcReadPage));
  }

  void navigateToQrDashboard() {
    _requireLogin(() => Get.toNamed(RouteName.qrDashboardPage));
  }

  void navigateToScanCard() {
    _requireLogin(() => Get.toNamed(RouteName.scanCardPage));
  }

  // Network — each item passes the correct statusCard filter
  void navigateToTotalContacts() {
    _requireLogin(
      () => Get.toNamed(
        RouteName.contactPage,
        arguments: {
          'statusCard': const NetworkStatusCardData(
            key: 'totalContacts',
            label: 'Total Contacts',
            enumKey: 'all',
            icon: Icons.people,
            color: Colors.blue,
          ),
        },
      ),
    );
  }

  void navigateToNewContacts() {
    _requireLogin(
      () => Get.toNamed(
        RouteName.contactPage,
        arguments: {
          'statusCard': const NetworkStatusCardData(
            key: 'new',
            label: 'New',
            enumKey: 'new',
            icon: Icons.fiber_new,
            color: Colors.green,
          ),
        },
      ),
    );
  }

  void navigateTo24hFollowup() {
    _requireLogin(
      () => Get.toNamed(
        RouteName.contactPage,
        arguments: {
          'statusCard': const NetworkStatusCardData(
            key: 'followup24h',
            label: '24H Followup',
            enumKey: 'followup_24h',
            icon: Icons.access_time,
            color: Colors.orange,
          ),
        },
      ),
    );
  }

  void navigateTo7dFollowup() {
    _requireLogin(
      () => Get.toNamed(
        RouteName.contactPage,
        arguments: {
          'statusCard': const NetworkStatusCardData(
            key: 'followup7d',
            label: '7D Followup',
            enumKey: 'followup_7d',
            icon: Icons.calendar_view_week,
            color: Colors.purple,
          ),
        },
      ),
    );
  }

  void navigateTo30dFollowup() {
    _requireLogin(
      () => Get.toNamed(
        RouteName.contactPage,
        arguments: {
          'statusCard': const NetworkStatusCardData(
            key: 'followup30d',
            label: '30D Followup',
            enumKey: 'followup_30d',
            icon: Icons.calendar_month,
            color: Colors.teal,
          ),
        },
      ),
    );
  }

  void navigateToQualifiedContacts() {
    _requireLogin(
      () => Get.toNamed(
        RouteName.contactPage,
        arguments: {
          'statusCard': const NetworkStatusCardData(
            key: 'qualified',
            label: 'Qualified',
            enumKey: 'qualified',
            icon: Icons.verified,
            color: Colors.indigo,
          ),
        },
      ),
    );
  }

  // Connections
  void navigateToConnectionSend() {
    _requireLogin(
      () => Get.toNamed(RouteName.connectionPage, arguments: {"openTab": 0}),
    );
  }

  void navigateToConnectionReceived() {
    _requireLogin(
      () => Get.toNamed(RouteName.connectionPage, arguments: {"openTab": 1}),
    );
  }

  // Meeting
  void navigateToAllMeetings() {
    _requireLogin(
      () => Get.toNamed(
        RouteName.meetingPage,
        arguments: {'status': MeetingStatus.ALL},
      ),
    );
  }

  void navigateToScheduledMeetings() {
    _requireLogin(
      () => Get.toNamed(
        RouteName.meetingPage,
        arguments: {'status': MeetingStatus.SCHEDULED},
      ),
    );
  }

  void navigateToConfirmedMeetings() {
    _requireLogin(
      () => Get.toNamed(
        RouteName.meetingPage,
        arguments: {'status': MeetingStatus.CONFIRMED},
      ),
    );
  }

  void navigateToDeclinedMeetings() {
    _requireLogin(
      () => Get.toNamed(
        RouteName.meetingPage,
        arguments: {'status': MeetingStatus.DECLINED},
      ),
    );
  }

  void navigateToCancelledMeetings() {
    _requireLogin(
      () => Get.toNamed(
        RouteName.meetingPage,
        arguments: {'status': MeetingStatus.CANCELLED},
      ),
    );
  }

  void navigateToCompletedMeetings() {
    _requireLogin(
      () => Get.toNamed(
        RouteName.meetingPage,
        arguments: {'status': MeetingStatus.COMPLETED},
      ),
    );
  }

  void navigateToNoShowMeetings() {
    _requireLogin(
      () => Get.toNamed(
        RouteName.meetingPage,
        arguments: {'status': MeetingStatus.NO_SHOW},
      ),
    );
  }

  // Others
  void navigateToCategoryEvent() {
    Get.toNamed(RouteName.categoriesPage);
  }
}

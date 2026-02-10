import 'package:eventjar/model/home/home_model.dart';
import 'package:eventjar/model/meta/meta_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/contact/contact_analytics_model.dart';
import '../../model/contact/nfc_contact_model.dart';
import '../../model/user_profile/user_profile.dart';
import '../../services/nfc_service.dart';

class HomeState {
  RxBool isLoading = false.obs;
  RxBool isFetching = false.obs;

  final isSearchEmpty = true.obs;

  RxInt selectedIndex = 0.obs;

  RxList<Color> dominantColors = <Color>[].obs;

  RxList<Event> events = <Event>[].obs;
  Rxn<Meta> meta = Rxn<Meta>();

  RxInt scoreCardCurrentPage = 0.obs;
  RxBool scoreCardExpanded = false.obs;
  RxInt totalContacts = 0.obs;
  RxBool hasAddedContact = false.obs;

  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);

  // Phone OTP verification
  RxBool isSendingOtp = false.obs;
  RxBool isVerifyingOtp = false.obs;
  RxString otpError = ''.obs;
  RxInt resendCooldown = 0.obs;

  Rx<ContactAnalytics> analytics = ContactAnalytics(
    newCount: 0,
    followup24h: 0,
    followup7d: 0,
    followup30d: 0,
    qualified: 0,
    overdue: 0,
    total: 0,
  ).obs;
}

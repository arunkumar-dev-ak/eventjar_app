import 'package:eventjar/model/user_profile/bio_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BioProfileState {
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<DataUser?> profile = Rx<DataUser?>(null);
  final RxInt galleryIndex = 0.obs;

  final Rx<DateTime?> meetingDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> meetingTime = Rx<TimeOfDay?>(null);
  final RxInt meetingDurationIndex = 1.obs;
  final RxBool isMeetingSubmitting = false.obs;
}

import 'package:eventjar/api/user_profile_api/bio_profile_api.dart';
import 'package:eventjar/controller/bio_profile/state.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/user_profile/bio_profile.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BioProfileController extends GetxController {
  final state = BioProfileState();

  late final String userName;

  DataUser? get _p => state.profile.value;
  ExtendedProfile? get _ext => _p?.extendedProfile;

  String get name => _p?.name ?? '';
  String get username => _p?.username ?? '';
  String get avatarUrl => _p?.avatarUrl ?? '';
  String get position => _ext?.businessName?.toString().isNotEmpty == true
      ? (_p?.jobTitle ?? '')
      : (_p?.jobTitle ?? '');
  String get businessName =>
      _ext?.businessName?.toString() ?? _p?.company ?? '';
  String get location => _p?.location ?? '';
  String get website => _p?.website ?? '';
  String get bio => _p?.bio ?? '';
  bool get isVerified => false;

  String get businessCategory => _ext?.businessCategory ?? '';
  String get yearsInBusiness => _ext?.yearsInBusiness ?? '';
  String get shortBio => _ext?.shortBio?.toString() ?? bio;
  String get networkingGoal => _ext?.networkingGoal?.toString() ?? '';

  List<String> get preferredLocations =>
      _ext?.preferredLocations?.cast<String>() ?? [];
  List<String> get interestedInConnecting => _ext?.interestedInConnecting ?? [];
  List<String> get helpOfferings => _ext?.helpOfferings ?? [];
  List<String> get discussionTopics => _ext?.discussionTopics ?? [];

  int get eventsCount => _p?.stats?.eventsAttended ?? 0;
  int get contactsCount => _p?.stats?.connectionsCount ?? 0;

  SocialMediaLinks? get socialLinks => _ext?.socialMediaLinks;

  List<String> get galleryImages => _ext?.galleryImages?.cast<String>() ?? [];

  List<CustomBadgeAssignment> get badgeAssignments =>
      _p?.customBadgeAssignments ?? [];

  bool get isLoggedIn => UserStore.to.isLogin;

  bool get isOwnProfile {
    if (!isLoggedIn) return false;
    final loggedUsername = UserStore.to.profile['username']?.toString() ?? '';
    return loggedUsername.isNotEmpty && loggedUsername == userName;
  }

  bool get showMeetingButton => isLoggedIn && !isOwnProfile;

  @override
  void onInit() {
    super.onInit();
    userName = Get.parameters['username'] ?? '';
    if (userName.isNotEmpty) {
      _fetchProfile();
    } else {
      state.hasError.value = true;
      state.errorMessage.value = 'Invalid profile link';
    }
  }

  Future<void> _fetchProfile() async {
    state.isLoading.value = true;
    state.hasError.value = false;
    try {
      final response = await BioProfileApi.getBioProfile(userName);
      state.profile.value = response.data;
    } catch (e) {
      LoggerService.loggerInstance.e('BioProfile fetch error: $e');
      state.hasError.value = true;
      state.errorMessage.value = 'Unable to load profile';
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> retry() async => _fetchProfile();

  void goBack() {
    final canPop = Get.key.currentState?.canPop() ?? false;
    if (canPop) {
      Get.back();
    } else {
      Get.offAllNamed(RouteName.dashboardpage);
    }
  }

  static const meetingDurations = [15, 30, 45, 60];

  final notesController = TextEditingController();

  void resetMeetingForm() {
    state.meetingDate.value = null;
    state.meetingTime.value = null;
    state.meetingDurationIndex.value = 1;
    notesController.clear();
  }

  Future<bool> submitMeeting() async {
    final date = state.meetingDate.value;
    final time = state.meetingTime.value;
    if (date == null || time == null) return false;

    final scheduledDate = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    final duration = meetingDurations[state.meetingDurationIndex.value];
    final notes = notesController.text.trim();

    final data = {
      'scheduled_date': scheduledDate.toIso8601String(),
      'duration': duration,
      'notes': notes,
    };

    state.isMeetingSubmitting.value = true;
    try {
      await BioProfileApi.uploadMeeting(data, userName);
      resetMeetingForm();
      return true;
    } catch (e) {
      LoggerService.loggerInstance.e('Meeting submit error: $e');
      return false;
    } finally {
      state.isMeetingSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:eventjar/api/home_api/home_api.dart';
import 'package:eventjar/controller/home/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/palette_generator.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/helper/date_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/contact_analytics_model.dart';
import 'package:eventjar/model/home/home_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/contact_analytics_api/contact_analytics_api.dart';
import '../../api/user_profile_api/user_profile_api.dart';
import '../../api/verify_api/email.dart';
import '../../api/verify_api/phone.dart';

class HomeController extends GetxController {
  var appBarTitle = "MyEventJar";
  final state = HomeState();
  final formKey = GlobalKey<FormState>();
  final logoPath = 'assets/app_icon/event_app_icon.png';
  ScrollController homeScrollController = ScrollController();
  final int _currentPage = 1;
  final int _limit = 10;

  bool get isLoading => state.isLoading.value;

  final _searchBarController = TextEditingController().obs;

  TextEditingController get searchBarController => _searchBarController.value;
  //RxMap<String, dynamic> get profile => UserStore.to.profile;
  RxBool get isLoggedIn => UserStore.to.isLoginReactive;

  PageController scoreCardPageController = PageController();
  int get scoreCardCurrentPage => state.scoreCardCurrentPage.value;

  bool get isEmailVerified => state.userProfile.value?.isVerified ?? false;
  bool get isPhoneVerified => state.userProfile.value?.phoneVerified ?? false;

  bool get hasAddedContact => state.hasAddedContact.value;
  bool get allStepsComplete =>
      isEmailVerified && isPhoneVerified && hasAddedContact;

  int get totalContacts => state.totalContacts.value;
  bool get scoreCardExpanded => state.scoreCardExpanded.value;

  int get currentTierIndex {
    final contacts = totalContacts;
    if (contacts <= 50) return 0;
    if (contacts <= 250) return 1;
    if (contacts <= 500) return 2;
    return 3;
  }

  Timer? _autoScrollTimer;

  int get verificationPageCount {
    if (state.userProfile.value == null) return 0;
    return 3; // Always 3: phone, email, contact (pending + completed)
  }

  void toggleScoreCard() {
    state.scoreCardExpanded.value = !state.scoreCardExpanded.value;
  }

  void startVerificationAutoScroll() {
    _stopVerificationAutoScroll();
    final pageCount = verificationPageCount;
    if (pageCount <= 1) return;

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!scoreCardPageController.hasClients) return;
      final nextPage = (state.scoreCardCurrentPage.value + 1) % pageCount;
      scoreCardPageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopVerificationAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  void resetAutoScrollTimer() {
    if (_autoScrollTimer != null) {
      startVerificationAutoScroll();
    }
  }

  @override
  void onInit() {
    super.onInit();
    homeScrollController.addListener(_onScroll);
    ever(isLoggedIn, (bool loggedIn) {
      if (loggedIn) {
        onTabOpen();
      }
    });
    onTabOpen();
  }

  // void debugScrollPositions() {
  //   final positions = homeScrollController.positions;
  //   print('🔍 ScrollController Positions (${positions.length}):');

  //   for (int i = 0; i < positions.length; i++) {
  //     final position = positions.elementAt(i);
  //     print('  📍 Position $i:');
  //     print('    - context: ${position.context}');
  //     print('    - minScrollExtent: ${position.minScrollExtent}');
  //     print('    - maxScrollExtent: ${position.maxScrollExtent}');
  //     print('    - pixels: ${position.pixels}');
  //     print('    - viewportDimension: ${position.viewportDimension}');
  //     print('    - widget type: ${position.context.runtimeType}');
  //   }

  //   if (positions.isEmpty) {
  //     print('  ❌ NO ScrollPositions attached!');
  //   }
  // }

  Future<void> fetchContactAnalytics() async {
    try {
      final result = await ContactAnalyticsApi.getAnalytics(
        '/contacts/analytics',
      );
      state.analytics.value = result;
      state.totalContacts.value = result.total;
      state.hasAddedContact.value = result.total > 0;
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          UserStore.to.clearStore();
          return;
        }
      }
      // Rethrow so onTabOpen can handle retry
      rethrow;
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await UserProfileApi.getUserProfile();
      state.userProfile.value = response.data;
      if (!allStepsComplete) {
        startVerificationAutoScroll();
      }
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          await UserStore.to.clearStore();
          return;
        }
      }
      rethrow;
    }
  }

  Future<void> onTabOpen({int retryCount = 0}) async {
    LoggerService.loggerInstance.dynamic_d("in on tab open");
    state.isLoading.value = true;
    try {
      // Events don't need auth — fetch independently
      // Profile & analytics need auth — run sequentially to avoid token race
      await Future.wait([fetchEvents(), _fetchAuthenticatedData()]);
    } catch (err) {
      LoggerService.loggerInstance.e('onTabOpen error: $err');

      // Only retry on transient network errors (timeout, connection),
      // NOT on server errors (5xx) — those won't resolve in 2 seconds
      final isTransient =
          err is DioException &&
          (err.type == DioExceptionType.connectionTimeout ||
              err.type == DioExceptionType.sendTimeout ||
              err.type == DioExceptionType.receiveTimeout ||
              err.type == DioExceptionType.connectionError);

      if (isTransient && retryCount < 1) {
        await Future.delayed(const Duration(seconds: 2));
        return onTabOpen(retryCount: retryCount + 1);
      }

      if (err is DioException) {
        ApiErrorHandler.handleError(err, "Failed to load data");
      }
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> _fetchAuthenticatedData() async {
    if (!UserStore.to.isLogin) return;

    // Run sequentially to avoid token refresh race condition,
    // but don't let one failure block the other
    Object? firstError;

    try {
      await fetchUserProfile();
    } catch (e) {
      firstError = e;
    }

    // Skip analytics if profile fetch triggered logout (401 with expired refresh)
    if (!UserStore.to.isLogin) {
      if (firstError != null) throw firstError;
      return;
    }

    try {
      await fetchContactAnalytics();
    } catch (e) {
      if (firstError != null) throw firstError;
      rethrow;
    }

    if (firstError != null) throw firstError;
  }

  void _onScroll() {
    if (!homeScrollController.hasClients) return;

    final maxScroll = homeScrollController.position.maxScrollExtent;
    final currentScroll = homeScrollController.position.pixels;

    const double prefetchThreshold = 200.0;
    if (maxScroll - currentScroll <= prefetchThreshold) {
      if (state.meta.value != null &&
          state.meta.value!.hasNext == true &&
          !state.isFetching.value) {
        LoggerService.loggerInstance.dynamic_d("triggering");
        fetchEventsOnScroll();
      }
    }
  }

  void handleSearchOnChnage(String text) {
    if (text.isEmpty) {
      state.isSearchEmpty.value = true;
    } else {
      state.isSearchEmpty.value = false;
    }
  }

  Future<void> extractColors(String url) async {
    state.dominantColors.clear();
    try {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
            NetworkImage(url),
            maximumColorCount: 5,
          );
      state.dominantColors.add(
        paletteGenerator.dominantColor?.color ?? Colors.grey[300]!,
      );
    } catch (e) {
      state.dominantColors.add(Colors.grey[300]!);
    }
  }

  void navigateToEventInfoPage(Event event) {
    Get.toNamed(RouteName.eventInfoPage, parameters: {'eventId': event.id});
  }

  void navigateToEventCategoryPage({String? category}) {
    Get.toNamed(RouteName.categoriesPage, arguments: {'category': category});
  }

  String getEndpoint() {
    if (state.meta.value == null) {
      return '/events?page=$_currentPage&limit=$_limit';
    }

    final meta = state.meta.value!;
    int nextPage = (meta.page) + 1;

    int nextLimit = meta.limit;

    if (nextPage > meta.totalPages) {
      nextPage = meta.totalPages;
    }

    return '/events?page=$nextPage&limit=$nextLimit';
  }

  Future<void> fetchEvents() async {
    try {
      EventResponse response = await HomeApi.getEventList(
        '/events?page=$_currentPage&limit=$_limit',
      );
      state.events.value = response.data;
      state.meta.value = response.meta;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> fetchEventsOnScroll() async {
    try {
      state.isFetching.value = true;
      EventResponse response = await HomeApi.getEventList(getEndpoint());
      state.events.addAll(response.data);
      state.meta.value = response.meta;
    } catch (e) {
      LoggerService.loggerInstance.e('Failed to load events: $e');
    } finally {
      state.isFetching.value = false;
    }
  }

  /*----- utis -----*/
  String? getUserImageUrl() {
    try {
      final profile = UserStore.to.profile;

      // Check for common image field names
      if (profile.containsKey('avatarUrl') && profile['avatarUrl'] != null) {
        return profile['avatarUrl'].toString();
      }

      return null;
    } catch (e) {
      LoggerService.loggerInstance.e('Error getting user image: $e');
      return null;
    }
  }

  // Returns user initials
  String getUserInitials() {
    try {
      final profile = UserStore.to.profile;

      if (profile.containsKey('name') && profile['name'] != null) {
        List<String> nameParts = profile['name'].split(' ');
        if (nameParts.length > 1) {
          return '${nameParts[0][0].toUpperCase()}${nameParts[1][0].toUpperCase()}';
        }
        return profile['name'].length > 1
            ? profile['name'].substring(0, 2).toUpperCase()
            : profile['name'][0].toUpperCase();
      }

      return 'EJ'; // EventJar
    } catch (e) {
      LoggerService.loggerInstance.e('Error getting user initials: $e');
      return 'EJ';
    }
  }

  String formatEventDateTimeForHome(dynamic event, BuildContext context) {
    try {
      DateTime dateTime;

      // Case 1: ISO string (2024-01-25T06:00:00Z)
      if (event.startTime.contains('T') || event.startTime.contains('Z')) {
        dateTime = DateTime.parse(event.startTime).toLocal();
      }
      // Case 2: HH:mm (06:00)
      else {
        final date = event.startDate as DateTime;
        final parts = event.startTime.split(':');

        dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        ).toLocal();
      }

      // 📅 Jan 25, 2024
      final formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);

      // ⏰ Uses your helper → respects 12/24h
      final formattedTime = formatTimeFromDateTime(dateTime, context);

      return '$formattedDate • $formattedTime';
    } catch (e) {
      LoggerService.loggerInstance.e('Date parse error: $e');
      return 'Invalid date';
    }
  }

  void navigateToAddContact() {
    Get.toNamed(RouteName.addContactPage)?.then((result) {
      if (result == "refresh") {
        final statusCard = NetworkStatusCardData(
          key: 'totalContacts',
          label: 'Total Contacts',
          enumKey: 'all',
          icon: Icons.people,
          color: Colors.blue,
        );

        Get.toNamed(
          RouteName.contactPage,
          arguments: {'statusCard': statusCard},
        );
      }
    });
  }

  void navigateToReceive() {
    Get.toNamed(RouteName.nfcReadPage)?.then((result) {
      if (result == "refresh") {
        final statusCard = NetworkStatusCardData(
          key: 'totalContacts',
          label: 'Total Contacts',
          enumKey: 'all',
          icon: Icons.people,
          color: Colors.blue,
        );

        Get.toNamed(
          RouteName.contactPage,
          arguments: {'statusCard': statusCard},
        );
      }
    });
  }

  void navigateToQrPage() {
    Get.toNamed(RouteName.qrDashboardPage)?.then((result) {
      if (result == "refresh") {
        final statusCard = NetworkStatusCardData(
          key: 'totalContacts',
          label: 'Total Contacts',
          enumKey: 'all',
          icon: Icons.people,
          color: Colors.blue,
        );

        Get.toNamed(
          RouteName.contactPage,
          arguments: {'statusCard': statusCard},
        );
      }
    });
  }

  void navigateToScanPage() {
    Get.toNamed(RouteName.scanCardPage)?.then((result) {
      if (result == "refresh") {
        final statusCard = NetworkStatusCardData(
          key: 'totalContacts',
          label: 'Total Contacts',
          enumKey: 'all',
          icon: Icons.people,
          color: Colors.blue,
        );

        Get.toNamed(
          RouteName.contactPage,
          arguments: {'statusCard': statusCard},
        );
      }
    });
  }

  /*----- Phone OTP Verification -----*/
  Timer? _resendTimer;

  Future<bool> sendPhoneOtp() async {
    final phone = state.userProfile.value?.phone;
    if (phone == null || phone.isEmpty) {
      AppSnackbar.error(
        title: "Error",
        message: "No phone number found on your profile",
      );
      return false;
    }

    state.isSendingOtp.value = true;
    state.otpError.value = '';
    try {
      await VerifyPhoneApi.sendOtp(phone);
      _startResendCooldown();
      return true;
    } catch (err) {
      if (err is DioException) {
        ApiErrorHandler.handleError(err, "Failed to send OTP");
      } else {
        AppSnackbar.error(title: "Error", message: err.toString());
      }
      return false;
    } finally {
      state.isSendingOtp.value = false;
    }
  }

  Future<bool> verifyPhoneOtp(String otp) async {
    final phone = state.userProfile.value?.phone;
    if (phone == null || phone.isEmpty) return false;

    state.isVerifyingOtp.value = true;
    state.otpError.value = '';
    try {
      await VerifyPhoneApi.verifyOtp(phone, otp);
      await fetchUserProfile();
      return true;
    } catch (err) {
      if (err is DioException) {
        final data = err.response?.data;
        if (data is Map && data['message'] is String) {
          state.otpError.value = data['message'];
        } else if (data is String) {
          state.otpError.value = data;
        } else {
          state.otpError.value = 'Verification failed. Please try again.';
        }
      } else {
        state.otpError.value = err.toString();
      }
      return false;
    } finally {
      state.isVerifyingOtp.value = false;
    }
  }

  void _startResendCooldown() {
    state.resendCooldown.value = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCooldown.value <= 1) {
        timer.cancel();
        state.resendCooldown.value = 0;
      } else {
        state.resendCooldown.value--;
      }
    });
  }

  void resetOtpState() {
    state.otpError.value = '';
    state.isSendingOtp.value = false;
    state.isVerifyingOtp.value = false;
  }

  /*----- Email Verification -----*/
  final RxBool isSendingEmailVerification = false.obs;

  Future<bool> sendEmailVerification() async {
    isSendingEmailVerification.value = true;
    try {
      await VerifyEmailApi.resendVerify();
      return true;
    } catch (err) {
      if (err is DioException) {
        ApiErrorHandler.handleError(err, "Failed to send verification email");
      } else {
        AppSnackbar.error(
          title: "Error",
          message: "Something went wrong. Please try again.",
        );
      }
      return false;
    } finally {
      isSendingEmailVerification.value = false;
    }
  }

  void openEmailApp() async {
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: '');
    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        AppSnackbar.error(title: "Error", message: "No email app found.");
      }
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      AppSnackbar.error(title: "Error", message: "Could not open email app.");
    }
  }

  @override
  void onClose() {
    _stopVerificationAutoScroll();
    _resendTimer?.cancel();
    homeScrollController.removeListener(_onScroll);
    homeScrollController.dispose();
    super.onClose();
  }
}

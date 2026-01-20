import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:dio/dio.dart';
import 'package:eventjar/api/contact_api/contact_api.dart';
import 'package:eventjar/controller/contact/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/contact_analytics_model.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var appBarTitle = "Contact Page";
  final state = ContactState();
  late ConfettiController confettiController;
  Timer? _debounceTimer;

  late AnimationController heartbeatController;
  late Animation<double> pulseAnimation;
  late Animation<double> glowAnimation;

  final TextEditingController searchController = TextEditingController();
  ScrollController homeScrollController = ScrollController();
  final int _currentPage = 1;
  final int _limit = 10;

  @override
  void onInit() async {
    final args = Get.arguments;
    if (args != null && args is Map) {
      final statusCard = args['statusCard'] as NetworkStatusCardData?;
      final analytics = args['analytics'] as ContactAnalytics?;

      if (statusCard != null) {
        state.selectedTab.value = statusCard;
      }
      if (analytics != null) {
        state.analytics.value = analytics;
      }
    }

    _initHeartbeat();
    searchController.addListener(() {
      state.searchQuery.value = searchController.text;
    });

    searchController.addListener(() {
      state.searchQuery.value = searchController.text;

      _debounceTimer?.cancel();

      _debounceTimer = Timer(Duration(milliseconds: 500), () {
        if (searchController.text.isNotEmpty) {
          state.isSearching.value = true;
          fetchContactsOnSearch();
        } else {
          state.isSearching.value = false;
          fetchContacts(); // Show all
        }
      });
    });

    _onScroll();

    confettiController = ConfettiController(duration: Duration(seconds: 3));
    // triggerConfetti();

    await fetchContacts();

    super.onInit();
  }

  void _onScroll() {
    if (!homeScrollController.hasClients) return;

    final maxScroll = homeScrollController.position.maxScrollExtent;
    final currentScroll = homeScrollController.position.pixels;

    const double prefetchThreshold = 200.0;
    if (maxScroll - currentScroll <= prefetchThreshold) {
      LoggerService.loggerInstance.dynamic_d("triggering");
      if (state.meta.value != null &&
          state.meta.value!.hasNext == true &&
          !state.isFetching.value) {
        fetchContactsOnScroll();
      }
    }
  }

  void _initHeartbeat() {
    heartbeatController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: heartbeatController, curve: Curves.easeInOut),
    );

    glowAnimation = Tween<double>(begin: 0.2, end: 0.3).animate(
      CurvedAnimation(parent: heartbeatController, curve: Curves.easeInOut),
    );

    heartbeatController.repeat(reverse: true);
  }

  // enum ContactStage {
  //   new
  //   followup_24h
  //   followup_7d
  //   followup_30d
  //   qualified
  // }

  String getEndpoint({bool onRefresh = false}) {
    final searchQuery = state.searchQuery.value.trim();
    final stageKey = state.selectedTab.value!.label;
    LoggerService.loggerInstance.dynamic_d(stageKey);
    final page = onRefresh ? _currentPage : _getNextPage();
    final limit = onRefresh ? _limit : _getLimit();

    var endpoint = '/mobile/contacts?page=$page&limit=$limit';

    if (stageKey.isNotEmpty &&
        stageKey != 'totalContacts' &&
        stageKey != 'overdue') {
      final encodedStage = Uri.encodeComponent(stageKey);
      endpoint += '&stage=$encodedStage';
    }

    if (searchQuery.isNotEmpty) {
      final encodedSearch = Uri.encodeComponent(searchQuery);
      endpoint += '&search=$encodedSearch';
    }

    return endpoint;
  }

  int _getNextPage() {
    if (state.meta.value == null) {
      return 1;
    }

    final meta = state.meta.value!;
    int nextPage = meta.page + 1;

    if (nextPage > meta.totalPages) {
      return meta.totalPages;
    }

    return nextPage;
  }

  int _getLimit() {
    return state.meta.value?.limit ?? _limit;
  }

  Future<void> fetchContacts({bool fromSearch = false}) async {
    try {
      if (fromSearch) {
        state.isSearching.value = true;
      } else {
        state.isLoading.value = true;
      }

      MobileContactResponse response = await ContactApi.getEventList(
        getEndpoint(onRefresh: true),
      );

      state.contacts.value = response.data.contacts;
      state.meta.value = response.data.pagination;
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to load Contacts");
      } else if (err is Exception) {
        AppSnackbar.error(title: "Exception", message: err.toString());
      } else {
        AppSnackbar.error(
          title: "Error",
          message: "Something went wrong (${err.runtimeType})",
        );
      }
    } finally {
      if (state.isSearching.value) {
        state.isSearching.value = false;
      }
      state.isLoading.value = false;
    }
  }

  Future<void> fetchContactsOnSearch() async {
    state.isSearching.value = true;
    fetchContacts(fromSearch: true);
    state.isSearching.value = false;
  }

  Future<void> fetchContactsOnScroll() async {
    try {
      MobileContactResponse response = await ContactApi.getEventList(
        getEndpoint(),
      );

      state.contacts.value = response.data.contacts;
      state.meta.value = response.data.pagination;
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to load Contacts");
      } else if (err is Exception) {
        AppSnackbar.error(title: "Exception", message: err.toString());
      } else {
        AppSnackbar.error(
          title: "Error",
          message: "Something went wrong (${err.runtimeType})",
        );
      }
    }
  }

  Future<void> deleteContactCard(String id) async {
    try {
      state.isLoading.value = true;

      await ContactApi.deleteContact(id);

      await fetchContacts();
    } catch (err) {
      LoggerService.loggerInstance.dynamic_d(err);
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          // Auth error handling example
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to add contact");
      } else {
        AppSnackbar.error(
          title: "Failed",
          message: "Something went wrong. Please try again.",
        );
      }
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> launchPhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        AppSnackbar.warning(
          title: "Failed",
          message: 'Could not launch $phoneNumber',
        );
      }
    } catch (e) {
      AppSnackbar.warning(
        title: "Failed",
        message: 'Could not launch $phoneNumber',
      );
    }
  }

  Future<void> launchEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        AppSnackbar.warning(
          title: "Failed",
          message: 'Could not launch email for $email',
        );
      }
    } catch (e) {
      AppSnackbar.warning(
        title: "Failed",
        message: 'Could not launch email for $email',
      );
    }
  }

  void toggleFilterRow() {
    state.showFilterRow.value = !state.showFilterRow.value;
  }

  void triggerConfetti() {
    // showConfetti.value = true;
    confettiController.play();

    Future.delayed(Duration(seconds: 3), () {
      // showConfetti.value = false;
    });
  }

  /*----- Navigation -----*/
  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage)?.then((result) async {
      if (result == "logged_in") {
        await fetchContacts();
      } else {
        Get.back();
      }
    });
  }

  void navigateToAddContact() {
    Get.toNamed(RouteName.addContactPage)?.then(
      (result) async => {
        if (result == 'refresh') {await fetchContacts()},
      },
    );
  }

  void navigateToUpdateContact(MobileContact contact) {
    Get.toNamed(RouteName.addContactPage, arguments: {contact})?.then(
      (result) async => {
        if (result == 'refresh') {await fetchContacts()},
      },
    );
  }

  void navigateToThankyouMessage(MobileContact contact) {
    Get.toNamed(RouteName.thankYouMessagePage, arguments: contact)?.then((
      result,
    ) async {
      if (result == true) {
        await fetchContacts();
      }
    });
  }

  void navigateToScheduleMeeting(MobileContact contact) {
    Get.toNamed(RouteName.scheduleMeetingPage, arguments: contact)?.then((
      result,
    ) async {
      if (result == true) {
        await fetchContacts();
      }
    });
  }

  void navigateToQualifyLead(MobileContact contact) {
    Get.toNamed(RouteName.qualifyLeadPage, arguments: contact)?.then((
      result,
    ) async {
      if (result == true) {
        await fetchContacts();
      }
    });
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    heartbeatController.dispose();
    super.onClose();
  }
}

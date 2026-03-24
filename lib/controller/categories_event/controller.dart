import 'dart:async';

import 'package:dio/dio.dart';
import 'package:eventjar/api/home_api/home_api.dart';
import 'package:eventjar/controller/categories_event/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/helper/date_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/home/home_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CategoriesEventController extends GetxController {
  var appBarTitle = "Events";
  final state = CategoriesEventState();

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  final int _limit = 10;
  Timer? _searchDebounce;

  bool get isLoading => state.isLoading.value;

  List<String> get tabs => [
    'All',
    ...state.eventcategory.map((e) => e.name ?? ''),
  ];

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    super.onInit();
    scrollController.addListener(_onScroll);
    _initPage();
  }

  Future<void> _initPage() async {
    state.isLoading.value = true;
    await fetchCategory();
    final args = Get.arguments;
    if (args is Map && args['category'] != null) {
      final category = args['category'] as String;
      final idx = tabs.indexWhere(
        (t) => t.toLowerCase() == category.toLowerCase(),
      );
      if (idx != -1) state.selectedTab.value = idx;
    }
    await fetchEvents();
  }

  static const _fallbackCategories = [
    'Networking',
    'Workshop',
    'Health',
    'Education',
  ];

  Future<void> fetchCategory() async {
    try {
      final response = await HomeApi.getCategoryListInfo();
      final categories = response.eventCategories ?? [];
      if (categories.isNotEmpty) {
        state.eventcategory.value = categories;
      } else {
        _setFallbackCategories();
      }
    } catch (err) {
      LoggerService.loggerInstance.e('Failed to load categories: $err');
      _setFallbackCategories();
    }
  }

  void _setFallbackCategories() {
    state.eventcategory.value = _fallbackCategories
        .map((name) => EventCategory(id: name.toLowerCase(), name: name))
        .toList();
  }

  /// Builds /mobile/events with all active filters and the given page.
  String _buildEndpoint(int page) {
    final params = <String, String>{'offset': '0', 'limit': '$_limit'};

    final tabIndex = state.selectedTab.value;
    if (tabIndex != 0 && tabIndex < tabs.length) {
      params['category'] = tabs[tabIndex];
    }

    final query = state.searchQuery.value.trim();
    if (query.isNotEmpty) params['search'] = query;

    final from = state.filterFrom.value;
    if (from != null) {
      params['startDate'] = DateFormat('yyyy-MM-dd').format(from);
    }

    final to = state.filterTo.value;
    if (to != null) params['endDate'] = DateFormat('yyyy-MM-dd').format(to);

    return Uri(path: '/mobile/events', queryParameters: params).toString();
  }

  Future<void> refreshPage() async {
    await fetchCategory();
    await fetchEvents();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    const double prefetchThreshold = 200.0;
    if (maxScroll - currentScroll <= prefetchThreshold) {
      if (state.meta.value != null &&
          state.meta.value!.hasNext == true &&
          !state.isFetching.value) {
        fetchEventsOnScroll();
      }
    }
  }

  Future<void> fetchEvents() async {
    state.isLoading.value = true;
    try {
      final response = await HomeApi.getEventList(_buildEndpoint(1));
      state.events.value = response.data;
      state.meta.value = response.meta;
    } catch (err) {
      if (err is DioException) {
        ApiErrorHandler.handleError(err, "Failed to load Events");
      } else if (err is Exception) {
        AppSnackbar.error(title: "Exception", message: err.toString());
      } else {
        AppSnackbar.error(
          title: "Error",
          message: "Something went wrong (${err.runtimeType})",
        );
      }
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> fetchEventsOnScroll() async {
    try {
      state.isFetching.value = true;
      final nextPage = state.meta.value!.page + 1;
      final response = await HomeApi.getEventList(_buildEndpoint(nextPage));
      state.events.addAll(response.data);
      state.meta.value = response.meta;
    } catch (e) {
      LoggerService.loggerInstance.e('Failed to load events: $e');
    } finally {
      state.isFetching.value = false;
    }
  }

  void toggleSearch() {
    state.isSearching.value = !state.isSearching.value;
    if (!state.isSearching.value) {
      state.searchQuery.value = '';
      searchController.clear();
      fetchEvents();
    }
  }

  void onSearchChanged(String text) {
    state.searchQuery.value = text;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), fetchEvents);
  }

  void setSelectedTab(int index) {
    state.selectedTab.value = index;
    fetchEvents();
  }

  void setDateRange(DateTime? from, DateTime? to) {
    state.filterFrom.value = from;
    state.filterTo.value = to;
    fetchEvents();
  }

  void clearDateRange() {
    state.filterFrom.value = null;
    state.filterTo.value = null;
    fetchEvents();
  }

  List<Event> get filteredEvents => state.events.toList();

  void navigateToEventInfoPage(Event event) {
    Get.toNamed(RouteName.eventInfoPage, parameters: {'eventId': event.id});
  }

  String formatEventDateTime(Event event, BuildContext context) {
    try {
      DateTime dateTime;

      if (event.startTime.contains('T') || event.startTime.contains('Z')) {
        dateTime = DateTime.parse(event.startTime).toLocal();
      } else {
        final date = event.startDate;
        final parts = event.startTime.split(':');
        dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        ).toLocal();
      }

      final formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
      final formattedTime = formatTimeFromDateTime(dateTime, context);

      return '$formattedDate • $formattedTime';
    } catch (e) {
      LoggerService.loggerInstance.e('Date parse error: $e');
      return 'Invalid date';
    }
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}

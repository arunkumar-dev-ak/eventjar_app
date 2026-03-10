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

  bool get isLoading => state.isLoading.value;

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    super.onInit();
    scrollController.addListener(_onScroll);

    // Read initial category from arguments
    final args = Get.arguments;
    if (args is Map && args['category'] != null) {
      final category = args['category'] as String;
      final idx = categoryTabs.indexWhere(
        (t) => t.label.toLowerCase() == category.toLowerCase(),
      );
      if (idx != -1) {
        state.selectedTab.value = idx;
      }
    }

    fetchEvents();
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

  String _getEndpoint() {
    if (state.meta.value == null) {
      return '/events?page=1&limit=$_limit';
    }

    final meta = state.meta.value!;
    int nextPage = meta.page + 1;
    if (nextPage > meta.totalPages) {
      nextPage = meta.totalPages;
    }

    return '/events?page=$nextPage&limit=${meta.limit}';
  }

  Future<void> fetchEvents() async {
    state.isLoading.value = true;
    try {
      EventResponse response = await HomeApi.getEventList(
        '/events?page=1&limit=$_limit',
      );
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
      EventResponse response = await HomeApi.getEventList(_getEndpoint());
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
    }
  }

  void onSearchChanged(String text) {
    state.searchQuery.value = text;
  }

  void setFilterDate(DateTime? date) {
    state.filterDate.value = date;
  }

  void setSelectedTab(int index) {
    state.selectedTab.value = index;
  }

  List<Event> get filteredEvents {
    var events = state.events.toList();

    // Category filter
    final tabIndex = state.selectedTab.value;
    if (tabIndex != 0) {
      final category = categoryTabs[tabIndex].label.toLowerCase();
      events = events.where((e) {
        final eventCategory = e.category?.name.toLowerCase() ?? '';
        return eventCategory == category;
      }).toList();
    }

    // Search filter
    final query = state.searchQuery.value.toLowerCase();
    if (query.isNotEmpty) {
      events = events.where((e) {
        return e.title.toLowerCase().contains(query) ||
            e.organizer.name.toLowerCase().contains(query) ||
            e.description.toLowerCase().contains(query);
      }).toList();
    }

    // Date filter
    final filterDate = state.filterDate.value;
    if (filterDate != null) {
      events = events.where((e) {
        return e.startDate.year == filterDate.year &&
            e.startDate.month == filterDate.month &&
            e.startDate.day == filterDate.day;
      }).toList();
    }

    return events;
  }

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

  static const List<CategoryTab> categoryTabs = [
    CategoryTab(label: 'All', color: Color(0xFF1A73E8)),
    CategoryTab(label: 'Networking', color: Color(0xFF1A73E8)),
    CategoryTab(label: 'Workshop', color: Color(0xFF9C27B0)),
    CategoryTab(label: 'Health', color: Color(0xFFE91E63)),
    CategoryTab(label: 'Education', color: Color(0xFF607D8B)),
  ];

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}

class CategoryTab {
  final String label;
  final Color color;

  const CategoryTab({required this.label, required this.color});
}

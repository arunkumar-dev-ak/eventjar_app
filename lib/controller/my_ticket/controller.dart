import 'package:dio/dio.dart';
import 'package:eventjar/api/my_ticket_api/my_ticket_api.dart';
import 'package:eventjar/controller/dashboard/controller.dart';
import 'package:eventjar/controller/my_ticket/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/global_values.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/page/my_ticket/widget/my_ticketdate_range_picker_widget.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTicketController extends GetxController {
  var appBarTitle = "EventJar";
  final state = MyTicketsState();
  final DashboardController dashboardController = Get.find();

  final int itemsPerPage = 10;

  bool get hasNext => state.pagination.value?.paging.links.next != null;

  // scroll controller
  final upcomingScrollController = ScrollController();
  final completedScrollController = ScrollController();
  final searchController = TextEditingController();

  Worker? _searchWorker;
  Worker? _dateWorker;

  @override
  void onInit() {
    super.onInit();
    upcomingScrollController.addListener(_onUpcomingScroll);
    completedScrollController.addListener(_onCompletedScroll);
    _initWorkers();
  }

  void _initWorkers() {
    _searchWorker = debounce(
      state.searchQuery,
      (_) => fetchMyTickets(),
      time: const Duration(milliseconds: 500),
    );

    _dateWorker = ever(state.selectedDateRange, (_) => fetchMyTickets());
  }

  void onTabOpen() {
    UserStore.cancelAllRequests();
    state.tickets.value = [];
    state.pagination.value = null;
    fetchMyTickets();
  }

  String getDisplayText() {
    if (state.selectedDateRange.value == null) return 'All Time';

    final start = _formatDate(state.selectedDateRange.value!.start);
    final end = _formatDate(state.selectedDateRange.value!.end);
    return '$start - $end';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final monthName = months[date.month - 1];
    return '$monthName ${date.day}, ${date.year}';
  }

  void onSearch(String value) {
    state.searchQuery.value = value;
  }

  void toggleFilters() {
    state.showFilters.value = !state.showFilters.value;
  }

  void changeTab(int index) {
    if (state.selectedTab.value == index) return;

    // Dispose workers to prevent auto-fetch on reset
    _searchWorker?.dispose();
    _dateWorker?.dispose();

    searchController.clear();
    state.searchQuery.value = '';
    state.selectedDateRange.value = null;
    state.selectedTab.value = index;

    fetchMyTickets();
    _initWorkers();
  }

  Future<void> pickDateRange() async {
    final range = await MyTicketDateRangePickerWidget.show(
      initialRange: state.selectedDateRange.value,
      selectedTab: state.selectedTab.value,
    );

    state.selectedDateRange.value = range;
  }

  void _handleScroll(ScrollController controller) {
    if (!controller.hasClients) return;

    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.position.pixels;
    const double prefetchThreshold = 200;

    if (maxScroll - currentScroll <= prefetchThreshold) {
      if (hasNext && !state.isLoadingMore.value && !state.isLoading.value) {
        loadMoreTickets();
      }
    }
  }

  void _onUpcomingScroll() {
    if (state.selectedTab.value != 0) return;
    _handleScroll(upcomingScrollController);
  }

  void _onCompletedScroll() {
    if (state.selectedTab.value != 1) return;
    _handleScroll(completedScrollController);
  }

  /*----- Api Calls -----*/
  String _buildUrl() {
    String url = "/mobile/tickets/my-registrations";
    List<String> queryParams = [];

    if (state.searchQuery.value.isNotEmpty) {
      queryParams.add("eventName=${state.searchQuery.value}");
    }

    /*------ Date filter -------*/
    if (state.selectedDateRange.value != null) {
      final dateRange = state.selectedDateRange.value!;
      final fromDateUtc = dateRange.start.toUtc();
      var toDateUtc = dateRange.end.toUtc();

      if (fromDateUtc.isAtSameMomentAs(toDateUtc)) {
        toDateUtc = toDateUtc.add(
          const Duration(hours: 23, minutes: 59, seconds: 59),
        );
      }

      queryParams.add("eventStartDate=${fromDateUtc.toIso8601String()}");
      queryParams.add("eventEndDate=${toDateUtc.toIso8601String()}");
    }

    queryParams.add(
      "status=${state.selectedTab.value == 1 ? "completed" : "existing"}",
    );
    queryParams.add("limit=$itemsPerPage");
    queryParams.add("offset=0");

    if (queryParams.isNotEmpty) {
      url += "?${queryParams.join("&")}";
    }
    return url;
  }

  Future<void> fetchMyTickets() async {
    try {
      state.isLoading.value = true;

      final url = _buildUrl();
      final response = await MyTicketsApi.getMyTickets(url);

      state.tickets.value = response.data;
      state.pagination.value = response.meta;
    } catch (err) {
      state.tickets.value = [];

      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to load tickets");
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
      if (state.isLoadingMore.value) {
        state.isLoadingMore.value = false;
      }
    }
  }

  Future<void> loadMoreTickets() async {
    final nextUrl = state.pagination.value?.paging.links.next;

    if (nextUrl == null || state.isLoadingMore.value) {
      return;
    }

    try {
      state.isLoadingMore.value = true;

      final url = '${backendBaseUrl()}/$nextUrl';
      final response = await MyTicketsApi.getMyTickets(url);

      state.tickets.addAll(response.data);
      state.pagination.value = response.meta;
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to load more tickets");
      } else {
        AppSnackbar.error(
          title: "Error",
          message: "Failed to load more tickets",
        );
      }
    } finally {
      if (state.isLoadingMore.value) state.isLoadingMore.value = false;
      if (state.isLoading.value) state.isLoading.value = false;
    }
  }

  Future<void> refreshTickets() async {
    state.searchQuery.value = "";
    state.selectedDateRange.value = null;
    await fetchMyTickets();
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage)?.then((result) {
      if (result == "logged_in") {
        onTabOpen();
      } else {
        dashboardController.state.selectedIndex.value = 0;
      }
    });
  }

  void toggleQRCode(int ticketId) {
    if (state.expandedTickets.contains(ticketId)) {
      state.expandedTickets.remove(ticketId);
    } else {
      state.expandedTickets.add(ticketId);
    }
  }

  void navigateToEventInfo(String ticketId) {
    Get.toNamed(RouteName.eventInfoPage, arguments: {"ticketId": ticketId});
  }

  // ✅ CLEANUP
  @override
  void onClose() {
    _searchWorker?.dispose();
    _dateWorker?.dispose();
    upcomingScrollController.removeListener(_onUpcomingScroll);
    completedScrollController.removeListener(_onCompletedScroll);
    upcomingScrollController.dispose();
    completedScrollController.dispose();
    super.onClose();
  }
}

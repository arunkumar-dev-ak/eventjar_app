import 'package:dio/dio.dart';
import 'package:eventjar/api/my_ticket_api/my_ticket_api.dart';
import 'package:eventjar/controller/dashboard/controller.dart';
import 'package:eventjar/controller/my_ticket/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTicketController extends GetxController {
  var appBarTitle = "EventJar";
  final state = MyTicketsState();
  final DashboardController dashboardController = Get.find();

  final int itemsPerPage = 10;

  // ✅ ADD scroll controller
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  void onTabOpen() {
    fetchMyTickets();
  }

  // ✅ SCROLL LISTENER (auto pagination trigger)
  void _onScroll() {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;

    const double prefetchThreshold = 200;

    if (maxScroll - currentScroll <= prefetchThreshold) {
      if (state.pagination.value != null &&
          state.pagination.value!.hasNextPage &&
          !state.isLoadingMore.value &&
          !state.isLoading.value) {
        loadMoreTickets();
      }
    }
  }

  Future<void> fetchMyTickets() async {
    try {
      state.isLoading.value = true;
      state.currentPage.value = 1;

      final response = await MyTicketsApi.getMyRegistrations(
        page: state.currentPage.value,
        limit: itemsPerPage,
      );

      state.tickets.value = response.data.registrations;
      state.pagination.value = response.data.pagination;
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
    }
  }

  Future<void> loadMoreTickets() async {
    if (state.pagination.value == null ||
        !state.pagination.value!.hasNextPage ||
        state.isLoadingMore.value) {
      return;
    }

    try {
      LoggerService.loggerInstance.dynamic_d("Loading more tickets");
      state.isLoadingMore.value = true;
      state.currentPage.value++;

      final response = await MyTicketsApi.getMyRegistrations(
        page: state.currentPage.value,
        limit: itemsPerPage,
      );

      state.tickets.addAll(response.data.registrations);
      state.pagination.value = response.data.pagination;
    } catch (err) {
      state.currentPage.value--;

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
      state.isLoadingMore.value = false;
    }
  }

  Future<void> refreshTickets() async {
    state.currentPage.value = 1;
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

  // ✅ CLEANUP
  @override
  void onClose() {
    // scrollController.removeListener(_onScroll);
    // scrollController.dispose();
    super.onClose();
  }
}

import 'package:dio/dio.dart';
import 'package:eventjar_app/api/my_ticket_api/my_ticket_api.dart';
import 'package:eventjar_app/controller/my_ticket/state.dart';
import 'package:eventjar_app/global/app_snackbar.dart';
import 'package:eventjar_app/helper/apierror_handler.dart';
import 'package:eventjar_app/logger_service.dart';
import 'package:get/get.dart';

class MyTicketController extends GetxController {
  var appBarTitle = "EventJar";
  final state = MyTicketsState();

  final int itemsPerPage = 10;

  @override
  void onInit() {
    super.onInit();
  }

  void onTabOpen() {
    if (state.tickets.isEmpty) {
      fetchMyTickets();
    }
  }

  Future<void> fetchMyTickets() async {
    try {
      state.isLoading.value = true;

      final response = await MyTicketsApi.getMyRegistrations(
        page: state.currentPage.value,
        limit: itemsPerPage,
      );

      state.tickets.value = response.data.registrations;
      state.pagination.value = response.data.pagination;
    } catch (err) {
      LoggerService.loggerInstance.e(err.runtimeType);
      LoggerService.loggerInstance.dynamic_d(err);
      if (err is DioException) {
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

  void toggleQRCode(int ticketId) {
    if (state.expandedTickets.contains(ticketId)) {
      state.expandedTickets.remove(ticketId);
    } else {
      state.expandedTickets.add(ticketId);
    }
  }
}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:eventjar/api/contact_api/contact_api.dart';
import 'package:eventjar/api/scheduler/scheduler_api.dart';
import 'package:eventjar/controller/scheduler/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SchedulerController extends GetxController {
  var appBarTitle = "Schedule Meeting";
  final state = SchedulerState();
  final formKey = GlobalKey<FormState>();

  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    getQualifiedContactList();
    state.scheduledAt.value = DateTime.now().add(Duration(minutes: 30));
    state.dateTimeController.text = getFormattedDate(state.scheduledAt.value);
    state.selectedDurationMap.value = state.durations.first;
  }

  String? validateContact(String? value) {
    if (state.selectedContact.value == null) {
      return "Please select a qualified contact";
    }
    return null;
  }

  String? validateDate(String? value) {
    if (state.scheduledAt.value == null) {
      return "Please select date and time";
    }
    return null;
  }

  String? validateDuration(String? value) {
    final Map<String, String>? durationMap = state.selectedDurationMap.value;
    if (durationMap == null || durationMap.isEmpty) {
      return "Please select duration";
    }
    return null;
  }

  void selectContact(MobileContact contact) {
    state.selectedContact.value = contact;
    update();
  }

  void selectDuration(Map<String, String> duration) {
    state.selectedDurationMap.value = duration;
    update();
  }

  Future<void> pickDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.scheduledAt.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          state.scheduledAt.value ?? DateTime.now(),
        ),
      );

      LoggerService.loggerInstance.dynamic_d(time);

      if (time != null) {
        state.scheduledAt.value = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
      }

      state.dateTimeController.text = getFormattedDate(state.scheduledAt.value);
    }
  }

  void getQualifiedContactList() {
    state.isContactDropdownLoading.value = true;

    try {
      // Your qualified contact API endpoint
      final endPoint = '/mobile/contacts?limit=25&page=1&stage=qualified';

      ContactApi.getEventList(endPoint)
          .then((MobileContactResponse response) {
            state.contacts.value = response.data.contacts;
            state.meta.value = response.data.pagination;
          })
          .onError((error, stackTrace) {
            if (error is DioException) {
              final statusCode = error.response?.statusCode;
              if (statusCode == 401) {
                UserStore.to.clearStore();
                Get.offAllNamed('/sign-in');
                return;
              }
              ApiErrorHandler.handleError(
                error,
                'Failed to load Qualified Contacts',
              );
            } else {
              AppSnackbar.error(
                title: 'Error',
                message: 'Failed to load contacts',
              );
            }
          })
          .whenComplete(() {
            state.isContactDropdownLoading.value = false;
          });
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      state.isContactDropdownLoading.value = false;
      AppSnackbar.error(title: 'Error', message: 'Failed to load contacts');
    }
  }

  void onSearchChanged(String? val) {
    if (state.isContactDropdownLoading.value) return;

    final String query = val?.trim() ?? '';

    // Cancel previous debounce
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    // Show loading state
    state.isContactDropdownLoading.value = true;

    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      try {
        // Build endpoint with search=param
        final String endpoint =
            '/mobile/contacts?limit=25&page=1&stage=qualified&search=${Uri.encodeComponent(query)}';

        ContactApi.getEventList(endpoint)
            .then((MobileContactResponse response) {
              state.contacts.value = response.data.contacts;
              state.meta.value = response.data.pagination;
            })
            .onError((error, stackTrace) {
              if (error is DioException) {
                final statusCode = error.response?.statusCode;
                if (statusCode == 401) {
                  UserStore.to.clearStore();
                  Get.offAllNamed('/sign-in');
                  return;
                }
                ApiErrorHandler.handleError(error, 'Search failed');
              } else {
                AppSnackbar.error(
                  title: 'Search Error',
                  message: 'Failed to search',
                );
              }
            })
            .whenComplete(() {
              state.isContactDropdownLoading.value = false;
            });
      } catch (e) {
        LoggerService.loggerInstance.e(e);
        state.isContactDropdownLoading.value = false;
        AppSnackbar.error(title: 'Error', message: 'Search failed');
      }
    });
  }

  void onLoadMoreClicked() {
    if (state.isContactDropdownLoadMoreLoading.value) return;

    final currentMeta = state.meta.value;
    if (currentMeta == null) return;
    if (!currentMeta.hasNext) return;

    state.isContactDropdownLoadMoreLoading.value = true;

    try {
      final int nextPage = currentMeta.page + 1;
      final String endpoint =
          '/mobile/contacts?limit=25&page=$nextPage&stage=qualified';

      ContactApi.getEventList(endpoint)
          .then((MobileContactResponse response) {
            state.contacts.addAll(response.data.contacts);
            state.meta.value = response.data.pagination;
          })
          .onError((error, stackTrace) {
            if (error is DioException) {
              final statusCode = error.response?.statusCode;
              if (statusCode == 401) {
                UserStore.to.clearStore();
                Get.offAllNamed('/sign-in');
                return;
              }
              ApiErrorHandler.handleError(error, 'Load more failed');
            } else {
              AppSnackbar.error(title: 'Error', message: 'Failed to load more');
            }
          })
          .whenComplete(() {
            state.isContactDropdownLoadMoreLoading.value = false;
          });
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      state.isContactDropdownLoadMoreLoading.value = false;
      AppSnackbar.error(title: 'Error', message: 'Failed to load more');
    }
  }

  void onRefreshClicked() {
    state.isContactDropdownLoading.value = true;
    state.isContactDropdownLoadMoreLoading.value = false;

    try {
      final String endpoint =
          '/mobile/contacts?limit=25&page=1&stage=qualified';

      ContactApi.getEventList(endpoint)
          .then((MobileContactResponse response) {
            state.contacts.value = response.data.contacts;
            state.meta.value = response.data.pagination;
          })
          .onError((error, stackTrace) {
            if (error is DioException) {
              final statusCode = error.response?.statusCode;
              if (statusCode == 401) {
                UserStore.to.clearStore();
                Get.offAllNamed('/sign-in');
                return;
              }
              ApiErrorHandler.handleError(error, 'Refresh failed');
            } else {
              AppSnackbar.error(
                title: 'Refresh Error',
                message: 'Failed to refresh',
              );
            }
          })
          .whenComplete(() {
            state.isContactDropdownLoading.value = false;
          });
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      state.isContactDropdownLoading.value = false;
      AppSnackbar.error(title: 'Error', message: 'Failed to refresh');
    }
  }

  void clearForm() {
    state.selectedContact.value = null;
    state.scheduledAt.value = DateTime.now().add(Duration(minutes: 30));
    state.dateTimeController.text = getFormattedDate(state.scheduledAt.value);
    state.selectedDurationMap.value = null;
    state.selectedDurationMap.value = null;
    state.notesController.clear();
    state.contactController.clear();
  }

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    Get.focusScope?.unfocus();

    final contact = state.selectedContact.value;
    if (contact == null) {
      AppSnackbar.warning(
        title: 'Invalid',
        message: 'Please select a qualified contact',
      );
      return;
    }

    if (state.scheduledAt.value == null) {
      AppSnackbar.warning(
        title: 'Invalid',
        message: 'Please select valid date & time',
      );
      return;
    }

    final Map<String, String>? durationMap = state.selectedDurationMap.value;
    if (durationMap == null || durationMap.isEmpty) {
      AppSnackbar.warning(title: 'Invalid', message: 'Please select duration');
      return;
    }

    if (state.isLoading.value) return;

    try {
      state.isLoading.value = true;

      // Prepare DTO
      final Map<String, dynamic> dto = {
        'contactId': contact.id,
        'scheduledAt': state.scheduledAt.value!.toIso8601String(),
        'duration': int.tryParse(
          state.selectedDurationMap.value?['key'] ?? '0',
        ),
        if (state.notesController.text.trim().isNotEmpty)
          'notes': state.notesController.text.trim(),
      };

      final bool created = await SchedulerApi.createMeeting(dto);

      if (created) {
        AppSnackbar.success(
          title: "Meeting Scheduled",
          message: "Your meeting has been scheduled successfully.",
        );

        clearForm();

        // Close and signal refresh
        Navigator.pop(context, "refresh");
      } else {
        final String errorMsg = "Something Went Wrong";
        AppSnackbar.error(title: "Failed", message: errorMsg);
      }
    } catch (err) {
      LoggerService.loggerInstance.e(err);
      if (err is DioException) {
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }
        ApiErrorHandler.handleError(err, "Failed to Schedule Meeting");
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

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage);
  }

  String getFormattedDate(DateTime? date) {
    if (date == null) return "Select date & time";
    return DateFormat('MMM dd, yyyy - h:mm a').format(date);
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    state.contactController.dispose();
    state.notesController.dispose();
    state.dateTimeController.dispose();
    super.onClose();
  }
}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:eventjar/api/contact_api/contact_api.dart';
import 'package:eventjar/api/scheduler/scheduler_api.dart';
import 'package:eventjar/controller/scheduler/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting_status.dart';
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
  bool get isRescheduleMode => state.selectedMeeting.value != null;

  @override
  void onInit() {
    super.onInit();
    final ContactMeeting? meeting = Get.arguments;
    if (meeting != null) {
      _initializeForReschedule(meeting);
    } else {
      _initializeForNewMeeting();
    }

    getQualifiedContactList();
  }

  void _initializeForReschedule(ContactMeeting meeting) {
    state.selectedMeeting.value = meeting;
    appBarTitle = "Reschedule Meeting";

    state.scheduledAt.value = meeting.scheduledAt.toLocal();
    state.dateTimeController.text = getFormattedDate(state.scheduledAt.value);

    final durationMatch = state.durations.firstWhere(
      (d) => d['key'] == meeting.duration.toString(),
      orElse: () => state.durations[1],
    );
    state.selectedDurationMap.value = durationMatch;

    final statusMatch = MeetingStatusForReschedule.values.firstWhere(
      (d) => d == meeting.status,
      orElse: () =>
          state.selectedStatus.value = MeetingStatusForReschedule.SCHEDULED,
    );
    state.selectedStatus.value = statusMatch;

    if (meeting.notes != null && meeting.notes!.isNotEmpty) {
      state.notesController.text = meeting.notes!;
    } else {
      state.notesController.clear();
    }
  }

  void _initializeForNewMeeting() {
    appBarTitle = "Schedule Meeting";
    state.scheduledAt.value = DateTime.now().add(const Duration(minutes: 30));
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
  }

  void selectDuration(Map<String, String> duration) {
    state.selectedDurationMap.value = duration;
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
    if (state.selectedMeeting.value == null) {
      state.selectedContact.value = null;
      state.scheduledAt.value = DateTime.now().add(Duration(minutes: 30));
      state.dateTimeController.text = getFormattedDate(state.scheduledAt.value);
      state.selectedDurationMap.value = null;
      state.selectedDurationMap.value = null;
      state.notesController.clear();
      state.contactController.clear();
    } else {
      _initializeForReschedule(state.selectedMeeting.value!);
    }
  }

  /*----- build sending data -----*/
  Map<String, dynamic> _buildNewMeetingDto(MobileContact contact) {
    final scheduledAtUtc = state.scheduledAt.value!.toUtc();
    return {
      'contactId': contact.id,
      'scheduledAt': scheduledAtUtc.toIso8601String(),
      'duration': int.tryParse(state.selectedDurationMap.value!['key'] ?? '0'),
      if (state.notesController.text.trim().isNotEmpty)
        'notes': state.notesController.text.trim(),
    };
  }

  Map<String, dynamic> _buildRescheduleDto() {
    final meeting = state.selectedMeeting.value!;
    final dto = <String, dynamic>{};

    if (_hasDateTimeChanged(meeting.scheduledAt)) {
      dto['scheduledAt'] = state.scheduledAt.value!.toUtc().toIso8601String();
    }

    return dto;
  }

  // Change detection
  // bool _hasStatusChanged(String originalStatus) {
  //   return state.selectedStatus.value?.name != originalStatus;
  // }

  bool _hasDateTimeChanged(DateTime original) {
    return !original.isAtSameMomentAs(state.scheduledAt.value!);
  }

  // bool _hasDurationChanged(int original) {
  //   return int.tryParse(state.selectedDurationMap.value?['key'] ?? '0') !=
  //       original;
  // }

  // bool _hasNotesChanged(String? original) {
  //   final originalNotes = original ?? '';
  //   return state.notesController.text.trim() != originalNotes;
  // }

  // bool _hasDeclineReasonChanged(String? original) {
  //   final originalReason = original ?? '';
  //   final newReason = state.notesController.text.trim();
  //   return newReason != originalReason && newReason.isNotEmpty;
  // }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) return false;

    Get.focusScope?.unfocus();

    // Skip contact validation for reschedule mode
    if (!isRescheduleMode && state.selectedContact.value == null) {
      AppSnackbar.warning(
        title: 'Invalid',
        message: 'Please select a qualified contact',
      );
      return false;
    }

    if (state.scheduledAt.value == null) {
      AppSnackbar.warning(
        title: 'Invalid',
        message: 'Please select valid date & time',
      );
      return false;
    }

    final durationMap = state.selectedDurationMap.value;
    if (durationMap == null || durationMap.isEmpty) {
      AppSnackbar.warning(title: 'Invalid', message: 'Please select duration');
      return false;
    }

    // Status validation only for reschedule
    if (isRescheduleMode && state.selectedStatus.value == null) {
      AppSnackbar.warning(title: 'Invalid', message: 'Please select status');
      return false;
    }

    if (state.isLoading.value) return false;

    return true;
  }

  Future<void> submitForm(BuildContext context) async {
    // ✅ Step 1: Validate form
    if (!_validateForm()) return;
    bool success = false;

    try {
      state.isLoading.value = true;

      if (isRescheduleMode) {
        final dto = _buildRescheduleDto();
        // LoggerService.loggerInstance.dynamic_d(dto);
        // LoggerService.loggerInstance.dynamic_d(state.selectedMeeting.value!.id);

        if (dto.isEmpty) {
          Navigator.pop(context);
          return;
        }

        await SchedulerApi.rescheduleMeeting(
          dto: dto,
          id: state.selectedMeeting.value!.id,
        );
        success = true;
      } else {
        final contact = state.selectedContact.value!;
        final dto = _buildNewMeetingDto(contact);
        await SchedulerApi.createMeeting(dto);
        success = true;
      }

      // ✅ Step 3: Handle success
      if (success) {
        final title = isRescheduleMode
            ? "Meeting Rescheduled"
            : "Meeting Scheduled";
        final message =
            "Your meeting has been ${isRescheduleMode ? 'rescheduled' : 'scheduled'} successfully.";

        AppSnackbar.success(title: title, message: message);
        Navigator.pop(context, "refresh");
      } else {
        AppSnackbar.error(title: "Failed", message: "Something went wrong");
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
        ApiErrorHandler.handleError(
          err,
          isRescheduleMode
              ? "Failed to reschedule meeting"
              : "Failed to schedule meeting",
        );
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

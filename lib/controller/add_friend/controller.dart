import 'dart:async';

import 'package:dio/dio.dart';
import 'package:eventjar/api/add_friend_api/add_friend_api.dart';
import 'package:eventjar/api/contact_api/contact_api.dart';
import 'package:eventjar/controller/add_friend/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:get/get.dart';

class AddFriendController extends GetxController {
  final state = AddFriendState();

  final formKey = GlobalKey<FormState>();

  final String appBarTitle = "Add Friend";

  Timer? _debounceTimer;

  /// 🔹 Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void onInit() {
    // Default type
    state.selectedType.value = AddFriendType.contact;

    super.onInit();

    getContactList();

    emailController.addListener(() {
      final hasText = emailController.text.trim().isNotEmpty;
      state.hasValidEmail.value = hasText;

      // If they clear the email field, automatically turn off the email switch
      if (!hasText && state.sendViaEmail.value) {
        state.sendViaEmail.value = false;
      }
    });
  }

  /// ================= CHANGE TYPE =================
  void changeType(AddFriendType type) {
    state.selectedType.value = type;

    /// Reset form
    clearForm();
  }

  /// ================= SELECT CONTACT =================
  void onContactSelected(MobileContact contact) {
    state.selectedContact.value = contact;

    nameController.text = contact.name;
    emailController.text = contact.email;
    phoneController.text = contact.phoneParsed?.phoneNumber ?? "";

    final selectedCountryCode = contact.phoneParsed?.countryCode ?? "+91";
    final String cleanCountryCode = selectedCountryCode.replaceAll('+', '');
    state.selectedCountry.value = countries.firstWhere(
      (country) => country.fullCountryCode == cleanCountryCode,
      orElse: () => countries.first,
    );
  }

  /// ================= CLEAR =================
  void clearForm() {
    state.selectedContact.value = null;

    nameController.clear();
    emailController.clear();
    phoneController.clear();

    state.sendViaEmail.value = false;
    state.sendViaPhone.value = false;
  }

  /// ================= SUBMIT =================

  String _getSource() {
    if (state.selectedType.value == AddFriendType.contact) {
      return "contact";
    }

    if (state.sendViaEmail.value && emailController.text.trim().isNotEmpty) {
      return "email";
    }

    return "phone";
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    // Contact mode validation
    if (state.selectedType.value == AddFriendType.contact &&
        state.selectedContact.value == null) {
      AppSnackbar.warning(
        title: "Contact Required",
        message: "Please select a contact before sending the invitation.",
      );
      return;
    }

    try {
      state.isLoading.value = true;

      final countryCode = state.selectedCountry.value.fullCountryCode;
      final localPhoneNumber = phoneController.text.trim();
      final fullPhoneNumber = '+$countryCode$localPhoneNumber';

      final payload = {
        "source": _getSource(),
        "invitedName": nameController.text.trim(),
        "invitedPhone": fullPhoneNumber.trim(),
      };

      if (emailController.text.trim().isNotEmpty) {
        payload["invitedEmail"] = emailController.text.trim();
      }

      if (state.selectedType.value == AddFriendType.contact &&
          state.selectedContact.value != null) {
        payload["contactId"] = state.selectedContact.value!.id;
      }

      LoggerService.loggerInstance.dynamic_d(payload);

      await AddFriendApi.addFriend(data: payload);

      clearForm();

      AppSnackbar.success(title: 'Added', message: 'Friend Added Successfully');

      Navigator.pop(Get.context!, "refresh");
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "Failed to send invitation",
        onUnauthorized: () {
          navigateToSignInPage();
        },
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  /// ================= DROPDOWN EVENTS =================
  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage);
  }

  void getContactList() {
    state.isContactDropdownLoading.value = true;

    try {
      // Your qualified contact API endpoint
      final endPoint = '/mobile/contacts?limit=25&page=1';

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
              ApiErrorHandler.handleDioError(
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
                ApiErrorHandler.handleDioError(error, 'Search failed');
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
      final String endpoint = '/mobile/contacts?limit=25&page=$nextPage';

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
              ApiErrorHandler.handleDioError(error, 'Load more failed');
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
              ApiErrorHandler.handleDioError(error, 'Refresh failed');
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

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}

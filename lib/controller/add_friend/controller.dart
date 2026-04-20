import 'package:eventjar/controller/add_friend/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFriendController extends GetxController {
  final state = AddFriendState();

  final formKey = GlobalKey<FormState>();

  var appBarTitle = "Add Friend";

  @override
  void onInit() {
    state.selectedType.value = AddFriendType.contact;
    super.onInit();
  }

  /// Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  void changeType(AddFriendType type) {
    state.selectedType.value = type;

    /// clear fields when switching
    nameController.clear();
    emailController.clear();
    phoneController.clear();
  }

  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final type = state.selectedType.value;

    if (type == AddFriendType.contact) {
      print("Selected contact: ${state.selectedContact.value}");
    } else if (type == AddFriendType.email) {
      print("Email: ${emailController.text}");
    } else {
      print("Phone: ${phoneController.text}");
    }
  }

  /*----- Paginated Contact -----*/
  void getQualifiedContactList() {
    // state.isContactDropdownLoading.value = true;

    // try {
    //   // Your qualified contact API endpoint
    //   final endPoint = '/mobile/contacts?limit=25&page=1&stage=qualified';

    //   ContactApi.getEventList(endPoint)
    //       .then((MobileContactResponse response) {
    //         state.contacts.value = response.data.contacts;
    //         state.meta.value = response.data.pagination;
    //       })
    //       .onError((error, stackTrace) {
    //         if (error is DioException) {
    //           final statusCode = error.response?.statusCode;
    //           if (statusCode == 401) {
    //             UserStore.to.clearStore();
    //             Get.offAllNamed('/sign-in');
    //             return;
    //           }
    //           ApiErrorHandler.handleError(
    //             error,
    //             'Failed to load Qualified Contacts',
    //           );
    //         } else {
    //           AppSnackbar.error(
    //             title: 'Error',
    //             message: 'Failed to load contacts',
    //           );
    //         }
    //       })
    //       .whenComplete(() {
    //         state.isContactDropdownLoading.value = false;
    //       });
    // } catch (e) {
    //   LoggerService.loggerInstance.e(e);
    //   state.isContactDropdownLoading.value = false;
    //   AppSnackbar.error(title: 'Error', message: 'Failed to load contacts');
    // }
  }

  void onSearchChanged(String? val) {
    // if (state.isContactDropdownLoading.value) return;

    // final String query = val?.trim() ?? '';

    // // Cancel previous debounce
    // if (_debounceTimer?.isActive ?? false) {
    //   _debounceTimer?.cancel();
    // }

    // // Show loading state
    // state.isContactDropdownLoading.value = true;

    // _debounceTimer = Timer(const Duration(milliseconds: 800), () {
    //   try {
    //     // Build endpoint with search=param
    //     final String endpoint =
    //         '/mobile/contacts?limit=25&page=1&stage=qualified&search=${Uri.encodeComponent(query)}';

    //     ContactApi.getEventList(endpoint)
    //         .then((MobileContactResponse response) {
    //           state.contacts.value = response.data.contacts;
    //           state.meta.value = response.data.pagination;
    //         })
    //         .onError((error, stackTrace) {
    //           if (error is DioException) {
    //             final statusCode = error.response?.statusCode;
    //             if (statusCode == 401) {
    //               UserStore.to.clearStore();
    //               Get.offAllNamed('/sign-in');
    //               return;
    //             }
    //             ApiErrorHandler.handleError(error, 'Search failed');
    //           } else {
    //             AppSnackbar.error(
    //               title: 'Search Error',
    //               message: 'Failed to search',
    //             );
    //           }
    //         })
    //         .whenComplete(() {
    //           state.isContactDropdownLoading.value = false;
    //         });
    //   } catch (e) {
    //     LoggerService.loggerInstance.e(e);
    //     state.isContactDropdownLoading.value = false;
    //     AppSnackbar.error(title: 'Error', message: 'Search failed');
    //   }
    // });
  }

  void onLoadMoreClicked() {
    // if (state.isContactDropdownLoadMoreLoading.value) return;

    // final currentMeta = state.meta.value;
    // if (currentMeta == null) return;
    // if (!currentMeta.hasNext) return;

    // state.isContactDropdownLoadMoreLoading.value = true;

    // try {
    //   final int nextPage = currentMeta.page + 1;
    //   final String endpoint =
    //       '/mobile/contacts?limit=25&page=$nextPage&stage=qualified';

    //   ContactApi.getEventList(endpoint)
    //       .then((MobileContactResponse response) {
    //         state.contacts.addAll(response.data.contacts);
    //         state.meta.value = response.data.pagination;
    //       })
    //       .onError((error, stackTrace) {
    //         if (error is DioException) {
    //           final statusCode = error.response?.statusCode;
    //           if (statusCode == 401) {
    //             UserStore.to.clearStore();
    //             Get.offAllNamed('/sign-in');
    //             return;
    //           }
    //           ApiErrorHandler.handleError(error, 'Load more failed');
    //         } else {
    //           AppSnackbar.error(title: 'Error', message: 'Failed to load more');
    //         }
    //       })
    //       .whenComplete(() {
    //         state.isContactDropdownLoadMoreLoading.value = false;
    //       });
    // } catch (e) {
    //   LoggerService.loggerInstance.e(e);
    //   state.isContactDropdownLoadMoreLoading.value = false;
    //   AppSnackbar.error(title: 'Error', message: 'Failed to load more');
    // }
  }

  void onRefreshClicked() {
    // state.isContactDropdownLoading.value = true;
    // state.isContactDropdownLoadMoreLoading.value = false;

    // try {
    //   final String endpoint =
    //       '/mobile/contacts?limit=25&page=1&stage=qualified';

    //   ContactApi.getEventList(endpoint)
    //       .then((MobileContactResponse response) {
    //         state.contacts.value = response.data.contacts;
    //         state.meta.value = response.data.pagination;
    //       })
    //       .onError((error, stackTrace) {
    //         if (error is DioException) {
    //           final statusCode = error.response?.statusCode;
    //           if (statusCode == 401) {
    //             UserStore.to.clearStore();
    //             Get.offAllNamed('/sign-in');
    //             return;
    //           }
    //           ApiErrorHandler.handleError(error, 'Refresh failed');
    //         } else {
    //           AppSnackbar.error(
    //             title: 'Refresh Error',
    //             message: 'Failed to refresh',
    //           );
    //         }
    //       })
    //       .whenComplete(() {
    //         state.isContactDropdownLoading.value = false;
    //       });
    // } catch (e) {
    //   LoggerService.loggerInstance.e(e);
    //   state.isContactDropdownLoading.value = false;
    //   AppSnackbar.error(title: 'Error', message: 'Failed to refresh');
    // }
  }
}

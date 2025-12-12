import 'package:dio/dio.dart';
import 'package:eventjar/api/thank_you_message_api/thank_you_message_api.dart';
import 'package:eventjar/controller/thank_you_message/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThankYouMessageController extends GetxController {
  var appBarTitle = "Send Thank you Message";
  final state = ThankYouMessageState();

  final formKey = GlobalKey<FormState>();

  //tq form
  final contactNameController = TextEditingController();
  final contactEmailController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void onInit() {
    final args = Get.arguments;
    state.contact.value = args;
    initThankYouData(state.contact.value!.name, state.contact.value!.email);
    super.onInit();
  }

  void initThankYouData(String name, String email) {
    contactNameController.text = name;
    contactEmailController.text = email;
    messageController.text =
        'Hi $name,\n\nThank you for connecting with us! We\'re excited to work together and will be in touch soon to discuss next steps.\n\nBest regards,\nYour Team';
  }

  Map<String, dynamic> _buildThankYouMessageData() {
    final now = DateTime.now();
    final methods = <String>[];

    if (state.emailChecked.value) methods.add('Email');
    if (state.whatsappChecked.value) methods.add('WhatsApp');

    final contact = state.contact.value!;

    return {
      'notes': contact.notes != null && contact.notes!.isNotEmpty
          ? '${contact.notes}\n\nThank you message sent via ${methods.join(' and ')} on ${now.toLocal().toString().split(' ')[0]}'
          : 'Thank you message sent via ${methods.join(' and ')} on ${now.toLocal().toString().split(' ')[0]}',

      'stage': 'followup_24h',
      'hasAnySentMessage': true,
      'messageSent': true,
      'lastMeetingDate': now.toIso8601String(),

      'customAttributes': {
        ...(contact.customAttributes ?? {}),
        'messageSentAt': now.toIso8601String(),
        'messageSentVia': methods.join(', '),
      },
    };
  }

  Future<void> sendThankYouMessage(BuildContext context) async {
    if (state.isLoading.value == true) return;
    try {
      state.isLoading.value = true;

      final data = _buildThankYouMessageData();

      final response = await ThankYouMessageApi.sendThankYouMessage(
        data: data,
        id: state.contact.value!.id,
      );
      if (response == true) {
        AppSnackbar.success(
          title: "Thank you message sent",
          message: "Contact Updated Successfully",
        );
      }

      Navigator.pop(context, true);
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }
        ApiErrorHandler.handleError(err, "Failed to Send Thankyou message");
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

  void resetForm() {
    state.emailChecked.value = true;
    state.whatsappChecked.value = false;
    messageController.clear();

    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    contactNameController.dispose();
    contactEmailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}

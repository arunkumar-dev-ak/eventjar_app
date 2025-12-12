import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eventjar/api/add_contact_api/add_contact_api.dart';
import 'package:eventjar/api/contact_api/contact_api.dart';
import 'package:eventjar/controller/qualify_lead/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QualifyLeadController extends GetxController {
  var appBarTitle = "Qualify Lead";
  final state = QualifyLeadState();

  final formKey = GlobalKey<FormState>();

  TextEditingController leadScoreController = TextEditingController();
  TextEditingController interestNeedsController = TextEditingController();
  TextEditingController decisionTimelineController = TextEditingController();
  TextEditingController qualificationNotesController = TextEditingController();

  @override
  void onInit() {
    final args = Get.arguments;
    state.contact.value = args;
    super.onInit();
  }

  // Validate lead score
  bool get isLeadScoreValid {
    if (leadScoreController.text.isEmpty) return false;
    final score = int.tryParse(leadScoreController.text);
    return score != null && score >= 0 && score <= 10;
  }

  // Qualify lead
  Future<void> qualifyLead(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final contact = state.contact.value;
    if (contact == null) return;

    state.isLoading.value = true;

    try {
      final currentUserId = UserStore.to.profile['id']; // adapt to your store
      final String contactId = contact.id;

      // Determine userKey (single / user1 / user2) like in Next.js
      // final bool isSharedContact =
      //     contact.user1Id != null && contact.user2Id != null;

      // String userKey;
      // if (isSharedContact) {
      //   if (contact.user1Id == currentUserId) {
      //     userKey = 'user1';
      //   } else {
      //     userKey = 'user2';
      //   }
      // } else {
      //   userKey = 'single';
      // }

      String userKey = 'single';

      // Build qualificationData similar to frontend QualificationData
      final qualificationData = {
        'userId': currentUserId,
        'leadScore': int.tryParse(leadScoreController.text),
        'interestNeeds': interestNeedsController.text.trim(),
        'decisionTimeline': decisionTimelineController.text.trim(),
        'qualificationNotes': qualificationNotesController.text.trim(),
        'qualifiedAt': DateTime.now().toIso8601String(),
      };

      final Map<String, dynamic> existingCustomAttributes =
          (contact.customAttributes ?? {});
      final updatedCustomAttributes = {
        ...existingCustomAttributes,
        'qualification_$userKey': jsonEncode(qualificationData),
      };
      final Map<String, dynamic> backendUpdates = {
        'customAttributes': updatedCustomAttributes,
        'stage': 'qualified',
        'meetingScheduled': false,
        'meetingConfirmed': false,
        'meetingCompleted': false,
      };

      await AddContactApi.updateContact(id: contactId, data: backendUpdates);

      AppSnackbar.success(
        title: "Lead Qualified",
        message: "Contact qualified successfully",
      );

      // Optionally close page and return data
      Navigator.pop(context, true);
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }
        ApiErrorHandler.handleError(err, "Failed to qualify lead");
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
    leadScoreController.clear();
    interestNeedsController.clear();
    decisionTimelineController.clear();
    qualificationNotesController.clear();

    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    leadScoreController.dispose();
    interestNeedsController.dispose();
    decisionTimelineController.dispose();
    qualificationNotesController.dispose();
    super.onClose();
  }
}

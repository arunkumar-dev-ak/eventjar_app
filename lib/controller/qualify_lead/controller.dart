import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eventjar/api/add_contact_api/add_contact_api.dart';
import 'package:eventjar/controller/qualify_lead/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QualifyLeadController extends GetxController {
  var appBarTitle = "Qualify Lead";
  final state = QualifyLeadState();

  final formKey = GlobalKey<FormState>();

  TextEditingController leadScoreController = TextEditingController();
  TextEditingController interestsController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  TextEditingController timelineController = TextEditingController();
  TextEditingController notesController = TextEditingController();

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

  bool get isSharedContact {
    final contact = state.contact.value;
    if (contact == null) return false;
    final hasSharedFields =
        !!(contact.user1Id?.isNotEmpty == true &&
            contact.user2Id?.isNotEmpty == true);
    final hasSharedTag = contact.tags.contains('shared_contact') == true;
    return hasSharedFields || hasSharedTag;
  }

  String get currentUserKey {
    final contact = state.contact.value;
    if (contact == null) return 'single';
    final currentUserId = UserStore.to.profile['id'];
    if (!isSharedContact) return 'single';
    return (contact.user1Id == currentUserId) ? 'user1' : 'user2';
  }

  Future<void> qualifyLead(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final contact = state.contact.value;
    if (contact == null) return;

    state.isLoading.value = true;

    try {
      final currentUserId = UserStore.to.profile['id'];
      final contactId = contact.id;

      // Match Next.js QualificationData exactly
      final qualificationData = {
        'score': int.tryParse(leadScoreController.text) ?? 5,
        'notes': notesController.text.trim(),
        'interests': interestsController.text.trim(),
        'budget': budgetController.text.trim(),
        'timeline': timelineController.text.trim(),
      };

      if (isSharedContact) {
        await AddContactApi.qualifyAndSplitContact(
          contactId: contactId,
          qualificationData: qualificationData,
        );
      } else {
        // Single user: direct update (matches web fallback)
        final existingCustomAttributes = Map<String, dynamic>.from(
          contact.customAttributes ?? {},
        );
        final updatedCustomAttributes = {
          ...existingCustomAttributes,
          'qualification_$currentUserKey': jsonEncode({
            ...qualificationData,
            'userId': currentUserId,
            'qualifiedAt': DateTime.now().toIso8601String(),
          }),
        };

        final updates = {
          'stage': 'qualified',
          'customAttributes': updatedCustomAttributes,
          'meetingCompleted': false,
          'meetingScheduled': false,
          'meetingConfirmed': false,
        };

        await AddContactApi.updateContact(
          id: contactId,
          data: updates,
          isFromQualify: true,
        );
      }

      AppSnackbar.success(
        title: "Lead Qualified",
        message: "Contact qualified successfully!",
      );
      Navigator.pop(context, true);
    } catch (err) {
      if (err is DioException) {
        if (err.response?.statusCode == 401) {
          UserStore.to.clearStore();
          Get.toNamed(RouteName.signInPage);
          return;
        }
        ApiErrorHandler.handleError(err, "Failed to qualify lead");
      } else {
        AppSnackbar.error(title: "Failed", message: "Something went wrong.");
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
    interestsController.clear();
    budgetController.clear();
    timelineController.clear();
    notesController.clear();
    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    leadScoreController.dispose();
    interestsController.dispose();
    budgetController.dispose();
    timelineController.dispose();
    notesController.dispose();
    super.onClose();
  }
}

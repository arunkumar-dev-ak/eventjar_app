import 'package:confetti/confetti.dart';
import 'package:dio/dio.dart';
import 'package:eventjar/api/contact_api/contact_api.dart';
import 'package:eventjar/controller/contact/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/contact_analytics_model.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  var appBarTitle = "Contact Page";
  final state = ContactState();
  late ConfettiController confettiController;

  @override
  void onInit() async {
    final args = Get.arguments;
    if (args != null && args is Map) {
      final statusCard = args['statusCard'] as NetworkStatusCardData?;
      final analytics = args['analytics'] as ContactAnalytics?;

      if (statusCard != null) {
        state.selectedTab.value = statusCard;
      }
      if (analytics != null) {
        state.analytics.value = analytics;
      }
    }

    confettiController = ConfettiController(duration: Duration(seconds: 3));
    // triggerConfetti();

    await fetchContacts();

    super.onInit();
  }

  Future<void> fetchContacts() async {
    try {
      final stageKey = state.selectedTab.value!.key;

      state.isLoading.value = true;

      ContactResponse response = await ContactApi.getEventList('/contacts');

      final List<Contact> filteredContacts;

      if (stageKey == "total") {
        // No filter for total contacts
        filteredContacts = response.contacts;
      } else if (stageKey == "overdue") {
        // Filter by isOverdue flag true
        filteredContacts = response.contacts
            .where((contact) => contact.isOverdue == true)
            .toList();
      } else {
        // Map stageKey string to ContactStage enum value
        ContactStage? stageFilter;

        switch (stageKey) {
          case "new":
            stageFilter = ContactStage.newContact;
            break;
          case "followup_24h":
            stageFilter = ContactStage.followup24h;
            break;
          case "followup_7d":
            stageFilter = ContactStage.followup7d;
            break;
          case "followup_30d":
            stageFilter = ContactStage.followup30d;
            break;
          case "qualified":
            stageFilter = ContactStage.qualified;
            break;
          default:
            stageFilter = null;
        }

        if (stageFilter != null) {
          filteredContacts = response.contacts
              .where((contact) => contact.stage == stageFilter)
              .toList();
        } else {
          // Fallback to empty list or all contacts if unknown stageKey
          filteredContacts = [];
        }
      }

      state.contacts.value = filteredContacts;
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to load Contacts");
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

  Future<void> deleteContactCard(String id) async {
    try {
      state.isLoading.value = true;

      await ContactApi.deleteContact(id);

      await fetchContacts();
    } catch (err) {
      LoggerService.loggerInstance.dynamic_d(err);
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          // Auth error handling example
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to add contact");
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

  void toggleFilterRow() {
    state.showFilterRow.value = !state.showFilterRow.value;
  }

  void triggerConfetti() {
    // showConfetti.value = true;
    confettiController.play();

    Future.delayed(Duration(seconds: 3), () {
      // showConfetti.value = false;
    });
  }

  /*----- Navigation -----*/
  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage)?.then((result) async {
      if (result == "logged_in") {
        await fetchContacts();
      } else {
        Get.back();
      }
    });
  }

  void navigateToAddContact() {
    Get.toNamed(RouteName.addContactPage)?.then(
      (result) async => {
        if (result == 'refresh') {await fetchContacts()},
      },
    );
  }

  void navigateToUpdateContact(Contact contact) {
    Get.toNamed(RouteName.addContactPage, arguments: {contact})?.then(
      (result) async => {
        if (result == 'refresh') {await fetchContacts()},
      },
    );
  }

  void navigateToThankyouMessage(Contact contact) {
    Get.toNamed(RouteName.thankYouMessagePage, arguments: contact)?.then((
      result,
    ) async {
      if (result == true) {
        await fetchContacts();
      }
    });
  }

  void navigateToScheduleMeeting(Contact contact) {
    Get.toNamed(RouteName.scheduleMeetingPage, arguments: contact)?.then((
      result,
    ) async {
      if (result == true) {
        await fetchContacts();
      }
    });
  }

  void navigateToQualifyLead(Contact contact) {
    Get.toNamed(RouteName.qualifyLeadPage, arguments: contact)?.then((
      result,
    ) async {
      if (result == true) {
        await fetchContacts();
      }
    });
  }
}

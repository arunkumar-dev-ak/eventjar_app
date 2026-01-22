import 'package:eventjar/controller/add_contact/binding.dart';
import 'package:eventjar/controller/checkout/binding.dart';
import 'package:eventjar/controller/connection/binding.dart';
import 'package:eventjar/controller/contact/binding.dart';
import 'package:eventjar/controller/dashboard/binding.dart';
import 'package:eventjar/controller/event_info/binding.dart';
import 'package:eventjar/controller/forgotPassword/binding.dart';
import 'package:eventjar/controller/nfc/binding.dart';
import 'package:eventjar/controller/nfc_read/binding.dart';
import 'package:eventjar/controller/nfc_write/binding.dart';
import 'package:eventjar/controller/profile_form/basic_info/binding.dart';
import 'package:eventjar/controller/profile_form/business_info/binding.dart';
import 'package:eventjar/controller/profile_form/location/binding.dart';
import 'package:eventjar/controller/profile_form/networking/binding.dart';
import 'package:eventjar/controller/profile_form/social/binding.dart';
import 'package:eventjar/controller/profile_form/summary/binding.dart';
import 'package:eventjar/controller/qr_dashboard/binding.dart';
import 'package:eventjar/controller/qualify_lead/binding.dart';
import 'package:eventjar/controller/reminder/binding.dart';
import 'package:eventjar/controller/schedule_meeting/binding.dart';
import 'package:eventjar/controller/scheduler/binding.dart';
import 'package:eventjar/controller/signIn/binding.dart';
import 'package:eventjar/controller/signUp/binding.dart';
import 'package:eventjar/controller/splashScreen/binding.dart';
import 'package:eventjar/controller/thank_you_message/binding.dart';
import 'package:eventjar/page/add_contact/add_contact.dart';
import 'package:eventjar/page/checkout/checkout_page.dart';
import 'package:eventjar/page/connection/connection_page.dart';
import 'package:eventjar/page/contact/contact_page.dart';
import 'package:eventjar/page/dashboard/dashboard_page.dart';
import 'package:eventjar/page/event_info/event_info.dart';
import 'package:eventjar/page/forgot_password/forgot_password.dart';
import 'package:eventjar/page/nfc/nfc_page.dart';
import 'package:eventjar/page/nfc_read/nfc_read.dart';
import 'package:eventjar/page/nfc_write/nfc_write.dart';
import 'package:eventjar/page/profile_form/basic_info/basic_info.dart';
import 'package:eventjar/page/profile_form/business_info/business_info.dart';
import 'package:eventjar/page/profile_form/location_form/location_form.dart';
import 'package:eventjar/page/profile_form/networking_form/networking_form.dart';
import 'package:eventjar/page/profile_form/social_form/social_form.dart';
import 'package:eventjar/page/profile_form/summary_form/summary_form.dart';
import 'package:eventjar/page/qr_dashboard/qr_dashboard.dart';
import 'package:eventjar/page/qualify_lead/qualify_lead.dart';
import 'package:eventjar/page/reminder/reminder_page.dart';
import 'package:eventjar/page/schedule_meeting/schedule_meeting.dart';
import 'package:eventjar/page/scheduler/scheduler_page.dart';
import 'package:eventjar/page/sign_in/sign_in_page.dart';
import 'package:eventjar/page/sign_up/sign_up_page.dart';
import 'package:eventjar/page/splash_screen/splash_screen_page.dart';
import 'package:eventjar/page/thank_you_message/thank_you_message.dart';
import 'package:eventjar/routes/route_auth.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:get/get.dart';

import '../controller/scan_card/binding.dart';
import '../page/scan_card/scan_card.dart';

class RoutePage {
  List<GetPage> getPage = [
    /*----- Auth page -----*/
    //splash screen
    GetPage(
      name: RouteName.splashScreen,
      page: () => SplashScreenPage(),
      binding: SplashScreenBinding(),
    ),
    //signIn
    GetPage(
      name: RouteName.signInPage,
      page: () => SignInPage(),
      binding: SignInBinding(),
    ),
    //signUp
    GetPage(
      name: RouteName.signUpPage,
      page: () => SignUpPage(),
      binding: SignUpBinding(),
    ),
    //Forgot password
    GetPage(
      name: RouteName.forgotPasswordPage,
      page: () => ForgotPasswordPage(),
      binding: ForgotPasswordBinding(),
    ),

    /*----- Dashoard page -----*/
    GetPage(
      name: RouteName.dashboardpage,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
      // transition: Transition.downToUp,
      // transitionDuration: Duration(milliseconds: 1500),
    ),

    /*------ NetworkPage ------*/
    GetPage(
      name: RouteName.connectionPage,
      page: () => ConnectionPage(),
      binding: ConnectionBinding(),
    ),
    GetPage(
      name: RouteName.scheduleMeetingPage,
      page: () => SchedulerPage(),
      binding: SchedulerBinding(),
    ),
    GetPage(
      name: RouteName.reminderPage,
      page: () => ReminderPage(),
      binding: ReminderBinding(),
    ),

    /*----- EventInfo page -----*/
    GetPage(
      name: RouteName.eventInfoPage,
      page: () => EventInfoPage(),
      binding: EventInfoBinding(),
    ),

    /*----- Checkout page -----*/
    GetPage(
      name: RouteName.checkoutPage,
      page: () => CheckoutPage(),
      binding: CheckoutBinding(),
      middlewares: [LoginMiddleware()],
    ),

    /*----- Contact page -----*/
    GetPage(
      name: RouteName.contactPage,
      page: () => ContactPage(),
      binding: ContactBinding(),
      middlewares: [LoginMiddleware()],
    ),
    //add
    GetPage(
      name: RouteName.addContactPage,
      page: () => AddContactPage(),
      binding: AddContactBinding(),
      middlewares: [LoginMiddleware()],
    ),

    /*----- QR code page -----*/
    GetPage(
      name: RouteName.qrDashboardPage,
      page: () => QrCodePage(),
      binding: QrDashboardBinding(),
      middlewares: [LoginMiddleware()],
    ),

    /*----- Scan card page -----*/
    GetPage(
      name: RouteName.scanCardPage,
      page: () => ScanCard(),
      binding: ScanCardBinding(),
      middlewares: [LoginMiddleware()],
    ),

    /*----- Nfc page -----*/
    GetPage(
      name: RouteName.nfcPage,
      page: () => NfcPage(),
      binding: NfcBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: RouteName.nfcReadPage,
      page: () => NfcReadPage(),
      binding: NfcReadBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: RouteName.nfcWritePage,
      page: () => NfcWritePage(),
      binding: NfcWriteBinding(),
      middlewares: [LoginMiddleware()],
    ),

    /*----- Stage form page -----*/
    GetPage(
      name: RouteName.thankYouMessagePage,
      page: () => ThankYouMessagePage(),
      binding: ThankYouMessageBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: RouteName.scheduleMeetingPage,
      page: () => ScheduleMeetingPage(),
      binding: ScheduleMeetingBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: RouteName.qualifyLeadPage,
      page: () => QualifyLeadPage(),
      binding: QualifyLeadBinding(),
      middlewares: [LoginMiddleware()],
    ),

    /*------ Profile update -----*/
    GetPage(
      name: RouteName.basicInfoFormPage,
      page: () => BasicInfoPage(),
      binding: BasicInfoBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: RouteName.businessInfoFormPage,
      page: () => BusinessInfoPage(),
      binding: BusinessInfoBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: RouteName.locationFormPage,
      page: () => LocationFormPage(),
      binding: LocationBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: RouteName.networkingFormPage,
      page: () => NetworkingFormPage(),
      binding: NetworkingBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: RouteName.summaryFormPage,
      page: () => SummaryFormPage(),
      binding: SummaryBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: RouteName.socialFormPage,
      page: () => SocialFormPage(),
      binding: SocialBinding(),
      middlewares: [LoginMiddleware()],
    ),
  ];
}

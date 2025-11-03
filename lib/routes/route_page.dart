import 'package:eventjar_app/controller/checkout/binding.dart';
import 'package:eventjar_app/controller/dashboard/binding.dart';
import 'package:eventjar_app/controller/event_info/binding.dart';
import 'package:eventjar_app/controller/forgotPassword/binding.dart';
import 'package:eventjar_app/controller/my_ticket/binding.dart';
import 'package:eventjar_app/controller/signIn/binding.dart';
import 'package:eventjar_app/controller/signUp/binding.dart';
import 'package:eventjar_app/controller/splashScreen/binding.dart';
import 'package:eventjar_app/page/checkout/checkout_page.dart';
import 'package:eventjar_app/page/dashboard/dashboard_page.dart';
import 'package:eventjar_app/page/event_info/event_info.dart';
import 'package:eventjar_app/page/forgot_password/forgot_password.dart';
import 'package:eventjar_app/page/my_ticket/my_ticket_page.dart';
import 'package:eventjar_app/page/sign_in/sign_in_page.dart';
import 'package:eventjar_app/page/sign_up/sign_up_page.dart';
import 'package:eventjar_app/page/splash_screen/splash_screen_page.dart';
import 'package:eventjar_app/routes/route_auth.dart';
import 'package:eventjar_app/routes/route_name.dart';
import 'package:get/get.dart';

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

    /*----- Ticket List page -----*/
    GetPage(
      name: RouteName.myTicketPage,
      page: () => MyTicketPage(),
      binding: MyTicketBinding(),
      middlewares: [LoginMiddleware()],
    ),
  ];
}

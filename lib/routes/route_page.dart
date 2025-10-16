import 'package:eventjar_app/controller/forgotPassword/binding.dart';
import 'package:eventjar_app/controller/home/binding.dart';
import 'package:eventjar_app/controller/signIn/binding.dart';
import 'package:eventjar_app/controller/signUp/binding.dart';
import 'package:eventjar_app/controller/splashScreen/binding.dart';
import 'package:eventjar_app/page/forgot_password/forgot_password.dart';
import 'package:eventjar_app/page/home/home.dart';
import 'package:eventjar_app/page/sign_in/sign_in_page.dart';
import 'package:eventjar_app/page/sign_up/sign_up_page.dart';
import 'package:eventjar_app/page/splash_screen/splash_screen_page.dart';
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

    /*----- Home page -----*/
    GetPage(
      name: RouteName.homePage,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
  ];
}

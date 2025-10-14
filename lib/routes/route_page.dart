import 'package:eventjar_app/controller/signIn/binding.dart';
import 'package:eventjar_app/controller/signUp/binding.dart';
import 'package:eventjar_app/page/sign_in/sign_in_page.dart';
import 'package:eventjar_app/page/sign_up/sign_up_page.dart';
import 'package:eventjar_app/routes/route_name.dart';
import 'package:get/get.dart';

class RoutePage {
  List<GetPage> getPage = [
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
  ];
}

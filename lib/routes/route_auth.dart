import 'package:eventjar_app/global/store/user_store.dart';
import 'package:eventjar_app/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (UserStore.to.isLogin || route == RouteName.signInPage) {
      return null;
    } else {
      return const RouteSettings(name: RouteName.signInPage);
    }
  }
}

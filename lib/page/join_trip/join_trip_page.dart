import 'package:eventjar/controller/join_trip/controller.dart';
import 'package:eventjar/controller/join_trip/state.dart';
import 'package:eventjar/page/join_trip/widget/join_trip_error.dart';
import 'package:eventjar/page/join_trip/widget/join_trip_loading.dart';
import 'package:eventjar/page/join_trip/widget/join_trip_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class JoinTripPage extends GetView<JoinTripController> {
  const JoinTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: Theme.of(context).brightness,
      ),
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.transparent,
        body: Obx(() {
          switch (controller.state.status.value) {
            case JoinTripStatus.loading:
              return const JoinTripLoading();
            case JoinTripStatus.success:
            case JoinTripStatus.alreadyMember:
              return const JoinTripSuccess();
            case JoinTripStatus.error:
              return const JoinTripError();
          }
        }),
      ),
    );
  }
}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:eventjar/api/join_trip_api/join_trip_api.dart';
import 'package:eventjar/controller/join_trip/state.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/budget_track/trip_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:get/get.dart';

class JoinTripController extends GetxController {
  final state = JoinTripState();

  late String _joinToken;

  Timer? _textTimer;

  final List<String> _loadingTexts = [
    'joining_trip',
    'setting_things_up',
    'almost_there',
  ];
  int _textIndex = 0;

  @override
  void onInit() {
    super.onInit();
    _handleArgs();
    _startTextAnimation();
    _processJoin();
  }

  void _handleArgs() {
    final args = Get.arguments;
    _joinToken = args?['joinToken'] ?? '';
  }

  void _startTextAnimation() {
    _textTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _textIndex = (_textIndex + 1) % _loadingTexts.length;
      state.loadingText.value = _loadingTexts[_textIndex];
    });
  }

  Future<void> _processJoin() async {
    if (_joinToken.isEmpty) {
      state.status.value = JoinTripStatus.error;
      state.errorMessage.value = 'invalid_join_link';
      return;
    }

    try {
      final response = await JoinTripApi.joinTrip(joinToken: _joinToken);

      state.tripData.value = response;

      if (response.isAlreadyMember) {
        state.status.value = JoinTripStatus.alreadyMember;
      } else {
        state.status.value = JoinTripStatus.success;
      }

      _textTimer?.cancel();

      Future.delayed(const Duration(seconds: 3), () {
        _navigateToTrip(response.id);
      });
    } on DioException catch (e) {
      _textTimer?.cancel();

      final statusCode = e.response?.statusCode;
      if (statusCode == 404) {
        state.errorMessage.value = 'invalid_or_expired_join_link';
      } else if (statusCode == 401) {
        state.errorMessage.value = 'login_required_to_join';
      } else {
        state.errorMessage.value = 'failed_to_join_trip';
      }
      state.status.value = JoinTripStatus.error;
    } catch (e) {
      _textTimer?.cancel();
      LoggerService.loggerInstance.e('Join trip error: $e');
      state.errorMessage.value = 'failed_to_join_trip';
      state.status.value = JoinTripStatus.error;
    }
  }

  void _navigateToTrip(String tripId) {
    final tripData = state.tripData.value;
    if (tripData == null) return;

    final tripModel = TripModel(
      id: tripData.id,
      createdById: tripData.createdBy?.id ?? '',
      name: tripData.name,
      destination: tripData.destination,
      status: tripData.status,
      totalBudget: 0,
      currency: tripData.currency,
      joinToken: '',
      createdAt: tripData.startDate,
      updatedAt: tripData.endDate,
      membersCount: tripData.memberCount,
      expensesCount: 0,
      myShare: 0,
      teamShare: 0,
      myOwe: 0,
      myReceive: 0,
      myOweMembersCount: 0,
    );

    Get.offNamed(
      RouteName.viewTripPage,
      arguments: tripModel,
    );
  }

  void navigateToViewTrip() {
    final tripData = state.tripData.value;
    if (tripData != null) {
      _navigateToTrip(tripData.id);
    }
  }

  void goBack() {
    Get.offAllNamed(RouteName.dashboardpage);
  }

  @override
  void onClose() {
    _textTimer?.cancel();
    super.onClose();
  }
}

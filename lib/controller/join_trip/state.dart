import 'package:eventjar/model/budget_track/join_trip_model.dart';
import 'package:get/get.dart';

enum JoinTripStatus { loading, success, alreadyMember, error }

class JoinTripState {
  final Rx<JoinTripStatus> status = JoinTripStatus.loading.obs;

  final Rxn<JoinTripResponse> tripData = Rxn<JoinTripResponse>();

  final RxString errorMessage = ''.obs;

  final RxString loadingText = 'joining_trip'.obs;
}

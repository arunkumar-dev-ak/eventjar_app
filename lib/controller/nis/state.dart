import 'package:get/get.dart';

class NisState {
  final RxBool isLoading = false.obs;
  final RxInt overallScore = 0.obs;
  final RxInt networkSize = 0.obs;
  final RxInt networkQuality = 0.obs;
  final RxInt engagementLevel = 0.obs;
  final RxInt influenceVisibility = 0.obs;
  final RxInt relationshipIntelligence = 0.obs;
  final RxInt topPercentile = 0.obs;
  final RxInt totalProfessionals = 0.obs;
  final RxString rating = ''.obs;
}

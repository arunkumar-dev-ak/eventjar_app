import 'package:eventjar/controller/nis/state.dart';
import 'package:get/get.dart';

class NisController extends GetxController {
  final state = NisState();

  int get overallScore => state.overallScore.value;
  int get networkSize => state.networkSize.value;
  int get networkQuality => state.networkQuality.value;
  int get engagementLevel => state.engagementLevel.value;
  int get influenceVisibility => state.influenceVisibility.value;
  int get relationshipIntelligence => state.relationshipIntelligence.value;
  int get topPercentile => state.topPercentile.value;
  int get totalProfessionals => state.totalProfessionals.value;
  String get rating => state.rating.value;
  bool get isLoading => state.isLoading.value;

  String get ratingLabel {
    final score = overallScore;
    if (score >= 90) return 'outstanding'.tr;
    if (score >= 80) return 'excellent'.tr;
    if (score >= 70) return 'very_good'.tr;
    if (score >= 60) return 'good'.tr;
    if (score >= 50) return 'average'.tr;
    return 'needs_improvement'.tr;
  }

  @override
  void onInit() {
    super.onInit();
    fetchNisData();
  }

  Future<void> fetchNisData() async {
    state.isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      state.overallScore.value = 40;
      state.networkSize.value = 85;
      state.networkQuality.value = 80;
      state.engagementLevel.value = 78;
      state.influenceVisibility.value = 82;
      state.relationshipIntelligence.value = 88;
      state.topPercentile.value = 18;
      state.totalProfessionals.value = 2842;
      state.rating.value = ratingLabel;
    } finally {
      state.isLoading.value = false;
    }
  }
}

import 'package:eventjar/controller/nis_insights/state.dart';
import 'package:get/get.dart';

class NisInsightsController extends GetxController {
  final state = NisInsightsState();

  bool get isLoading => state.isLoading.value;
  String get selectedPeriod => state.selectedPeriod.value;
  List<NisScorePoint> get scoreHistory => state.scoreHistory;
  List<HelpingFactor> get helpingFactors => state.helpingFactors;
  List<ImprovementArea> get areasToImprove => state.areasToImprove;

  final periods = ['last_3_months', 'last_6_months', 'last_12_months'];

  void changePeriod(String period) {
    state.selectedPeriod.value = period;
    fetchInsights();
  }

  @override
  void onInit() {
    super.onInit();
    fetchInsights();
  }

  Future<void> fetchInsights() async {
    state.isLoading.value = true;
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      state.scoreHistory.value = [
        NisScorePoint(month: 'Dec', score: 56),
        NisScorePoint(month: 'Jan', score: 62),
        NisScorePoint(month: 'Feb', score: 68),
        NisScorePoint(month: 'Mar', score: 72),
        NisScorePoint(month: 'Apr', score: 78),
        NisScorePoint(month: 'May', score: 82),
      ];

      state.helpingFactors.value = [
        HelpingFactor(
          text: 'you_attended_events'.trParams({'count': '12'}),
          iconType: 'events',
        ),
        HelpingFactor(
          text: 'you_connected_with_people'.trParams({'count': '28'}),
          iconType: 'connections',
        ),
        HelpingFactor(
          text: 'you_have_followups'.trParams({'percent': '85'}),
          iconType: 'followups',
        ),
      ];

      state.areasToImprove.value = [
        ImprovementArea(text: 'engage_more_with_network'.tr),
        ImprovementArea(text: 'share_knowledge_and_value'.tr),
      ];
    } finally {
      state.isLoading.value = false;
    }
  }
}

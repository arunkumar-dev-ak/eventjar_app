import 'package:get/get.dart';

class NisInsightsState {
  final RxBool isLoading = false.obs;
  final RxString selectedPeriod = 'last_6_months'.obs;
  final RxList<NisScorePoint> scoreHistory = <NisScorePoint>[].obs;
  final RxList<HelpingFactor> helpingFactors = <HelpingFactor>[].obs;
  final RxList<ImprovementArea> areasToImprove = <ImprovementArea>[].obs;
}

class NisScorePoint {
  final String month;
  final int score;

  NisScorePoint({required this.month, required this.score});
}

class HelpingFactor {
  final String text;
  final String iconType;

  HelpingFactor({required this.text, required this.iconType});
}

class ImprovementArea {
  final String text;

  ImprovementArea({required this.text});
}

import 'package:eventjar/model/budget_track/trip_model.dart';
import 'package:eventjar/model/meta/mobile_meta_model.dart';
import 'package:get/get.dart';

class BudgetTrackState {
  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;

  RxList<TripModel> trips = <TripModel>[].obs;

  Rxn<MobileMeta> meta = Rxn<MobileMeta>();

  RxMap<int, bool> expandedNotes = <int, bool>{}.obs;
}

import 'package:eventjar/model/home/home_model.dart';
import 'package:eventjar/model/meta/meta_model.dart';
import 'package:get/get.dart';

class CategoriesEventState {
  final RxBool isLoading = false.obs;
  final RxBool isFetching = false.obs;

  final RxList<Event> events = <Event>[].obs;
  final Rxn<Meta> meta = Rxn<Meta>();

  final RxInt selectedTab = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;
  final Rxn<DateTime> filterFrom = Rxn<DateTime>();
  final Rxn<DateTime> filterTo = Rxn<DateTime>();
  final RxList<EventCategory> eventcategory = <EventCategory>[].obs;
}

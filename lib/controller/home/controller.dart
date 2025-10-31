import 'package:eventjar_app/api/home_api/home_api.dart';
import 'package:eventjar_app/controller/home/state.dart';
import 'package:eventjar_app/global/palette_generator.dart';
import 'package:eventjar_app/logger_service.dart';
import 'package:eventjar_app/model/home/home_model.dart';
import 'package:eventjar_app/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var appBarTitle = "EventJar";
  final state = HomeState();
  final formKey = GlobalKey<FormState>();
  final logoPath = 'assets/app_icon/event_app_icon.png';
  ScrollController scrollController = ScrollController();
  final int _currentPage = 1;
  final int _limit = 10;

  bool get isLoading => state.isLoading.value;

  final _searchBarController = TextEditingController().obs;

  TextEditingController get searchBarController => _searchBarController.value;

  @override
  void onInit() async {
    state.isLoading.value = true;
    super.onInit();

    await fetchEvents();
    scrollController.addListener(_onScroll);
    state.isLoading.value = false;

    super.onInit();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    const double prefetchThreshold = 200.0;

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;

    if (maxScroll - currentScroll <= prefetchThreshold) {
      // Only fetch when metadata exists and not already fetching
      if (state.meta.value != null &&
          state.meta.value!.hasNext == true &&
          !state.isFetching.value) {
        fetchEventsOnScroll();
      }
    }
  }

  void handleSearchOnChnage(String text) {
    if (text.isEmpty) {
      state.isSearchEmpty.value = true;
    } else {
      state.isSearchEmpty.value = false;
    }
  }

  Future<void> extractColors(String url) async {
    state.dominantColors.clear();
    try {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
            NetworkImage(url),
            maximumColorCount: 5,
          );
      state.dominantColors.add(
        paletteGenerator.dominantColor?.color ?? Colors.grey[300]!,
      );
    } catch (e) {
      state.dominantColors.add(Colors.grey[300]!);
    }
  }

  void navigateToEventInfoPage(Event event) {
    Get.toNamed(RouteName.eventInfoPage, parameters: {'eventId': event.id});
  }

  String getEndpoint() {
    if (state.meta.value == null) {
      return '/events?page=$_currentPage&limit=$_limit';
    }

    final meta = state.meta.value!;
    int nextPage = (meta.page) + 1;

    int nextLimit = meta.limit;

    if (nextPage > meta.totalPages) {
      nextPage = meta.totalPages;
    }

    return '/events?page=$nextPage&limit=$nextLimit';
  }

  Future<void> fetchEvents() async {
    try {
      state.isLoading.value = true;
      EventResponse response = await HomeApi.getEventList(
        '/events?page=$_currentPage&limit=$_limit',
      );
      state.events.value = response.data;
      state.meta.value = response.meta;
    } catch (e) {
      LoggerService.loggerInstance.e('Failed to load events: $e');
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> fetchEventsOnScroll() async {
    try {
      state.isFetching.value = true;
      EventResponse response = await HomeApi.getEventList(getEndpoint());
      state.events.addAll(response.data);
      state.meta.value = response.meta;
    } catch (e) {
      LoggerService.loggerInstance.e('Failed to load events: $e');
    } finally {
      state.isFetching.value = false;
    }
  }
}

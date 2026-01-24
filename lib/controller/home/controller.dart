import 'package:eventjar/api/home_api/home_api.dart';
import 'package:eventjar/controller/home/state.dart';
import 'package:eventjar/global/palette_generator.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/date_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/home/home_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  var appBarTitle = "EventJar";
  final state = HomeState();
  final formKey = GlobalKey<FormState>();
  final logoPath = 'assets/app_icon/event_app_icon.png';
  ScrollController homeScrollController = ScrollController();
  final int _currentPage = 1;
  final int _limit = 10;

  bool get isLoading => state.isLoading.value;

  final _searchBarController = TextEditingController().obs;

  TextEditingController get searchBarController => _searchBarController.value;

  @override
  void onInit() {
    super.onInit();
    homeScrollController.addListener(_onScroll);
    onTabOpen();
  }

  // void debugScrollPositions() {
  //   final positions = homeScrollController.positions;
  //   print('🔍 ScrollController Positions (${positions.length}):');

  //   for (int i = 0; i < positions.length; i++) {
  //     final position = positions.elementAt(i);
  //     print('  📍 Position $i:');
  //     print('    - context: ${position.context}');
  //     print('    - minScrollExtent: ${position.minScrollExtent}');
  //     print('    - maxScrollExtent: ${position.maxScrollExtent}');
  //     print('    - pixels: ${position.pixels}');
  //     print('    - viewportDimension: ${position.viewportDimension}');
  //     print('    - widget type: ${position.context.runtimeType}');
  //   }

  //   if (positions.isEmpty) {
  //     print('  ❌ NO ScrollPositions attached!');
  //   }
  // }

  void onTabOpen() {
    state.isLoading.value = true;
    fetchEvents();
  }

  void _onScroll() {
    if (!homeScrollController.hasClients) return;

    final maxScroll = homeScrollController.position.maxScrollExtent;
    final currentScroll = homeScrollController.position.pixels;

    const double prefetchThreshold = 200.0;
    if (maxScroll - currentScroll <= prefetchThreshold) {
      if (state.meta.value != null &&
          state.meta.value!.hasNext == true &&
          !state.isFetching.value) {
        LoggerService.loggerInstance.dynamic_d("triggering");
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

  /*----- utis -----*/
  String? getUserImageUrl() {
    try {
      final profile = UserStore.to.profile;

      // Check for common image field names
      if (profile.containsKey('avatarUrl') && profile['avatarUrl'] != null) {
        return profile['avatarUrl'].toString();
      }

      return null;
    } catch (e) {
      LoggerService.loggerInstance.e('Error getting user image: $e');
      return null;
    }
  }

  // Returns user initials
  String getUserInitials() {
    try {
      final profile = UserStore.to.profile;

      if (profile.containsKey('name') && profile['name'] != null) {
        List<String> nameParts = profile['name'].split(' ');
        if (nameParts.length > 1) {
          return '${nameParts[0][0].toUpperCase()}${nameParts[1][0].toUpperCase()}';
        }
        return profile['name'].length > 1
            ? profile['name'].substring(0, 2).toUpperCase()
            : profile['name'][0].toUpperCase();
      }

      return 'EJ'; // EventJar
    } catch (e) {
      LoggerService.loggerInstance.e('Error getting user initials: $e');
      return 'EJ';
    }
  }

  String formatEventDateTimeForHome(dynamic event, BuildContext context) {
    try {
      DateTime dateTime;

      // Case 1: ISO string (2024-01-25T06:00:00Z)
      if (event.startTime.contains('T') || event.startTime.contains('Z')) {
        dateTime = DateTime.parse(event.startTime).toLocal();
      }
      // Case 2: HH:mm (06:00)
      else {
        final date = event.startDate as DateTime;
        final parts = event.startTime.split(':');

        dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        ).toLocal();
      }

      // 📅 Jan 25, 2024
      final formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);

      // ⏰ Uses your helper → respects 12/24h
      final formattedTime = formatTimeFromDateTime(dateTime, context);

      return '$formattedDate • $formattedTime';
    } catch (e) {
      LoggerService.loggerInstance.e('Date parse error: $e');
      return 'Invalid date';
    }
  }

  void navigateToAddContact() {
    Get.toNamed(RouteName.addContactPage);
  }

  void navigateToNfc() {
    Get.toNamed(RouteName.nfcPage);
  }

  void navigateToQrPage() {
    Get.toNamed(RouteName.qrDashboardPage);
  }

  void navigateToScanPage() {
    Get.toNamed(RouteName.scanCardPage);
  }

  @override
  void onClose() {
    homeScrollController.removeListener(_onScroll);
    homeScrollController.dispose();
    super.onClose();
  }
}

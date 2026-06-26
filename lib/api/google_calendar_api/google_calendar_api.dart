import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/model/google_calendar/google_calendar_connect_model.dart';
import 'package:eventjar/model/google_calendar/google_calendar_status_model.dart';
import 'package:eventjar/model/meeting_preferences/meeting_preferences_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:get/get.dart';

class GoogleCalendarApi {
  static final Dio _dio = DioClient().dio;

  static Future<GoogleCalendarStatusModel> getConnectionStatus() async {
    try {
      final response = await _dio.get('/google-calendar/status');

      if (response.statusCode == 200) {
        return GoogleCalendarStatusModel.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "something_went_wrong".tr,
      );
    } catch (err) {
      rethrow;
    }
  }

  static Future<GoogleCalendarConnectModel> getConnectUrl() async {
    try {
      final response = await _dio.get(
        '/google-calendar/connect',
        options: Options(headers: {'x-platform': 'mobile'}),
      );

      if (response.statusCode == 200) {
        return GoogleCalendarConnectModel.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "something_went_wrong".tr,
      );
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        await UserStore.to.clearStore();

        Get.toNamed(RouteName.signInPage);
      }

      rethrow;
    } catch (err) {
      rethrow;
    }
  }

  static Future<MeetingPreferencesResponse> getMeetingPreferences() async {
    try {
      final response = await _dio.get('/google-calendar/meeting-preferences');

      if (response.statusCode == 200) {
        return MeetingPreferencesResponse.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "something_went_wrong".tr,
      );
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        await UserStore.to.clearStore();
        Get.toNamed(RouteName.signInPage);
      }
      rethrow;
    } catch (err) {
      rethrow;
    }
  }

  static Future<bool> updateMeetingPreferences(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put(
        '/google-calendar/meeting-preferences',
        data: data,
      );
      return (response.statusCode == 200 || response.statusCode == 201);
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        await UserStore.to.clearStore();
        Get.toNamed(RouteName.signInPage);
      }
      rethrow;
    } catch (err) {
      rethrow;
    }
  }

  static Future<List<HolidayCountry>> getHolidayCountries() async {
    try {
      final response = await _dio.get('/google-calendar/holidays/countries');
      if (response.statusCode == 200) {
        return (response.data as List<dynamic>)
            .map((e) => HolidayCountry.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "something_went_wrong".tr,
      );
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        await UserStore.to.clearStore();
        Get.toNamed(RouteName.signInPage);
      }
      rethrow;
    } catch (err) {
      rethrow;
    }
  }

  static Future<List<Holiday>> getHolidays(String country, int year) async {
    try {
      final response = await _dio.get(
        '/google-calendar/holidays',
        queryParameters: {'country': country, 'year': year},
      );
      if (response.statusCode == 200) {
        return (response.data as List<dynamic>)
            .map((e) => Holiday.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "something_went_wrong".tr,
      );
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        await UserStore.to.clearStore();
        Get.toNamed(RouteName.signInPage);
      }
      rethrow;
    } catch (err) {
      rethrow;
    }
  }

  static Future<MeetingPreferencesResponse> getTargetUserPreferences(
    String userId,
  ) async {
    try {
      final response = await _dio.get(
        '/google-calendar/meeting-preferences/$userId',
      );
      if (response.statusCode == 200) {
        return MeetingPreferencesResponse.fromJson(response.data);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "something_went_wrong".tr,
      );
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        await UserStore.to.clearStore();
        Get.toNamed(RouteName.signInPage);
      }
      rethrow;
    } catch (err) {
      rethrow;
    }
  }

  static Future<List<FreeBusySlot>> getMyAvailability(
    String timeMin,
    String timeMax,
  ) async {
    try {
      final response = await _dio.post(
        '/google-calendar/my-availability',
        data: {'time_min': timeMin, 'time_max': timeMax},
      );
      if (response.statusCode == 200) {
        final busySlots = response.data['busySlots'] as List<dynamic>? ?? [];
        return busySlots
            .map((e) => FreeBusySlot.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "something_went_wrong".tr,
      );
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        await UserStore.to.clearStore();
        Get.toNamed(RouteName.signInPage);
      }
      rethrow;
    } catch (err) {
      rethrow;
    }
  }

  static Future<List<FreeBusySlot>> getMutualAvailability(
    String targetUserId,
    String timeMin,
    String timeMax,
  ) async {
    try {
      final response = await _dio.post(
        '/google-calendar/mutual-availability',
        data: {
          'target_user_id': targetUserId,
          'time_min': timeMin,
          'time_max': timeMax,
        },
      );
      if (response.statusCode == 200) {
        final busySlots = response.data['busySlots'] as List<dynamic>? ?? [];
        return busySlots
            .map((e) => FreeBusySlot.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "something_went_wrong".tr,
      );
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        await UserStore.to.clearStore();
        Get.toNamed(RouteName.signInPage);
      }
      rethrow;
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> disconnect() async {
    try {
      final response = await _dio.delete('/google-calendar/disconnect');

      if (response.statusCode == 200) {
        return;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "something_went_wrong".tr,
      );
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        await UserStore.to.clearStore();

        Get.toNamed(RouteName.signInPage);
      }

      rethrow;
    } catch (err) {
      rethrow;
    }
  }
}
